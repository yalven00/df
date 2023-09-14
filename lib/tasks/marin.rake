require 'net/ftp'
require 'net/sftp'
require 'csv'

namespace :marin do
  task :send_coregs_data => :environment do

    #return unless Rails.env.production?
    #record the time and file name
    now = Time.now
    file_full_path = "#{Rails.root}/log/bulkrevenueadd_#{now.strftime('%Y%m%d')}.txt"

    # create the tab-delimited csv file 
    CSV.open(file_full_path, "w", {:col_sep => "\t"}) do |csv|
      #CoregOptin.where(:success => true).includes(:member).each do |optin|
      csv << ['Date', 'Keyword ID', 'Creative ID', 'Co-Registrations Conv', 'Co-Registrations Rev']
      Member.where(:created_at => (now-1.day)..now).includes(:coreg_optins).each do |m|
        unless (m.affiliate_sub_id =~ /^(\S+)\|mkwid\|(\S+)\|pcrid\|(\S+)$/).nil?
          csv << [now.strftime('%m/%d/%Y'), $2, $3, m.offers_taken, m.revenue]
        end
      end
    end

    # deposit the file to marin ftp server
    ftp = Net::FTP.new('integration.marinsoftware.com')
    ftp.login("revupload@pmg.com","8FrNHru7")
    ftp.chdir('/4438pj420635')
    ftp.puttextfile(file_full_path)
    ftp.close
    puts "main upload finished from #{file_full_path}"
  end
end

