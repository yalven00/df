require 'rubygems'
require 'httparty'
require 'logger'

#$EWAY_LOGGER = Logger.new('eway.log')  

class Eway
  include HTTParty
  #base_uri 'http://link.ixs1.net'
  #default_params :apiKey => 'put your key here'
  #debug_output
 
  def self.logger
    @@eway_logger ||= Logger.new("#{Rails.root}/log/eway.log") 
  end

  LISTS = {
    :dfm							=> 'http://link.ixs1.net/s/link/su?rc=cp&rti=w8083&si=g0',
    :cutekid					=> 'http://link.ixs1.net/s/link/su?rc=cp&rti=v8136&si=g0',
    :cutekid_coreg		=> 'http://link.ixs1.net/s/link/su?rc=cp&rti=z8356&si=g0',
		:dfm_update				=> 'http://link.ixs1.net/s/link/su?rc=cp&rti=c8884&b=y',
		:dfm_unsubscribe	=> 'http://link.onlinedialog.com/s/link/rmv?rc=cp&rti=y8346&b=y',
		:cutekid_update		=> 'http://link.ixs1.net/s/link/su?rc=cp&rti=07358&si=g0',
    :dfm_recover_pass => 'http://link.ixs1.net/s/link/su?rc=cp&rti=q9031&b=y'
  }

  def ck_subscribe(member_id, partner)
    member = Member.find(member_id)
		person = to_hash(member)
    if partner.nil?
      subscribe(:cutekid, person.merge({:text1 => 'CUTEKID'}))
    else 
      subscribe(:cutekid_coreg, person.merge({:text1 => "CK-#{partner.upcase}"}))
    end
		pass_member_pwd_token_to_ck_list(member)
 end

  def dfm_subscribe(member_id)
    member = Member.find(member_id)
    subscribe(:dfm, to_hash(member).merge({:text1 => 'DFM'}))
  end
	
	def dfm_unsubscribe(member_id)
    member = Member.find(member_id)
    subscribe(:dfm_unsubscribe, {:email=>member.email})
  end

	def dfm_update(member_id)
	  member = Member.find(member_id)
	  subscribe(:dfm_update, to_hash(member))
  end

  def cutekid_update(member_id)
	  member = Member.find(member_id)
	  subscribe(:cutekid_update, to_hash(member))
	end

	def pass_member_pwd_token_to_ck_list(member)
		token_link = member.password.nil? ? "www.dealsformommy.com/get-your-dashboard?token=#{member.generate_token}" : ''
		subscribe(:cutekid_update, {:email=>member.email, :text4=> token_link})
	end

  def dfm_recover_pass(member_id)
    member = Member.find(member_id)
    token_link = "www.dealsformommy.com/reset_password?token=#{member.generate_token}"
		subscribe(:dfm_recover_pass, {:email=>member.email, :text5=> token_link})
  end

	private
  def subscribe(list_id, query)
    list_action = LISTS[list_id] || LISTS[:dfm]
    #puts "#{list_action} #{query.inspect}"
		return 'withheld' unless Rails.env.production?
    10.times do 
			response = self.class.post("#{list_action}", :query => query )
	    if response.code.to_i == 200
        Eway.logger.debug("SUCCEEDED: #{query.inspect}") 
        return true 
      end
    end
    Eway.logger.error("FAILED: #{query.inspect} #{list_action}")
    return false
  end

  def to_hash(person)
    {
      :firstName  => person.first_name,
      :lastName   => person.last_name,
      :email      => person.original_email,
      :userName   => person.original_email,
      :address1   => person.address.try(:address1),
      :address2   => person.address.try(:address2),
      :city       => person.address.try(:city),
      :state      => person.address.try(:state), #state
      :country    => person.address.try(:country),
      :phone      => person.address.try(:phone),
      :zip        => person.postal_code,
      :gender     => person.gender,
      :birthDate  => person.dob,
      :text2      => person.id, #member_id
      :date2      => person.child.try(:dob),#child 1 dob
      :text3      => person.child.try(:gender), #child 1 gender
      :number1    => person.address.try(:lat), 
      :number2    => person.address.try(:lng),
      :text5      => person.password.nil? ? "www.dealsformommy.com/get-your-dashboard?token=#{person.generate_token}" : '',
			:password		=> person.password.nil? ? "F" : "T"
    }
  end

end
