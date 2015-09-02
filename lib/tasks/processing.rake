namespace :process do
  desc "Run the next available pdf"
  task :next_pdf => :environment do
    InDesign.process_next_pdf_job
    end

  desc "Run the next available email"
  task :next_email => :environment do
    InDesign.process_next_email_job
  end

  desc "Check and change the status of processed jobs"
  task :find_processed_jobs => :environment do
    InDesign.find_processed_jobs
  end

  desc "Get processed jobs"
  task :get_processed_jobs => :environment do
    InDesign.get_processed_jobs
  end
end