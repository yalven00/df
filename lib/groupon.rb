require 'hashie'
Hash.send :include, Hashie::HashExtensions

class << Hashie::Mash
  def method_missing(method_name, *args, &blk)
    
    super method_name, *args, &blk
  end
end

class Groupon
  include HTTParty
	default_timeout 10
  base_uri "http://api.groupon.com/v2"
  format :json

  class << self
    attr_accessor :api_key, :deals
  end

  def self.configure
    yield self
    true
  end

  def self.deals(query={})
		begin
			division = query.delete(:division)
			query.merge! :client_id => self.api_key
			path = division ? "/#{division}" : ""
			path += "/deals.json"
			fix_first Hashie::Mash.new(self.get(path, :query => query)).deals
		rescue Exception => e
			Rails.logger.debug 'Exception on Groupon Deals Raised'
			return {}
		end
    
	end

  def self.divisions
		begin
	    divisions_params = Hashie::Mash.new(self.get("/divisions.json", :query => { :client_id => self.api_key })).divisions
			if divisions_params.nil? or divisions_params.empty?
				return {}
			else
				return divisions_params
			end
		rescue Exception => e
			Rails.logger.debug 'Exception on Groupon Divisions Raised'
			return {}
		end
  end

  # Returns all deals that contain one or more tags
  # Example:
  # deals.find_by_tags "Restaurants", "Food & Drink"
  # optionally, you can pass an array of deals as the first parameter
  # deals.find_by_tags deals, "Restaurants", "Food & Drink""

  def self.find_by_tags(*tag_names)
    allDeals = tag_names.first.instance_of?(Array) ? tag_names.first : self.deals
    allDeals.reject do |deal|
      tag_names.map do |tag_name|
        break if deal.tags.include?(Hashie::Mash.new(:name => tag_name))
      end
    end
  end

  private

  def self.fix_first(deals)
		return {} if deals.nil? or deals.empty?
    deals.first.street_address1 = 'Redeem From Home'
    unless deals.first.options.first.redemptionLocations.first.nil?
      if deals.first.options.first.redemptionLocations.count > 1 then
        deals.first.street_address1 = 'Multiple Locations'
      else
        deals.first.street_address1 = deals.first.options.first.redemptionLocations.first.streetAddress1 ||= ''
        deals.first.city            = deals.first.options.first.redemptionLocations.first.city ||= ''
        deals.first.state           = deals.first.options.first.redemptionLocations.first.state ||= ''
        deals.first.postal_code     = deals.first.options.first.redemptionLocations.first.postalCode ||= ''
        deals.first.street_address1 = deals.first.city + ', ' + deals.first.state
      end
    end
    return deals
  end
end