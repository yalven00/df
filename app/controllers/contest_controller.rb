class ContestController < ApplicationController

  def index
    @title = "Contests & Giveaways | Win Free Stuff | Sweepstakes"
	  @meta_description = "Win free stuff in our contests and giveaways. Deals for mommy is your resource for coupons, deals, free samples, discounts and much more."
  	@meta_keywords = "contests, giveaways, sweepstakes, win free stuff, diapers, coupons, deals, samples"
  end

  def  free_diapers_for_year
    @title = "Win Free Diapers for a Year 2013 | Free Pampers Diapers"
	  @meta_description = "Win a year's worth of free diapers from Deals for Mommy. Enter today for a chance to win free pamper diapers"
  	@meta_keywords = "free diapers, free pampers, diaper contest, pampers, pampers diapers"
  end

end
