class CoregOptinsController < ApplicationController
  respond_to :html#, :xml, :json

  before_filter :login_required

  def new
    if (@full_page_coreg = Coreg.find(params[:coreg_id])).full_page?
      @coreg_optin = @full_page_coreg.coreg_optins.build
      render :action => 'members/full_page_coreg'
    else
      flash[:notice] = 'Your URL is invalid.'
      redirect_to current_member.existing_member? ? home_path : step3_path #"/promo/cutekid"
    end 
  end

  def create
    if params['optin'] == 'y' # this is the param from the screen to indicate an optin
      Resque.enqueue(FullPageCoregSender, params[:coreg_id], param_data, request_serial)
    end

    # find the next full page coreg in line; if none, goes to home page
    if next_coreg = Coreg.full_pages.select {|co| co.id > params[:coreg_id].try(:to_i) }.first
      redirect_to new_coreg_coreg_optin_path(next_coreg)
    else
      redirect_to current_member.existing_member? ? home_path : "/promo/bsaving"
    end
  end
end
