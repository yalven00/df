namespace :coreg do
  require 'csv'
  require 'net/sftp'
  require 'net/ftp'

  task :create_optins => :environment do
    list = File.open(ENV['sheet'])
    koreg = ENV['coreg_id']

    koreg_params = CoregParam.find_all_by_coreg_id(koreg)


    list.each_line do |email|
      if !CoregOptin.find_by_email_and_coreg_id(email, koreg)
        CoregOptin.create(:coreg_id=>coreg,:member_id=>Member.find_by_email(email).id)
      end
    end

  end


  desc "resending gerber leads"
  task :resend_gerber => :environment do
    # set sheet location vi rake variable
    sheet = Excelx.new ENV['sheet']
    new_time = (Time.now - 1.day).strftime('%Y/%m/%d')

    # some indexes
    index = 0
    good_leads = 0
    bad_leads = 0

    #open / create log fiels for leads and results
    good_log = File.open("log/good_leads_#{Time.now.strftime('%Y-%m-%d')}.csv", "a")
    bad_log = File.open("log/bad_leads_#{Time.now.strftime('%Y-%m-%d')}.csv", "a")

    # write header row to both log files
    good_log.write("query,response\n")
    bad_log.write("query,response\n")

    #begin loop to resend leads.
    # start at 1st row and go to last row of sheet.
        #2013-03-13
    24000.upto(25250) do |line|
          # set variables to hold url info from sheet.
          # uri  is the base url
          # param_list is the concatenation  of all params the client requests.

          uri = sheet.cell(line,'A')+"rc=cp&rti=z7906&b=y&acq_medium=Coreg&acq_name=Deals%20for%20Mommy%20-%20Grow%20Up&acq_source=DealsForMommy-GrowUp"
  		    param_list = sheet.cell(line, 'B')
          param_list.gsub!(/(acq_optindate=)\d{4}\/\d{2}\/\d{2}/,"acq_optindate=#{new_time}")

          url =  uri + param_list
          # send the request to client via RestClient post method
          # RestClient.post accepts 3 paramaters +  a block but only requires 2, uri and paramaters.

          #puts"#{url} \n"

          request = RestClient.get(url)

          # Here we check to see if the request is Successfull bia the request body.
          # request body is the response given from the client after post is peformed
          # we route the leads accordingly. Good to good_log and bad to bad_log
          # both logs will contain both the full request string and full response.

          if request.body =~ /Success/ || request.body =~ /OK/
            good_log.write("#{uri+param_list},#{request.body}\n")
            index = index+1
            good_leads = good_leads+1
            puts "sent #{good_leads} good lead(s) | sheet row #{index + 1988}"
          else
            bad_log.write("#{uri+param_list},#{request.body}\n")
            index = index+1
            bad_leads = bad_leads+1
            puts "sent #{bad_leads} bad lead(s)  | sheet row #{index + 1988}"
          end
        end
      good_log.write("#{good_leads}, #{index}")
      bad_log.write("#{bad_leads}, #{index}")
      good_log.close()
      bad_log.close()
      puts "total leads submitted #{index}"
      puts "total good leads submitted #{good_leads}"
      puts "total bad leads submitted#{bad_leads}"

      puts "you can find the log files for the leads in the log directory of your local deals for mommy install"

  end
  desc "similar to emailing coregs, this task will upload a file to a sftp site and send an email out when complete."
  task :sftp_upload => :environment do
    puts "#{Time.now} -- Starting"
    Coreg.where('request_method = ?','sftp').select(&:run_today?).each do |coreg|
      puts coreg.name
      puts "#{Time.now} -- Processing #{coreg.name}"

      credentials = YAML.load(coreg.headers)
      unemailed_optins = coreg.coreg_optins.where(:sent => false, :success => true)


      unless unemailed_optins.empty?

        File.open("#{Rails.root}/log/#{coreg.email_file_name}", 'w') do |file|

          if credentials.include?("header_row")
            file.puts (coreg.coreg_params.map{|x| x.name}).join(credentials["delimiter"])
          end

          unemailed_optins.each {|optin| file.puts optin.sftp_flat_file_row(credentials["delimiter"]) }
        end

        # remove verbose mode to not log out the sftp transaction
        Net::SSH.start(credentials["host"], credentials["username"], :password=>credentials["password"], :verbose => Logger::DEBUG) do |ssh|
         ssh.sftp.upload!("log/#{coreg.email_file_name}", "#{credentials["dir"]}#{coreg.email_file_name}")
        end

        unemailed_optins.each {|x| x.update_attribute(:sent, true) }
        CoregMailer.coreg_email(coreg).deliver

      end
    end

    puts "#{Time.now} -- ending"

  end


end
