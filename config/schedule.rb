env :PATH, ENV['PATH']
env :GEM_PATH, '/usr/local/rvm/gems/ruby-1.9.2-p180:/usr/local/rvm/gems/ruby-1.9.2-p180@global'
set :cron_log, "/var/log/coreg_sent.log"

every 1.day, :at => '7:00 am' do
  rake 'coreg_emailer:send_flatfile'
end

every 1.day, :at => '7:00 am' do
  rake 'coreg:sftp_upload'
end

every 1.month, :at => "beginning of the month at 3am" do
   rake 'carnie:dfm_only'
end

every 1.day, :at => '12:01 am' do # Use any day of the week or :weekend, :weekday
  runner "ReportMailer.subid.deliver"
end
