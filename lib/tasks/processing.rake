namespace :process do
  desc "Run the next available pdf"
  task :next_pdf => :environment do
    InDesign.process_next_pdf_job
    end

  desc "Run the next available email"
  task :next_email => :environment do
    InDesign.process_next_email_job
  end
end