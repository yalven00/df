class AdvertisersController < ApplicationController

	TITLE = 'Advertise With Us'
	META_DESCRIPTION = 'Advertise with Deals For Mommy and get your Deal featured to our members.'
	META_KEYWORDS = 'deals for mommy, mommy deals, deals for moms, daily deals for moms, mom coupons, advertise, ads, promote, marketing, feature a deal, promote a deal'
	
	def new
		@title = TITLE
		@meta_description = META_DESCRIPTION
		@meta_keywords = META_KEYWORDS
	end

  def create
		@title = TITLE
		@meta_description = META_DESCRIPTION
		@meta_keywords = META_KEYWORDS
    @advertiser = Advertiser.new(params[:advertiser])
		if @advertiser.save
			redirect_to('/', :notice => 'Message has been successfully sent')
		else
			render :new
		end
  end

end