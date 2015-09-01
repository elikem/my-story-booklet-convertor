class Mailer < ApplicationMailer
  default from: 'tsw@cru.org'

  def send_pdf_to_user(job_id)
    @job = Job.find(job_id)
    @file = "#{Rails.root}/storage/users/#{@job.username}/#{@job.username}_#{@job.publication_id}.pdf"
    @file_name = "#{@job.username}_#{@job.publication_id}"

    attachments[@file_name] = { mime_type: 'application/x-gzip', content: File.read(@file)  }

    mail(to: "#{@job.email}", subject: "My Story Booklet PDF for #{@job.email}")
  end
end


