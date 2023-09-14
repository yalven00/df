class LivingSocialCity < ActiveRecord::Base
  geocoded_by :displayName

  def self.city_id(zip)
    JSON.parse(RestClient.get("http://livingsocial.com/services/city/v2/cities/nearby/zipcode/#{zip}?max=1")).first['id'] rescue 587
  end
=begin
  def self.city_id(zip)
    (self.near(Geocoder.search(zip).first.formatted_address).first || self.first).city_id
  end
=end
end
