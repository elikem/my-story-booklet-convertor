class InDesign
  require 'fileutils'
  require 'open3'

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
          abort message
        end
      end
    end
  end

  def self.process_next_pdf_job
    job = Job.where(pdf_status: false).order(created_at: :asc).first

    if job
      InDesign.new.idml_to_pdf(job.id)
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

      message = "#{Time.zone.now.localtime} -- Emailed PDF to #{job.username}"
      puts message
      SLACK_NOTIFIER.ping message
    end
  end

  def self.process_next_email_job
    job = Job.where(email_status: false).order(created_at: :asc).first

    if job
      InDesign.new.pdf_to_email(job.id)
    end
  end

  def self.find_processed_jobs
    jobs = Job.where('(email_status = ? and pdf_status = ?) and status = ?', true, true, false)

    jobs.each do |job|
      job.status = true
      job.save
    end
  end

  def self.get_processed_jobs
    message = "#{Time.zone.now.localtime} -- Checking for processed jobs"
    puts ''
    puts message
    puts ''

    puts "!!!!!!!!!!"
    get_published_stories = system('curl http://localhost:3000/jobs/get_published_stories')
    puts "!!!!!!!!!!"

    puts get_published_stories

    if get_published_stories
      SLACK_NOTIFIER.ping message
    else
      SLACK_NOTIFIER.ping 'Unable to reach server for new jobs'
      
    end
  end
end
