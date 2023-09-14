class ContentPage < ActiveRecord::Base
  validates :path,
		:presence => {:message => '^Path is required'}


end
