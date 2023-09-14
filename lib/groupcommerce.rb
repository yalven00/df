require 'rubygems'
require 'httparty'
require 'logger'


class << Hashie::Mash
  def method_missing(method_name, *args, &blk)

    super method_name, *args, &blk
  end
end


class Groupcommerce
	include HTTParty
	format :json

  def initialize()
    @base_uri = 'https://api.groupcommerce.com/api/v3/publisher/broadcast/'
    @api_key = ''
  end

  #
  # This broadcast method will get all offers for the publisher based on a set of filtering parameters.
  # Example: GET /api/v3/publisher/broadcast/offers?pagenumber={pageNumber}&pagesize={pageSize}&startDate={startDate}&endDate={endDate}&OrderBy={orderBy}&segmentKeys={segmentKeys}&ClassificationKeys={classificationKeys}&Tags={tags}&ApiKey={apiKey}
  #
  def getBroadcastOffers (filters={})
    options = "ApiKey=#{@api_key}"
    unless filters.empty?
			params = Array.new
			filters.each do |k,v|
				params.push("#{k}=#{v}")
			end
			options << "&" + params.join('&')
    end
    Hashie::Mash.new(HTTParty.get("#{@base_uri}offers?#{options}")).offers
  end

  #
  # Segments are publisher-defined.  A segment may be a city that a publisher is in, or any other subset of a
  # publisher's audience.  Examples of segments could be los angeles, kids, or golf-lovers.
  # This broadcast method gets the list of all active and coming-soon segments.
  # Example:  GET /api/v3/publisher/broadcast/segments?ApiKey={apiKey}
  #
  def getBroadcastSegments
     Hashie::Mash.new(HTTParty.get("#{@base_uri}segments?ApiKey=#{@api_key}")).segments
  end

  #
  # A member of the publisher's production team can rank or order items within a segment using the pub admin application.
  # This method will return a list of SegmentListing objects that will contain either an Offer or a Segment ordered as
  # specified in pub admin.
  # Example: GET /api/v3/publisher/broadcast/segmentlistings/{segmentKey}
  #
  def getBroadcastSegmentsListings(key='national')
    uri_path = 'segmentlistings/'
    uri_path << key + '/' unless key.blank?
    Hashie::Mash.new(HTTParty.get("#{@base_uri}#{uri_path}?ApiKey=#{@api_key}")).segmentListings
  end

end
# gc = Groupcommerce.new
# gc.getOffers.each{|offer| puts offer['offerId']}
