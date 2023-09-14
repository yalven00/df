class SessionsController < ApplicationController
	
	TITLE = "Sign in - Online Coupons, Deals, & Samples For Moms"
	META_DESCRIPTION = 'grocery coupons, printable coupons, coupons online, baby coupons, diaper coupons, pampers coupons, huggies printable coupon, printable diaper coupons, printable pampers coupons, baby formula coupons, baby food coupons, free diaper coupons' 
	META_KEYWORDS = 'Member login for the fastest growing deal and coupon site for moms. Members can get access to coupons from top brands such as Huggies, Gerber, Pampers, Luvs and more.'
	
  def new
    @title = TITLE
		@meta_keywords = META_DESCRIPTION
		@meta_description = META_KEYWORDS
  end

  def create
    member = Member.authenticate(params[:session][:email],params[:session][:password])
		@title = TITLE
		@meta_keywords = META_DESCRIPTION
		@meta_description = META_KEYWORDS
    if member.blank?
      flash.now[:error] = "Invalid email/password combination."
      render 'new'
    else
      sign_in_dfm member
      redirect_back_or home_path
    end
  end

  def destroy
    sign_out_dfm
    redirect_to root_path
  end
end