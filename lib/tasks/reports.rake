require 'net/ftp'
require 'net/sftp'
require 'csv'

namespace :carnie do
  desc "gets dfm only members"
  task :dfm_only => :environment do

    headers=""
    partial_member_headers="MemberId\tFirst Name\tLast Name\tZip Code\n"
    #members = Member.where('partner_id = ? AND created_at > ? AND created_at < ?', 0,"2011-04-19","2013-03-01")
    members = Member.where('partner_id = ? AND created_at > ? AND created_at < ?', 0,Time.now.beginning_of_month-1.month,Time.now.end_of_month-1.month)

    #log file and there paths
    carnie_full_file_path = "log/carnie_full_#{Time.now.strftime('%Y-%m-%d')}.txt"
    full_member_log = File.open(carnie_full_file_path,"w+")

    carnie_partial_file_path ="log/carnie_partial_#{Time.now.strftime('%Y-%m-%d')}.txt"
    partial_member_log = File.open(carnie_partial_file_path,"w+")

    col_names = {
    :id => ['MemberId',11],
    :firstname => ['First Name',25],
    :lastname => ['Last Name',25],
    :address1 => ['Address',35],
    :city => ['City',20],
    :state => ['State',2],
    :zipcode => ['Zip Code',9],
    :country => ['Country',40],
    :created_at => ['Reg Date',20],
    :ip_address => ['IP',15],
    :child_dob => ['Child Birth Date 1',10],
    :dob => ['Parent Birthdate  1',10],
    :gender =>['Parent Gender 1',1]
    }
    col_names.each do |k,v|
      headers = headers+"#{v[0]}\t"
    end

    full_member_log.write("#{headers}\n")
    partial_member_log.write("#{partial_member_headers}\n")

    members.each do |member|
      puts member.id
      if !member.nil?
          if member.fully_registered? && member.child.dob!=nil
             full_member_log.write("#{(member.id.to_s)[0..10]}\t#{ !member.first_name.nil? ? (member.first_name)[0..24] : ''}\t#{!member.last_name.nil? ? (member.last_name)[0..24] : ''}\t#{!member.address.address1.nil? ? (member.address.address1)[0..34] : ''}\t#{!member.address.city.nil? ? (member.address.city)[0..19] : ''}\t#{!member.address.state.nil? ? (member.address.state) : ''}\t#{!member.address.postal.nil? ? (member.address.postal)[0..8] : ''}\t#{!member.address.country.nil? ? (member.address.country)[0..39] : ''}\t#{(member.created_at.strftime('%Y/%m/%d %H:%M:%S'))[0..24]}\t#{(member.ip_address)[0..14]}\t#{(member.child.dob.nil? ? '' : member.child.dob.strftime('%m/%d/%Y').to_s)[0..24]}\t#{(member.dob.nil? ? '' : member.dob.strftime('%m/%d/%Y').to_s)[0..24]}\t#{(member.gender)}\n")
            puts "added full member #{member.id}"
          else
            partial_member_log.write("#{(member.id.to_s)[0..10]}\t#{(member.try(:first_name))[0..24]}\t#{(member.try(:last_name))[0..24]}\t#{(member.try(:postal_code))[0..8]}\t\n")
            puts "added partial member #{member.id}"
          end
         else
           puts "broken member"
         end
      end

    partial_member_log.close()
    full_member_log.close()


    #open ftp connection to drop file.
    conn = Net::FTP.open('216.237.7.211','Upload','#upload')
      conn.putbinaryfile(carnie_partial_file_path)
      conn.putbinaryfile(carnie_full_file_path)
    conn.close
    ReportMailer.carnie_dfm_members.deliver

  end

  desc "get partial members"
  task :dfm_partial => :environment do
    partial_member_headers="MemberId\tFirst Name\tLast Name\tZip Code\n"
    members = Member.where('partner_id = ? AND created_at > ? AND created_at < ?', 0,"2011-04-19","2013-03-01")

    carnie_partial_file_path ="log/carnie_partial_#{Time.now.strftime('%Y-%m-%d')}.txt"
    partial_member_log = File.open(carnie_partial_file_path,"w+")

    partial_member_log.write("#{partial_member_headers}\n")

    members.each do |member|

      if member.password.nil?
          partial_member_log.write("#{(member.id.to_s)[0..10]}\t#{(member.first_name)[0..24]}\t#{(member.last_name)[0..24]}\t#{(member.postal_code)[0..8]}\t\n")
          puts "added partial member"
      end
    end

    partial_member_log.close()

    #open ftp connection to drop file.
    conn = Net::FTP.open('216.237.7.211','Upload','#upload')
      conn.putbinaryfile(carnie_partial_file_path)
    conn.close
    ReportMailer.carnie_dfm_members.deliver


  end
end
