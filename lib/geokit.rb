module Geokit
 class GeoLoc
   def city
     if @city.nil? and @district.present?
       @district
     else
       @city
     end
   end
 end
end