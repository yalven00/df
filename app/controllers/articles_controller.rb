class ArticlesController < ApplicationController
  def index
    @title = 'Mom Articles - Articles on Deals, Coupons, & Savings'
	  @meta_description = 'Read articles about finding deals, coupons, and savings  online.  Articles for moms'
  	@meta_keywords = 'mom articles, saving articles, coupon articles, articles for  moms, coupons for mom, mom coupons, deals for mom, baby coupons, grocery coupons'
  end

  def deals_for_mommy_coupons_savings_and_samples
    @title = "Deals For Mommy: Coupons, Savings & Samples "
    @meta_keywords = "coupons, savings, samples, deals for mommy, coupons for mommy, discounts for mommy"
    @meta_description = "Learn how you can get access to savings, free coupons and free samples at Deals for Mommy"
  end

  def diaper_coupons_making_moms_lives_easier
    @title = "Diaper Coupons Can Make Moms' Lives a Little Easier "
    @meta_keywords ="diaper coupons, deals for mommy, coupons for mommy, discounts for mommy"
    @meta_description ="Learn how you can get free diaper coupons from top brands at Deals for Mommy."
  end

  def is_enfamil_the_best_for_your_baby
    @title = "Is Enfamil the Best Formula for Your Baby? "
    @meta_keywords="enfamil coupons, baby formula coupons, deals for mommy, coupons for mommy, discounts for mommy"
    @meta_description="Learn about Enfamil baby formula and how it affects your baby."
  end

  def money_saving_tips_for_moms_baby_coupons_online
    @title = "Money Saving Tips for Moms: Baby Coupons Online "
    @meta_keywords="baby coupons, save money, deals for mommy, coupons for mommy, discounts for mommy" 
    @meta_description="Great money saving tips for moms and learn how you can get free baby coupons online." 
  end

  def baby_coupons_gerber_and_other_infant_formula
    @title = "Can't Miss Baby Coupons: Gerber & Other Infant Formulas "
    @meta_description = "baby coupons, infant formula, gerber coupons, deals for mommy, coupons for mommy, discounts for mommy"
    @meta_keywords = "Learn how you can get free Gerber and Baby Formula coupons at Deal for Mommy"
  end

  def top_reasons_for_coupon_use_by_women
    @title = "Top Reasons For Coupon Use By Women - Infographic "
    @meta_keywords = "women coupons, coupon use, couponing, coupons"
    @meta_description = "See our Top Reasons For Coupon Use By Women infographic and other Deal Articles at DealsForMommy, your deals, coupons, savings, and samples site"
  
  end
end
