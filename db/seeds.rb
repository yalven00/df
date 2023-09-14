# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Delete existing data

require 'csv'

State.delete_all

[
	['US','AL','Alabama'],
	['US','AK','Alaska'],
	['US','AZ','Arizona'],
	['US','AR','Arkansas'],
	['US','CA','California'],
	['US','CO','Colorado'],
	['US','CT','Connecticut'],
	['US','DE','Delaware'],
	['US','DC','District Of Columbia'],
	['US','FL','Florida'],
	['US','GA','Georgia'],
	['US','HI','Hawaii'],
	['US','ID','Idaho'],
	['US','IL','Illinois'],
	['US','IN','Indiana'],
	['US','IA','Iowa'],
	['US','KS','Kansas'],
	['US','KY','Kentucky'],
	['US','LA','Louisiana'],
	['US','ME','Maine'],
	['US','MD','Maryland'],
	['US','MA','Massachusetts'],
	['US','MI','Michigan'],
	['US','MN','Minnesota'],
	['US','MS','Mississippi'],
	['US','MO','Missouri'],
	['US','MT','Montana'],
	['US','NE','Nebraska'],
	['US','NV','Nevada'],
	['US','NH','New Hampshire'],
	['US','NJ','New Jersey'],
	['US','NM','New Mexico'],
	['US','NY','New York'],
	['US','NC','North Carolina'],
	['US','ND','North Dakota'],
	['US','OH','Ohio'],
	['US','OK','Oklahoma'],
	['US','OR','Oregon'],
	['US','PA','Pennsylvania'],
	['US','RI','Rhode Island'],
	['US','SC','South Carolina'],
	['US','SD','South Dakota'],
	['US','TN','Tennessee'],
	['US','TX','Texas'],
	['US','UT','Utah'],
	['US','VT','Vermont'],
	['US','VA','Virginia'],
	['US','WA','Washington'],
	['US','WV','West Virginia'],
	['US','WI','Wisconsin'],
	['US','WY','Wyoming'],
	['US','PR','Puerto Rico'],
	['US','VI','Virgin Island'],
	['US','GU','Guam'],
	['US','AS','American Samoa'],
	['US','PW','Palau'],
	['CA','AB','Alberta'],
	['CA','BC','British Columbia'],
	['CA','MB','Manitoba'],
	['CA','NB','New Brunswick'],
	['CA','NL','Newfoundland and Labrador'],
	['CA','NS','Nova Scotia'],
	['CA','NU','Nunavut'],
	['CA','NT','N.W.T.'],
	['CA','ON','Ontario'],
	['CA','PE','Prince Edward Island'],
	['CA','QC','Quebec'],
	['CA','SK','Saskatchewan'],
	['CA','YT','Yukon'],
	['US','AE','Armed Forces Europe'],
	['US','AP','Armed Forces Pacific']
	].each do |country, code, name|
  State.create(:country => country,:code => code,:name => name)
end

require 'active_record/fixtures'

['coregs', 'pages'].each do |table|
  Fixtures.create_fixtures("#{Rails.root}/test/fixtures", table)
end

# coreg params are seperate
Fixtures.create_fixtures("#{Rails.root}/test/fixtures", 'coreg_params')
CoregParam.all.each {|x| x.send :spawn_children_params}

LivingSocialCity.destroy_all
CSV.foreach('db/living_social_cities.csv', :headers => true) do |row|
  LivingSocialCity.create!(row.to_hash)
end


