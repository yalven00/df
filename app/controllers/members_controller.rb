class MembersController < ApplicationController
  # Member Home Page

  def home
    deny_access and return unless signed_in_dfm?
     @show =1
    #TODO Session member_id becomes nil, when coming from step 3 to the home page
    session[:member_id] = current_member.id if session[:member_id].nil?

    @title = "Hi #{current_member.first_name}"
		@show_deals = false
    unless params[:divisions].nil?
      session[:division_request] = params[:divisions]
    end

    @groupon_deals, @yummy_deals, @groupon_divisions = groupon_deals.dup, yummy_deals, groupon_divisions.dup
		unless @groupon_deals.empty?
			@show_deals = true
			@featured = @groupon_deals.shift
			@other_deals = @groupon_deals - @yummy_deals
	    @location_display = @featured.division.name
			@division_id = @featured.division.id
		end
		@postal =	current_member.address.nil? ? current_member.postal_code : current_member.address.postal
    if session[:division_request].nil?
		  unless current_member.nil? || current_member.address.nil?
				@location_display = current_member.address.city
      end
    end
  end

  # Full Registration page
  def step_two
    @converted = true # for google site optimizer
    @title = 'Join Now - Step 2'
    @js_key =  js_key('step2')
    if signed_in_dfm?
      redirect_to :home and return
    elsif session[:member_id].nil?
      flash[:info] = "You must sign up to access that page!"
      redirect_to :action => :new
    else
      @member = Member.find(session[:member_id])
      guess_address
			guess_child
			@member.check_dob = true
			extras = {
				"EMAIL_ORIGINE_FIELD"	=> @member.email,
				"SIGNUP_SITE_FIELD"	=> 'DFM'
			}

      #Coreg.where(:screen_key => 'http://www.dealsformommy.com/step2').each do |coreg|
      #  @member.coreg_optins.build :coreg => coreg
      #end

			#em = Emailvision.new
			#em.subscribe(@member, extras)
			#em.send_email(@member.email,'welcome')

			@google_conversion = true
    end
  end

  def step_three
    @title              = 'Join Now - Step 3'
    @member             = current_member #Member.find(session[:member_id])
    #session[:pontiflex] = true
    @js_key =  js_key('step3')
    @action = '/flow_step'
  end

  def promo

    #@member = Member.find(session[:member_id])
    promo = params[:promo]

    case promo

      when "cutekid"
        @title  = 'Join Now - theCuteKid.com'
        @next_deal = '/promo/carseat-canopy'
        @promo_link = 'http://affiliates.thecutekid.com/affiliate/affiliate.php?id=1796&group=38&subid=dfm3rdpgflw'
        render :file => "#{RAILS_ROOT}/app/views/members/promo.ck.html.erb"

      # when "canvaspeople"
      #   @title = 'Join Now - Canvaspeople.com'
      #   @next_deal = '/promo/seven-slings'
      #   @promo_link = 'http://www.canvaspeople.com/dealsformommy'
      #   render :file => "#{RAILS_ROOT}/app/views/members/promo.cp.html.erb"

      # when "pch"
      #   @title = 'Join Now - Publishers Clearing House'
      #   @next_deal = '/promo/qh'
      #   @promo_link = 'http://afclklt.pch.com/click.track?CID=228632&AFID=230423&ADID=851642&SID='
      #   render :file => "#{RAILS_ROOT}/app/views/members/promo.pch.html.erb"

      when "udder-covers"
        @title = 'Join Now - Udder Covers'
        @next_deal = '/promo/cutekid'
        @promo_link = 'http://www.uddercovers.com'
        render :file => "#{RAILS_ROOT}/app/views/members/promo.uc.html.erb"

      when "seven-slings"
        @title = 'Join Now - seven-slings'
        @next_deal = '/home'
        @promo_link = 'http://www.sevenslings.com'
        render :file => "#{RAILS_ROOT}/app/views/members/promo.ss.html.erb"

      when "carseat-canopy"
        @title = 'Join Now - Carseat Canopy'
        @next_deal = '/promo/seven-slings'
        @promo_link = 'http://www.carseatcanopy.com'
        render :file => "#{RAILS_ROOT}/app/views/members/promo.canopy.html.erb"

      when "qh"
        if signed_in_dfm?
          @member = Member.find(session[:member_id])
          @promo_link = "https://www.qualityhealth.com/registration?rf=73228&PARPID=0&qhfirstname=#{@member.first_name}&qhlastname=#{@member.last_name}&qhemail=#{@member.email}&qhaddress=#{@member.address.try(:address1)}&qhcity=#{@member.address.try(:city)}&qhstate=#{@member.address.try(:state)}&qhzipcode=#{@member.address.try(:postal)}&qhgender=#{@member.try(:gender)}&qhphone=&qhdateofbirth=#{@member.dob.strftime('%m-%d-Y') }"
        else
          @promo_link = "https://www.qualityhealth.com/registration?rf=73228&PARPID=0&qhfirstname=&qhlastname=&qhemail=&qhaddress=&qhcity=&qhstate=&qhzipcode=&qhgender=&qhphone=&qhdateofbirth="
        end
        @title = 'Join Now - Quality Health'
        @next_deal = '/promo/udder-covers'
        render :file => "#{RAILS_ROOT}/app/views/members/promo.qh.html.erb"

      #when "livingsocial"
      #  @title = 'Join Now - Livingsocial'
      #  @next_deal = '/promo/udder-covers'
      #  @promo_link = 'http://subscribe.livingsocial.com?ref=XUA0000PARE00WEBGRS0000ENUS0000000000000007122012'
      #  render :file => "#{RAILS_ROOT}/app/views/members/promo.livingsocial.html.erb"

      when "imp"
        @title = 'Deals for Mommy Members, Great children book offer!'
        @next_deal = '/promo/qh'
        @promo_link = 'http://www.fosinaoffers.com/z/16871/CD1963/Display'
        render :file => "#{RAILS_ROOT}/app/views/members/promo.#{promo}.html.erb"

      when "bsaving"
        @title = 'Deals for Mommy Members, Get coupons, freebies, gifts & more!'
        @next_deal = '/promo/imp'
        @promo_link = 'http://register.bSaving.com/DefaultPage.aspx?nm=01mgdvr6urxua5&s=DFMFLOW

'
        render :file => "#{RAILS_ROOT}/app/views/members/promo.#{promo}.html.erb"

    end
  end

  # GET /members/new
  def new
    if signed_in_dfm?
      @remarketing_pixel = false
    else
      @remarketing_pixel = true
    end
    redirect_to :action => 'home' if signed_in_dfm?
    @unconverted = true # for google site optimizer

    session[:form] =  params[:f] || 'partial_member' unless session.has_key?('form') # partial_member|full_form_member this is going to be modified according to some parameter

    session[:pm_form] = params[:x] unless session.has_key?('pm_form')


    if !params[:f].nil?
      session[:long_form_member] = 1
    end

    @js_key =  js_key('new')
    @title   = 'Find Deals, Coupons, & Samples Online From Top Brands at Deals For Mommy'
		@meta_keywords = 'coupons for mom, mom coupons, deals for mom, baby coupons, grocery coupons, diaper coupon, coupons online, huggies coupons, pampers coupons, gerber coupons, enfamil coupons, luvs coupons, pullups coupons, diaper coupon, printable coupons, baby formula coupons, baby diaper coupons, free coupons'
		@meta_description = 'Bringing local and online deals to one place for Moms. Get Baby Coupons, Grocery Coupons, Printable Coupons, Diaper Coupons, and Samples. Daily Deals for Moms.'
    @message = 'Edit Your Details:'
    @member  = Member.new
    @member.build_address
		guess_child
		@promo = params[:q] || ''
    @member_count, @joined_today = get_member_info
    @show_daily_promo = true
  end

  def edit
    @title = 'Edit Account'
    @js_key =  js_key('step2')
    deny_access and return unless signed_in_dfm?
    @member = Member.find(session[:member_id])
		@member.check_dob = true
		# Check if address is nil - partial members don't have a address
		# associated, so need to build the address
		guess_address
		guess_child
    @message = 'Edit Your Details:'
  end

  # POST /members
  def create
    @title   = 'Find Deals, Coupons, & Samples Online From Top Brands at Deals For Mommy'
    @member = Member.new(params[:member])
    @member.ip_address = request.remote_ip
		@promo = ''
    @js_key =  js_key('new')
    if ! session[:aff_utm].nil?
      aff_utm = session[:aff_utm]
      @member.affiliate_id  = aff_utm[0] # as per the HO pixel utm_content is affiliate id
      @member.affiliate_sub_id = aff_utm[1] # as per the HO pixel utm_term is affiliate_sub_id
    end
    @member.entrypath = session[:form] || ''
   # set for long form
   if( session[:form] != 'partial_member')
      @member.check_dob
      @member.updating_password = true
      @member.password              = params[:member][:password]
      @member.password_confirmation = params[:member][:password]
      @member.postal_code = params[:member][:address_attributes][:postal]
      unless @member.valid?
        @message = @member.errors[:password]
      end
   end

   # downcase the email to avoid duplication
   @member.email.downcase!

   #save member details
    if @member.save
      session.delete(:pm_form)
      Resque.enqueue(EwaySender, :dfm_subscribe, @member.id)
      # below is the logic to send the coreg info to totsy
      session[:member_id] = @member.id
      session[:new_member] = TRUE
      flash[:conversion_membership] = TRUE
      if( session[:form] != 'partial_member')
        sign_in_dfm(@member) unless signed_in_dfm?
        redirect_to :action => :step_three
      else
        redirect_to :action => :step_two
      end
    else
      @member_count, @joined_today = get_member_info
      @show_daily_promo = true
      render :action => :new
    end
  end

  def recover_password
		@title = 'Recover Password'
		@meta_description = 'In case of lost password, enter your email and we will email the password in a moment.'
		@meta_keywords = 'deals for mommy, mommy deals, daily deals for mom, deals for moms, coupon moms, coupons for mom, free diapers'
    if request.post?
      if params[:email] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
				@member = Member.where(:email => params[:email]).first #.where("password IS NOT ?", nil).first
				unless @member.blank?
					@message = 'An email will be sent to '+params[:email]+ '. Follow the instructions included in the email to complete the process.'
          #MemberMailer.recover_email(@member).deliver
          Resque.enqueue(EwaySender, :dfm_recover_pass, @member.id)
        else
          @message = 'Unable to locate email. Check email and try again'
        end
      else
        @message = 'Email is invalid. Try again'
      end
    end
  end

  def reset_password
		@title = 'Reset Password'
		@meta_description = 'Reset your password'
		@meta_keywords = 'deals for mommy, mommy deals, daily deals for mom, deals for moms, coupon moms, coupons for mom, free diapers'
    if request.post?
      @member                       = Member.find(session[:member_id])
      @member.updating_password     = true
      @member.password              = params[:member][:password]
      @member.password_confirmation = params[:member][:password_confirmation]
      if @member.valid?
        @member.save
				#em = Emailvision.new
				#em.update(@member)

        #ew = Eway.new
        #ew.dfm_update(@member)
        Resque.enqueue(EwaySender, :dfm_update, @member.id)
        Resque.enqueue(EwaySender, :cutekid_update, @member.id)

        sign_in_dfm(@member)
        flash[:notice] = 'Successfully updated password.'
        if params[:member][:redirect].nil?
        	redirect_to :action => 'home'
        else
        	redirect_to :coupons
        end
		else
		@message = @member.errors[:password][0].gsub('^','')
      end
    end
    auth_with_token
    #deny_access unless signed_in_dfm?
    @member = current_member
		@hide_members_link = true
  end

  def flow_step
    if (@full_page_coreg = Coreg.full_pages.first).present?
      @coreg_optin = @full_page_coreg.coreg_optins.build
      render :action => :full_page_coreg
    else 
      #redirect_to :action => :step_three
      redirect_to "/promo/bsaving"
    end
  end

  # PUT /members/1
  # PUT /members/1.xml
  def update
    @member = Member.find(session[:member_id])
		@member.check_dob = true
		if @member.password.nil?
			@member.updating_password = true
		end
    @js_key =  js_key('step2')
		if @member.update_attributes(params[:member])
			sign_in_dfm(@member) unless signed_in_dfm?
			#em = Emailvision.new
			#em.update(@member)
			#ew = Eway.new
      #ew.dfm_update(@member)
      Resque.enqueue(EwaySender, :dfm_update, @member.id)

			if session[:new_member] then
 				session[:new_member] = nil # unset session value
 				session[:thankyou_pixel]=1 #used to fire thankyou pixel for new user sign ups --devito
        redirect_to :action => :step_three #:flow_step
      else
				flash[:notice] = 'Successfully updated account details.'
				redirect_to :action => :home
			end
		else
			guess_address
			guess_child
			if signed_in_dfm?
				@message = 'Edit Your Details:'
				render :action => :edit
			else
				render :action => :step_two
			end
		end
	end

  def register_optin

  end 

	def retrieve
		@title = 'Recover Password'
	end

	## setup password
	def get_your_dashboard
		@show_deals = false
		@groupon_deals, @yummy_deals, @groupon_divisions = groupon_deals.dup, yummy_deals, groupon_divisions.dup
		unless @groupon_deals.empty?
			@show_deals = true
			@featured = @groupon_deals.shift
			@other_deals = @groupon_deals - @yummy_deals
			@location_display = @featured.division.name
			@division_id = @featured.division.id
		end
		auth_with_token
		#deny_access unless signed_in_dfm?
		if signed_in_dfm?
      @member = current_member
		  unless @member.password.nil?
			  redirect_to :home and return
      end
    end
		@hide_members_link = true
	end

	def unsubscribe
		@unsubscribe = false
		if request.post?
			#unsubscribe them
			if Unsubscribe.new(:email=>params[:a][:email]).save
				@message = "#{params[:a][:email]}. Email Unsubscribed"
			else
				@message = "Failed to unsubscribe email: #{params[:a][:email]}."
			end
			@unsubscribe = true
		end
	end

	private

	def get_member_info
		member_count = Rails.cache.fetch('member-count', :expires_in => 5.minutes) do
			Member.count
		end
		joined_today = Rails.cache.fetch('members-joined-today', :expires_in => 5.minutes) do
			Member.joined_past_24hr
		end
		[member_count, joined_today]
	end

	def guess_address
		if @member.address.nil?
			@member.build_address

			# Try postal code first
			geolocation = Geokit::Geocoders::MultiGeocoder.geocode(@member.postal_code)

			# if that doesn't work, try the ip address
			unless geolocation.success
				geolocation = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
			end

			if geolocation.success
				@member.address.city			= geolocation.city.strip
				@member.address.state			= geolocation.state.strip
				@member.address.postal		= geolocation.zip.strip || @member.postal_code.strip
			  @member.address.country   = geolocation.country_code
			end
		end
	end

	def guess_child
		if @member.child.nil?
			@member.build_child
		end
  end

end
