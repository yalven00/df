require 'csv'

class ReportMailer < ActionMailer::Base
  default :from => "no-reply@dealsformommy.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.subid.subject
  #

  def carnie_dfm_members
    addresses=['Becky@carneydirect.com','adevito@parentmediainc.com','Scott@carneydirect.com','Adam@parentmediainc.com','chris@parentmediainc.com']
    #addresses=['adevito@parentmediainc.com','chris@parentmediainc.com']
    mail(:to =>'steve@parentmediainc.com',
         :cc => addresses,
    :subject => 'DFM Carnie Monthly Members')
	end

  def subid
    @members = Member.includes(:coreg_optins => :coreg).includes(:address).
      where(['members.created_at < ? AND members.created_at > ?', DateTime.now, DateTime.now - 1.day ]).
      select("members.id, affiliate_id, affiliate_sub_id, first_name, last_name, members.email, DATE_FORMAT(members.created_at, '%Y/%m/%d') as created, postal_code").
      order("members.created_at, affiliate_id, affiliate_sub_id")

    # group all the optins by affiliate id and then sub id, and summarize
    @member_groups = @members.group_by(&:affiliate_id).inject({}) do |memo1, (k1,v1)|
      memo1[k1] = v1.group_by(&:affiliate_sub_id).inject({}) do |memo, (k,v)|
        memo[k] = [v.size, v.sum(&:revenue), v.sum(&:offers_taken), v.sum(&:revenue)/v.size]
        memo
      end.sort_by {|k, v| -v[3]}
      memo1
    end

    file_path = "log/subid-report-#{Date.today.strftime('%F')}.csv"
    CSV.open(file_path, "w") do |csv|
      csv << ["affiliate id", "sub id", "created on", "first name", "last name", "email", "city", "state", "zip", "revenue", "offers taken"]
      @members.each do |member|
        data = [:affiliate_id, :affiliate_sub_id, :created, :first_name, :last_name, :email, :postal_code, :revenue, :offers_taken].collect {|m| member.send(m)}
        data.insert 6, member.address.try(:city), member.address.try(:state)
        csv << data
      end
    end
    attachments['subid_detail_report.csv'] = File.read(file_path)

    mail :to => Rails.env.production? ? "steve@parentmediainc.com, jack@parentmediainc.com, adam@parentmediainc.com" : "jack@parentmediainc.com", :subject => 'DealsForMommy SubId Weekly Report'
  end
end
