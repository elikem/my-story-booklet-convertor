class InDesign
  require 'fileutils'

  def self.idml_to_pdf(job_id)
    job = Job.find(job_id)
    users_folder = "#{Rails.root}/storage/users"
    file_name = "#{job.username}_#{job.publication_id}"
    user_file = "#{users_folder}/#{job.username}/#{file_name}.idml"
    idml_to_pdf_epub_script = "#{Rails.root}/lib/idml_to_pdf_epub.scpt"

    if File.exists? user_file
      system(" osascript #{idml_to_pdf_epub_script} #{users_folder}/#{job.username}/ #{file_name} ")
    end
  end
end
