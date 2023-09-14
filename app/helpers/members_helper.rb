module MembersHelper
  def groupon_deals
    return Groupon.deals(:division_id => session[:division_request]) unless session[:division_request].nil?

    if signed_in_dfm? and !current_member.address.nil?
      lat, lng = current_member.address.lat, current_member.address.lng
    else
      geolocation = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip)
      if geolocation.success
        lat, lng = geolocation.lat, geolocation.lng
      else
        #TODO need to determine proper parameters
        lat, lng = '38.8536', '-77.2982'
      end
    end

    Rails.cache.fetch("groupon-deals-at-#{lat}-#{lng}", :expires_in => 30.minutes) do
     Groupon.deals(:lat => lat, :lng => lng)
    end
  end

  def yummy_deals
    Groupon.find_by_tags groupon_deals, 'Restaurants', 'Food & Drink'
  end

  def groupon_divisions
    Rails.cache.fetch("groupon_divisions", :expires_in => 30.minutes) do
      Groupon.divisions
    end
  end

  def js_key(page)
    if(session[:form]!='partial_member')
      if(page=='new')
        return  'dfm_full_reg'
      elsif(page=='step2')
        return 'dfm_step2'
      elsif(page=='step3')
        return 'dfm_full_step3'
      end
    else
      if(page=='new')
         return 'dfm_home'
      elsif(page=='step2')
        return 'dfm_step2'
      elsif(page=='step3')
        return 'dfm_step3'
      end
    end
  end
end
