namespace :process do
  desc 'Run the next available pdf'
  task :next_pdf => :environment do
    Job.new.process_next_pdf_job
  end

  desc 'Run the next available email'
  task :next_email => :environment do
    Job.new.process_next_email_job
  end

  desc 'Check and change the status of jobs that have being emailed and pdfed'
  task :update_status_of_emailed_and_pdfed_jobs => :environment do
    Job.new.update_status_of_emailed_and_pdfed_jobs

  end

  desc "Process published stories from my story booklet API"
  task :process_published_stories => :environment do
    Job.new.process_published_stories
  end

  desc "Delete a Job using it's Publication ID - rake process:delete_job_using_publication_id[Vl4ce12ftuvk0_j9008MGg]"
  task :delete_job_using_publication_id, [:pub_id] => :environment do |t, args|
    job = Job.new.find_by_publication_id(args[:pub_id])
    if job
      job.destroy
    end
  end
end