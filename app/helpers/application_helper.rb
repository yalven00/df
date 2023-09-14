module ApplicationHelper
  def title
    base_title = "Deals For Mommy"
    @title.nil? ? base_title : "#{@title} | #{base_title}"
  end

	def meta_keywords
		base_keywords = 'deals for mommy, coupons for mommy, discounts for mommy'
		@meta_keywords.nil? ? base_keywords : "#{@meta_keywords}"
	end
	
	def meta_description
		base_description = 'Bringing local and internet deals to one place;Pick the deals that best suit you and your family'
		@meta_description.nil? ? base_description : "#{@meta_description}"
	end
	
  def ip_address
    if Rails.env == 'development' and request.remote_ip == '127.0.0.1'
      require 'open-uri'
      open("http://whatsmyip.org") do |f|
        /([0-9]{1,3}\.){3}[0-9]{1,3}/.match(f.read)[0]
      end
    else
      @env['X-Forwarded-For'] ||= request.remote_ip
    end
  end

  def cache_name(name = 'all')
    return false unless defined?(REVISION)
    name + '-r' + REVISION
  end

  def savings_total
    Rails.cache.fetch("groupon-total-savings", :expires_in => 45.minutes) do
=begin
			if request.env["HTTP_X_FORWARDED_FOR"]
				ip = request.env["HTTP_X_FORWARDED_FOR"]
			else 
				ip = request.remote_ip
			end
			geolocation = Geokit::Geocoders::MultiGeocoder.geocode(ip)
      if geolocation.success
        lat, lng = geolocation.lat, geolocation.lng
      else
        #TODO need to determine proper parameters
        lat, lng = '38.8536', '-77.2982'
      end
=end
      lat, lng = '38.8536', '-77.2982'
      total = savings = 0
      Groupon.deals(:lat => lat, :lng => lng).each do |deal|
        total += deal.options.first.discount.amount
      end
      savings =  total/100
			if savings >= 1000
				number_with_delimiter savings
			else 
				number_with_delimiter savings + 1000
			end
    end
  end

end
