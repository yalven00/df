class ValidPostalCodeValidator < ActiveModel::EachValidator
	def validate_each(object, attribute, value)
	unless value.blank?
		location = Geokit::Geocoders::MultiGeocoder.geocode(value)
		if location.success && location.is_us? then
			#TODO if we need to store the returned values in the db, code goes here
			return true
		end
	end
	object.errors[attribute] << (options[:message] || "- invalid country or null")
	end
end
