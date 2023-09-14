class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include MembersHelper
  include Crypto

  COOKIE_KEY = 'serial'
  before_filter :set_affiliate

  unless config.consider_all_requests_local
      rescue_from Exception, :with => :render_error
      rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
      rescue_from ActionController::RoutingError, :with => :render_not_found
      rescue_from ActionController::UnknownController, :with => :render_not_found
      rescue_from ActionController::UnknownAction, :with => :render_not_found
    # customize these as much as you want, ie, different for every error or all the same
  end
  
  private
  
  def set_affiliate
    if(session[:aff_utm].nil? && !params['utm_content'].blank? && !params['utm_term'].blank?)
      session[:aff_utm] = [params['utm_content'],  params['utm_term']]
    end
  end

  def render_not_found(exception)
    logger.info exception
    logger.info exception.backtrace
    #render :template => "/errors/fourofour.html.erb", :status => 404
    if signed_in_dfm? 
      redirect_to home_path
    else
      redirect_to new_member_path
    end 
  end
  
  def render_error(exception)
    # you can insert logic in here too to log errors
    # or get more error info and use different templates
    logger.error { exception.inspect }
    logger.error { exception.backtrace.join("\n") }
    #render :template => "/errors/fivehundred.html.erb", :status => 500
    if signed_in_dfm? 
      redirect_to home_path
    else
      redirect_to new_member_path
    end
  end

  def request_serial
    cookies[COOKIE_KEY]
  end

  def param_data
    data = params
    data.delete_if {|k, v| ['controller', 'action', 'utf8'].include? k}
    data
  end

  def affiliate_cookie_data
      cookies['aff_utm']
  end

  def login_required
    unless signed_in_dfm?
      deny_access and return 
    end
  end
end
