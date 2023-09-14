require 'hashie'
Hash.send :include, Hashie::HashExtensions

class << Hashie::Mash
  def method_missing(method_name, *args, &blk)
    
    super method_name, *args, &blk
  end
end

class Emailvision
	include HTTParty	
	base_uri "https://p4apie.emv3.com"
	format :json
	@token = ''
	
	EMAILTYPES = {
		'welcome' => {
			'random-tag'		=> '8E5135E978080001',
			'security-tag'	=> 'EdX7CqkmjW_B8SA9MOPv0GnfXUl7H6i28z_Ve6E2WMDYKzA',
			'id'						=> '24410',
			'synchrotype'		=> 'NOTHING' #NOTHING, INSERT, UPDATE, INSERT_UPDATE
		}
	}
	
	def open
		resource = Hashie::Mash.new(HTTParty.get("https://p4apie.emv3.com/apimember/services/rest/connect/open/dealsformommyAPI/em@1lvision/CdX7CrVC6FCDgkZSQs8gtpeeWSwDJvieijmBPfB1AZ-HLk-f-Y6wElpnLg")).response
		if resource.responseStatus == "success"
			@token = resource.result
		end
	end

	def insert(email)
		Hashie::Mash.new(HTTParty.get("https://p4apie.emv3.com/apimember/services/rest/member/insert/#{@token}/#{email}"))
	end

	def single_update(email,attributes_hash)
		parameters = ''
		attributes_hash.each do |k,v|
			parameters += "/#{k}/#{v}"
		end
		Hashie::Mash.new(HTTParty.post("https://p4apie.emv3.com/apimember/services/rest/member/update/#{@token}#{parameters}"))
	end
	
#	def update(email, attributes_hash)
#		
#		attributes = ''
#		attributes_hash.each do |k,v|
#			attributes += "<entry><key>#{k}</key><value>#{v}</value></entry>"
#		end
#		
#		options = {
#			:body => "<synchroMember><email>#{email}</email><dynContent>#{attributes}</dynContent></synchroMember>",
#			:headers => {'content-type'=>'application/xml'}
#		}
#
#		begin
#			Hashie::Mash.new(HTTParty.post("https://p4apie.emv3.com/apimember/services/rest/member/updateMember/#{@token}", options ))
#		rescue Exception => e
#			Rails.logger.debug "Exception Raised updating member #{options}"
#		end
#	end
	
	def insert_or_update(email, attributes_hash={})
		
		attributes = ''
		attributes_hash.each do |k,v|
			attributes += "<entry><key>#{k}</key><value>#{v}</value></entry>"
		end
		
		options = {
			:body => "<synchroMember><memberUID><email>#{email}</email></memberUID><dynContent>#{attributes}</dynContent></synchroMember>",
			:headers => {'content-type'=>'application/xml'}
		}

		begin
			Hashie::Mash.new(HTTParty.post("https://p4apie.emv3.com/apimember/services/rest/member/insertOrUpdateMember/#{@token}", options ))
		rescue Exception => e
			Rails.logger.debug "Exception Raised updating member #{options}"
		end
		
	end
	
	def close
		Hashie::Mash.new(HTTParty.get("https://p4apie.emv3.com/apimember/services/rest/connect/close/#{@token}"))
	end
	
	def send_email(email, type, time_to_send='', options={})	
		# check for timeToSend
		if time_to_send.blank?
			time_to_send = CGI::escape(Time.new.strftime('%Y-%m-%d %H:%M:%S'))
		end
		# check for options
		unless options.empty?
			params = Array.new
			options.each do |k,v|
				params.push("#{k}:#{v}")
			end
			options = params.join('|')
		else
			options = ''
		end
	
		begin
			Rails.logger.debug("http://api.notificationmessaging.com/NMSREST?random=#{EMAILTYPES[type]['random-tag']}&encrypt=#{EMAILTYPES[type]['security-tag']}&email=#{email}&senddate=#{time_to_send}&uidkey=#{email}&stype=#{EMAILTYPES[type]['synchrotype']}&dyn=#{options}" )
			HTTParty.get("http://api.notificationmessaging.com/NMSREST?random=#{EMAILTYPES[type]['random-tag']}&encrypt=#{EMAILTYPES[type]['security-tag']}&email=#{email}&senddate=#{time_to_send}&uidkey=#{email}&stype=#{EMAILTYPES[type]['synchrotype']}&dyn=#{options}")
		rescue
			Rails.logger.debug "Exception raised to email"
		end
	end
	
	def post_web_form(url, fields={})
		Rails.logger.debug("#{url}")
		Rails.logger.debug("#{fields}")
		# check for options
		unless fields.empty?
			params = Array.new
			fields.each do |k,v|
				params.push("#{k}=#{v}")
			end
			options = params.join('&')
		else
			options = ''
		end
		Rails.logger.debug(URI.encode("#{url}&#{options}"))
		HTTParty.get(URI.encode("#{url}&#{options}"))
	end
	
	def update(member, extras={})
		attributes_hash = form_attributes(member, extras)
		post_web_form('http://p4tre.emv3.com/D2UTF8?emv_tag=80007AA802291800&emv_ref=EdX7CqkmjTkZ8SA9MOPv0GnfKEx6G9yy8jjfeaA3UMDZK5A',attributes_hash)
	end
	
	def subscribe(member, extras={})
		attributes_hash = form_attributes(member, extras)
		post_web_form('http://p4tre.emv3.com/D2UTF8?emv_tag=1F17E0A5980081F1&emv_ref=EdX7CqkmjTlJ8SA9MOPv0GnWXk19aa2y_zHVe6k-WbbYK_Q',attributes_hash)
	end
	
	def form_attributes(member,extras={})
		begin
			sdob, member_password_link  = ''
			password = 'T'
			# modify the date of birth
			unless member.dob.nil?
				sdob = member.dob.strftime '%m/%d/%Y'
			end
			
			# check password and pass member_password_link
			if member.password.nil?
					password = 'F'
					member_password_link = "http://www.dealsformommy.com/get-your-dashboard?token=#{member.generate_token}"
			end
			
			# check environment to set unique id
			if Rails.env.production?
				clienturn = 'DM_PROD_' + member.id.to_s
			else
				clienturn = 'DM_DEVL_' + member.id.to_s
			end
			# Build Member Information Hash
			attributes_hash ={
				"EMAIL_FIELD"				=> member.email,
				"CLIENTURN_FIELD"		=> clienturn,
				"FIRST_NAME_FIELD"	=> member.first_name,
				"LAST_NAME_FIELD"		=> member.last_name,
				"POSTAL_CODE_FIELD" => member.postal_code,
				"GENDER_FIELD"			=> member.gender,
				"PARENT_BDAY_FIELD" => sdob,
				"PASSWORD_FIELD"		=> password,
				"IP_ADDRESS_FIELD"	=> member.ip_address,
				"CREATE_PASSWORD_LINK_FIELD" => member_password_link
			}
			
			# Build Member Address Hash
			unless member.address.nil?
				attributes_hash.merge!({
					"ADDRESS1_FIELD"	=> member.address.address1,
					"ADDRESS2_FIELD"	=> member.address.address2,
					"CITY_FIELD"			=> member.address.city,
					"STATE_FIELD"			=> member.address.state,
					"POSTAL_FIELD"		=> member.address.postal,
					"COUNTRY_FIELD"		=> member.address.country,
					"PHONE_FIELD"			=> member.address.phone,
					"LAT_FIELD"				=> member.address.lat,
					"LNG_FIELD"				=> member.address.lng
				})
			end
			
			# Build Member Child Hash
			unless member.child.nil?
				unless member.child.dob.nil?
					cdob = member.child.dob.strftime '%m/%d/%Y'
				end
				attributes_hash.merge!({
					"CHILD_1_BIRTHDATE_FIELD" => cdob
				})
			end

			# Build Member Partner Hash
			unless member.partner.nil?
				attributes_hash.merge!({"SIGNUP_SITE_FIELD" => member.partner.name})
			end
			
			# Get Extras
			unless extras.empty?
				attributes_hash.merge!(extras)
			end
			
			return attributes_hash
			#em.insert_or_update(self.email, attributes_hash)
			#em.close
		rescue
			Rails.logger.debug 'Exception Caught: Email Vision'
		end
	end
end