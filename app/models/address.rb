class Address < ActiveRecord::Base
  belongs_to :member

	validates :city,
						:presence => { :message => '^City is required' }
  validates :address1,
						:presence => { :message => '^Street is required' }
	validates :state,
						:presence => { :message => '^State is required' }
	validates :postal,
						:presence => true,
						:format => { :with =>  /^((\d{5}-\d{4})|(\d{5})|([A-Z]\d[A-Z]\s\d[A-Z]\d))$/}
						
	alias_attribute :longitude, :lng
  alias_attribute :latitude, :lat

  acts_as_mappable # to provide geokit-rails3 searches

  before_save :geo_lookup

  # Lookup lat and lng and save it along with the address record
  def geo_lookup
    location = Geokit::Geocoders::MultiGeocoder.geocode([self.address1,self.city,self.state,self.postal].join(', '))

    if location.success
      self.lat = location.lat
      self.lng = location.lng
			self.country = location.country_code
    end

  end
end
	