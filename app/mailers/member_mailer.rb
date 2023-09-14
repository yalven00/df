class MemberMailer < ActionMailer::Base
  default :from => "no-reply@dealsformommy.com"
  def recover_email(member)
		@user = member
	  @url  = "http://dealsformommy.com/reset_password?token=#{member.generate_token}"
    mail(:to => member.email, :subject => "Deals For Mommy Password Reset")
  end

	# Advertisers request form
	def advertiser_email(advertiser_form)
		@advertiser_form = advertiser_form
		mail(:to => 'steve@parentmediainc.com, seth@parentmediainc.com',
		:subject => 'Feature My Deal')
	end
end
