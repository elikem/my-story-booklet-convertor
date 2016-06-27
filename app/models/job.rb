# == Schema Information
#
# Table name: jobs
#
#  id             :integer          not null, primary key
#  story_id       :integer
#  username       :string
#  email          :string
#  status         :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  email_status   :boolean          default(FALSE)
#  pdf_status     :boolean          default(FALSE)
#  publication_id :string
#

class Job < ActiveRecord::Base
  require 'fileutils'
  require 'open-uri'
  require 'open3'

  after_create :notify_slack

  validates_uniqueness_of :publication_id
  validates_presence_of :publication_id

  def notify_slack
    SLACK_NOTIFIER.ping "#{Time.zone.now.localtime.strftime('%Y-%m-%d %H:%M:%S')} -- Job created for #{self.username}"
  end

  def users_folder
    "#{Rails.root}/storage/users"
  end

  def get_published_jobs_from_api
    message = "#{Time.zone.now.localtime.strftime('%Y-%m-%d %H:%M:%S')} -- Checking for processed jobs"
    puts ''
    puts message
    puts ''

    get_published_stories = HTTParty.get('http://www.mystorybooklet.com//api/published_stories')

    unless get_published_stories
      SLACK_NOTIFIER.ping 'Unable to reach server for new jobs'
    end

    get_published_stories
  end

  def update_status_of_emailed_and_pdfed_jobs
    jobs = Job.where('(email_status = ? and pdf_status = ?) and status = ?', true, true, false)

    jobs.each do |job|
      job.status = true
      job.save
    end
  end

  def process_next_email_job
    # Find a job where the pdf file exits
    job = Job.where('email_status = ? and pdf_status = ?', false, true).order(created_at: :asc).first

    if job
      pdf_to_email(job.id)
    end
  end

  def process_next_pdf_job
    job = Job.where(pdf_status: false).order(created_at: :asc).first

    if job
      idml_to_pdf(job.id)
    end
  end

  def pdf_to_email(job_id)
    job = Job.find(job_id)
    users_folder = "#{Rails.root}/storage/users"
    file_name = "#{job.username}_#{job.publication_id}"
    user_file = "#{users_folder}/#{job.username}/#{file_name}.pdf"

    if File.exists? user_file
      Mailer.send_pdf_to_user(job_id).deliver_now

      # Update Email status
      job.email_status = true
      job.save

      message = "#{Time.zone.now.localtime.strftime('%Y-%m-%d %H:%M:%S')} -- Emailed PDF to #{job.username}"
      puts message
      SLACK_NOTIFIER.ping message
    end
  end

  def idml_to_pdf(job_id)
    job = Job.find(job_id)
    users_folder = "#{Rails.root}/storage/users"
    file_name = "#{job.username}_#{job.publication_id}"
    user_file = "#{users_folder}/#{job.username}/#{file_name}.idml"
    idml_to_pdf_epub_script = "#{Rails.root}/lib/idml_to_pdf_epub.scpt"

    if File.exists? user_file
      cmd = "osascript #{idml_to_pdf_epub_script} #{users_folder}/#{job.username}/ #{file_name}"

      Open3.popen2e(cmd) do |stdin, stdout_err, wait_thr|
        while line = stdout_err.gets
          puts "StdOutErr: " + line
        end

        exit_status = wait_thr.value
        if exit_status.success?
          # Update PDF status
          job.pdf_status = true
          job.save

          message = "#{Time.zone.now.localtime.strftime('%Y-%m-%d %H:%M:%S')} -- Created PDF for #{job.username}"
          puts message
          SLACK_NOTIFIER.ping message
        else
          message = "#{Time.zone.now.localtime.strftime('%Y-%m-%d %H:%M:%S')} -- Failed PDF Job for #{job.username}"
          SLACK_NOTIFIER.ping message

          # Delete job and file as a result of failure, its possible that the file is corrupt
          job.destroy
          system("rm #{user_file}")

          # Exit with message
          abort message
        end
      end
    end
  end

  # HTTParty.get('http://example.com', headers: {"User-Agent" => APPLICATION_NAME})
  def story_for_idml(username)
    HTTParty.get("http://www.mystorybooklet.com//api/stories/#{username}/idml")
  end

  def create_user_folder_and_file(username, publication_id)
    # check if user folder exists and create if it doesn't
    FileUtils.mkdir_p "#{users_folder}/#{username}"
    system("cp -R #{Rails.root}/lib/assets/Links #{users_folder}/#{username}")

    # download file if it does not exist
    unless File.exists? "#{users_folder}/#{username}/#{username}_#{publication_id}.idml"
      # if files don't exist for a record that does then update that record and add new files
      job = Job.where(publication_id: publication_id).first
      if job
        job.update(email_status: false, pdf_status: false)
      end

      File.open("#{users_folder}/#{username}/#{username}_#{publication_id}.idml", 'wb') do |f|
        f.write(open("https://s3.amazonaws.com/my-story-booklet/users/#{username}/#{publication_id}.idml").read)
      end
    end
  end

  def process_published_stories
    stories = get_published_jobs_from_api

    stories.each do |story|
      Job.create(
          story_id: story['story_id'],
          publication_id: story['publication_id'],
          username: story['username'],
          email: story['email']
      )

      create_user_folder_and_file(story['username'], story['publication_id'])
    end
  end
end
