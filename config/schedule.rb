# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "#{Whenever.path}/log/whenever.log"

every 2.minute do
  rake "process:next_pdf"
end

every 1.minute do
  rake "process:next_email"
end

every 5.minute do
  rake "process:process_published_stories"
end

every 5.minute do
  rake "process:update_status_of_emailed_and_pdfed_jobs"
end

every 2.weeks do
  rake "log:clear"
end