class InDesign
  require 'fileutils'
  require 'open3'

  def self.idml_to_pdf(job_id)
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
          "Passed: IDML to PDF -- Job #{job_id}"
        else
          abort "Failed: IDML to PDF -- Job #{job_id} -- #{cmd}"
        end
      end
    end
  end
end
