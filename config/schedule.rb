# Use this file to easily define all of your cron jobs.
#
set :environment, "development" # Change to 'production' in production environment
set :output, "log/cron_log.log"  # Log file for cron jobs
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


every 1.day, at: '12:00 am' do
  runner "Medicine.update_expired_medicines"
end

every 1.day, at: '12:00 am' do
  runner "MedicineAlertNotificationJob.perform_now"
end
# Learn more: http://github.com/javan/whenever
