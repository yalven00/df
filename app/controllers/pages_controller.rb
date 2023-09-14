class PagesController < ApplicationController
  def about
    @title = 'About Us - Coupons & Deals For Moms'
		@meta_description = 'Deals For Mommy was created to help moms save on brands they already use and trust. Get coupons, deals, samples and discounts straight to your Deal Dashboard.'
		@meta_keywords = 'daily deals for moms, deals for mom, coupons for mom, printable coupons, free coupons, coupons online, huggies diaper coupons, pamper diaper coupons, coupons for diapers, baby coupons, coupon mom'
  end

  def privacy
    @title = 'Privacy Policy'
		@meta_description = 'Privacy policy for the official site of coupons and deals for moms - DealsForMommy.com'
		@meta_keywords = 'deals for mommy, mommy deals, deals for moms, daily deals for moms, mom coupons, coupon mom, coupons for moms, dealsformommy.com'
  end
  def terms
    @title = 'Terms & Conditions'
		@meta_description = 'Legal terms for the official site of coupons and deals for moms - DealsForMommy.com'
		@meta_keywords = 'mommy deals, deals for moms, deals for mommy, daily deals for moms, mom coupons, coupon mom, coupons for moms, coupons for diapers, dealsformommy.com'
  end

	## how it works page
  def howitworks
    @title = 'How It Works - Learn How To Get Local & Online Deals'
		@meta_description = 'Deals and coupons for moms. Learn how you can get local and online deals by joining our community. Get a personal dashboard and get access to tons of coupons and deals.'
		@meta_keywords = 'coupons online, printable coupons, coupon mom, mommy deals, deals for mom, coupons for moms, baby coupons, daily deals for moms, printable baby coupons, diaper coupons, free coupons, baby food coupons'		
  end

	## about us
  def aboutus
		@title = 'About Us - Coupons & Deals For Moms'
		@meta_description = 'Deals For Mommy was created to help moms save on brands they already use and trust. Get coupons, deals, samples and discounts straight to your Deal Dashboard.'
		@meta_keywords = 'daily deals for moms, deals for mom, coupons for mom, printable coupons, free coupons, coupons online, huggies diaper coupons, pamper diaper coupons, coupons for diapers, baby coupons, coupon mom'
  end


	## sitemap
  def sitemap
		@title = 'Sitemap : Deals For Mommy'
		@meta_description = 'Deals for mommy makes it easy for moms to save money by providing them with access to the best deals, coupons, and free samples from top brands such as Huggies, Pampers, and Gerber.'
		@meta_keywords = 'deals for moms, mommy deals, mom coupons, deals for mommy, daily deals for moms, coupon mom, coupons for moms, coupons for diapers, dealsformommy.com'
  end

	## success
  def success
		@title = 'Success'
  end
	
	## fail
  def fail
		@title = 'Fail'
  end
	
	## newsletter
	def newsletter
		@title = 'Newsletter'
		render :layout => false
	end
	
	## coupons
	def coupons
		if signed_in_dfm?
		 @show = 1
			@title = 'Coupons'
		else
      #redirect_to :controller => 'members', :action => 'new'
			deny_access and return unless signed_in_dfm?
		end
	end
	
	def freebies
	  if signed_in_dfm?
  		@show = 1
	    @title = 'freebies and discounts'
	    render :layout => true
	  else
			flash[:info] = "You must sign up to access that page!"
      redirect_to :controller => 'members', :action => 'new'
		end
  end
  
  def traveldeals
    if signed_in_dfm?
  		@show = 1
	    @title = 'travel deals'
	    render :layout => true
	  else
  		flash[:info] = "You must sign up to access that page!"
      redirect_to :controller => 'members', :action => 'new'
    end
  end
  
  def hotdeals
    if signed_in_dfm?
      @member = current_member
      #@full_page_coregs = Coreg.available_to_email(@member.email).full_pages
      @full_page_coregs = Coreg.full_pages - Coreg.taken_by_email(@member.email)
      @submit = Coreg.compact.available_to_email(@member.email).size
      @show = 1
	    @title = 'hot deals'
	    render :layout => true
	  else
			flash[:info] = "You must sign up to access that page!"
      redirect_to :controller => 'members', :action => 'new'
		end
  end
  
  def dbunsub
    if signed_in_dfm?
  		@show = 1
	    @title = 'customer support unsubscribe'
	    render :layout => true
    else

			flash[:info] = "You must sign up to access that page!"
      redirect_to :controller => 'members', :action => 'new'
		end
  end
  
  def unsubscribe
    if signed_in_dfm?
  		@show = 1
	    @title = 'unsubscribe'
	    render :layout => true
		else
			flash[:info] = "You must sign up to access that page!"
      redirect_to :controller => 'members', :action => 'new'
		end
  end
  
end
