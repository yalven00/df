class Advertiser
	include ActiveModel::Validations
	validates :email,
		:presence => {:message => '^Email is required'}
	validates :business_name,
		:presence => {:message => '^Business Name is required'}
	validates :first_name,
		:presence => {:message => '^First Name is required'}
	validates :last_name,
		:presence => {:message => '^Last Name is required'}
	validates :phone,
		:presence => {:message => '^Phone is required'}

	attr_accessor :id, :email, :business_name, :first_name, :last_name, :phone, :address, :city, :state, :postal, :phone, :website, :business_desc, :deal_desc
  def initialize(attributes={})
    attributes.each do |key, value|
			self.send("#{key}=", value)
		end
		@attributes = attributes
  end
	
	def read_attribute_for_validation(key)
    @attributes[key]
	end

  def to_key
  end

	def save
    if self.valid?
      MemberMailer.advertiser_email(self).deliver
      return true
    end
			return false
  end
end
