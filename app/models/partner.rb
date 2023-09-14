class Partner < ActiveRecord::Base

  validates :name,
						:presence => true
  before_create :create_api_key
	has_many :members

  def self.authenticate?(api_key)
    @partner = find_by_api_key(api_key)
    !@partner.blank?
  end

  private

  def create_api_key
    self.api_key = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self}--")
  end

end