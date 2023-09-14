class CoregMailer < ActionMailer::Base
  default :from => "no-reply@dealsformommy.com"
  def coreg_email(coreg)

    if coreg.sftp?
      if Rails.env.production?
        mail(:to => coreg.endpoint,
             :cc => 'steve@parentmediainc.com, seth@parentmediainc.com, chris@parentmediainc.com, adevito@parentmediainc.com',
             :body => "File has been uploaded to your server.\nFilename: #{eval(coreg.flatfile_pattern)}",
             :subject => "Deals For Mommy Coreg Optins")
      else
        mail(:to => 'adevito@parentmediainc.com',
             :body => "File has been uploaded to your server.\nFilename: #{eval(coreg.flatfile_pattern)}",
             :subject => "Deals For Mommy Coreg Optins [#{Rails.env}]")
      end
    else
      attachments[coreg.email_file_name] = File.read("#{Rails.root}/log/#{coreg.email_file_name}")

      puts "#{Rails.root}/log/#{coreg.email_file_name}"


      if Rails.env.production?
        mail(:to => coreg.endpoint,
           :cc => 'steve@parentmediainc.com, seth@parentmediainc.com, jack@parentmediainc.com, adevito@parentmediainc.com',
           :body => 'Please see the attached coreg data file',
           :subject => "Deals For Mommy Coreg Optins")
      else
        mail(:to => 'adevito@parentmediainc.com',
           :body => 'Please see the attached coreg data file',
           :subject => "Deals For Mommy Coreg Optins [#{Rails.env}]")
      end
    end
  end

end
