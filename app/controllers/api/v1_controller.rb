class Api::V1Controller < ApplicationController
  before_filter :auth
  respond_to :xml, :json

  def member
		####################################################
		#
		# Example:
		# /api/v1/member.xml?
		# api_key={key}
		# member[first_name]={first name}&
		# member[last_name]={last name}&
		# member[gender]={gender M || F}&
		# member[email]={email}&
		# member[postal_code]={postal code}&
    # member[ip_address]={ip_address}&
    # member[partner]={partner}
		#
		####################################################

    @member = Member.new(params[:member])
		partner = Partner.find_by_api_key(params[:api_key])
		@member.partner_id = partner.id
    if @member.save
			#save member to email vision
			extras = {
				"EMAIL_ORIGINE_FIELD"	=> @member.email, # original email saved
				"SIGNUP_SITE_FIELD"	=> params[:partner]
			}
			#em = Emailvision.new
			#	em.subscribe(list_id, @member, extras)
			#ew = Eway.new
      #ew.ck_subscribe(@member, params[:partner])
      Resque.enqueue(EwaySender, :ck_subscribe, @member.id, params[:partner])

      respond_with :member => @member
    else
      respond_with :error => @member.errors
    end
  end

  private

  def auth
		respond_with :error => 'unable to auth' unless Partner.authenticate?(params[:api_key])
  end

end
