class Member < ActiveRecord::Base

  has_one :address
	has_one :child
	belongs_to :partner

  has_many :coreg_optins, :inverse_of => :member
  accepts_nested_attributes_for :coreg_optins#, :reject_if => lambda { |a| a[:taken] != 'yes' }, :allow_destroy => true

  accepts_nested_attributes_for :address
	accepts_nested_attributes_for :child

  scope :count_today, lambda { 
    where("created_at >= ?", 
           Time.now.in_time_zone.to_s)
  }  
  
  scope :partners, lambda {
    group_by("partner_id")
  } 
  
  attr_accessible :first_name,
		:last_name,
		:email,
		:postal_code,
		:gender,
		:password,
		:password_confirmation,
		:partial_member,
		:address_attributes,
		:child_attributes,
		:dob,
		:updating_password,
    :coreg_optins_attributes

  attr_accessor :partial_member,
		:updating_password, :check_dob

  validates :first_name,
            :format => {:with =>/\A[-\sa-zA-Z]+\z/},
            :presence => {:message => '^First Name is required'}

	validates :last_name,
            :format => {:with =>/\A[-\sa-zA-Z]+\z/},
            :presence => {:message => '^Last Name is required'}

  validates :email,
		:presence => true,
		:format => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
		:uniqueness => { :case_sensitive => true }

  validates :postal_code,
	  :presence => true,
		:format => { :with =>  /^((\d{5}-\d{4})|(\d{5})|([A-Z]\d[A-Z]\s\d[A-Z]\d))$/}

  validates :password,
    :presence => true,
    :unless => :partial_member?,
		:confirmation => { :message => 'Password does not match confirmation' }

  validates :gender,
		:presence => { :message => '^Gender is required' },
		:unless => :partial_member?

	validates_date :dob,
		:between => [lambda{120.years.ago}, lambda{ 18.years.ago }],
		:message => 'Invalid DOB',
		:if => :check_dob?
				 
  validate :check_password,
		:on => :update

  before_save :encrypt_password, :unless => :partial_member?
	before_create :set_original_email
	
 
  def check_password
    return unless :partial_member?
    if self.password.blank? || self.password.to_s.size.to_i < 4
      errors.add(:password, "^Password must be at least 4 chars long")
    end
  end

  def full_name
    self.first_name + ' ' +self.last_name
  end
	def check_dob?
		check_dob
	end
  def partial_member?
		!updating_password || self.password.nil?
  end

  def has_password?(submitted_password)
    password == encrypt(submitted_password)
  end

  def generate_token
    Crypto.encrypt("#{id}|#{2.month.from_now}")
  end

  def self.joined_today
    Member.where('created_at > ?', Date.today.strftime('%Y-%m-%d')).count
  end

	def self.joined_past_24hr
		 Member.where('created_at > ?', 1.day.ago).count
	end
	
  def self.authenticate(email, submitted_password)
    member = find_by_email(email)
    (member && member.has_password?(submitted_password)) ? member : nil
  end

  def self.authenticate_with_token(token)
    id, expiration = Crypto.decrypt(token).split('|')
    if expiration < Time.now.to_s
      return nil
    else
      return Member.find(id)
    end
  end

  def existing_member?
    self.created_at < Time.now - 10.minutes
  end

  def self.authenticate_with_salt(id, cookie_salt)
    member = find_by_id(id)
    (member && member.salt == cookie_salt) ? member : nil
  end
	
  def encrypt_password
    return if password.blank?
    self.salt     = make_salt
    self.password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  
  def set_original_email
    self.original_email = email
  end

  def fully_registered?
    self.address.present? 
  end

  # the total revenue of a member
  def revenue
    successful_coregs.sum(&:revenue)
  end

  def offers_taken
    successful_coregs.size
  end

  private 
  def successful_coregs
    coreg_optins.select {|x| x.success }.collect {|x| x.coreg}.to_a.uniq
  end
end
