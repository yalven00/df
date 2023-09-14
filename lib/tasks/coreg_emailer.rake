namespace :coreg_emailer do
  task :send_flatfile => :environment do
    puts "#{Time.now} -- Starting"
    Coreg.email_file.select(&:run_today?).each do |coreg|
      puts "#{Time.now} -- Processing #{coreg.name}"
      unemailed_optins = coreg.coreg_optins.where(:sent => false, :success => true)
      unless unemailed_optins.empty?
        File.open("#{Rails.root}/log/#{coreg.email_file_name}", 'w') do |file|
          unemailed_optins.each {|optin| file.puts optin.flat_file_row }
        end
        CoregMailer.coreg_email(coreg).deliver
        unemailed_optins.each {|x| x.update_attribute(:sent, true) }
      end
    end
    puts "#{Time.now} -- ending"
  end
end
