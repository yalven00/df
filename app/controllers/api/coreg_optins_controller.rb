class Api::CoregOptinsController < ApplicationController

  before_filter :cookie_processing

  # register existing optins
  def register_optin
    Resque.enqueue(CoregSender, param_data, request_serial) # send the params to the coreg processor
    render :text => "OK"
  end 

  def list
    @page = Page.find_by_name(referer)
    #coregs_available = Coreg.where(:screen_key => referer)
    if referer != "dfm_hotdeals"
      coregs_available = @page.coregs
    else
      coregs_available = @page.adjusted_coregs
    end
    coregs_taken = CoregOptin.find_all_by_hashcode(request_serial).collect{|x| x.coreg }
    @coregs = coregs_available - coregs_taken
    respond_to do |format|
      format.js
    end
  end 

  # confirm actino for sending in confirmation of coregs
  # the format should be http://dealsformommy.com/api/optins/coreg_optins/24e93e0c-4b46-4bfd-a61b-6e29614f5080?[PARAMS]
  def confirm
    if coreg_optin = CoregOptin.find_by_hashcode(params[:id])
      coreg_optin.response = params.to_s
      coreg_optin.success = coreg_optin.send :successful?
      coreg_optin.sent = true
      coreg_optin.save!
    end
    redirect_to home_path
    #render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  private
  def cookie_processing
    serial = request_serial
    if serial.nil? || serial.blank?
      serial = UUIDTools::UUID.random_create.to_s
      cookies[COOKIE_KEY] = {:value => serial, :expires => Time.now + 3600}
      if ! session[:aff_utm].nil?
        aff_utm = session[:aff_utm]
        @affiliate_id  = aff_utm[0] # as per the HO pixel utm_content is affiliate id
        @affiliate_sub_id = aff_utm[1] # as per the HO pixel utm_term is affiliate_sub_id
      end
      Resque.enqueue(RequestRegister, serial, request.remote_ip, @affiliate_id, @affiliate_sub_id)
    end
  end
  
  def referer
    params['key']
    #request.env['HTTP_REFERER']
  end
end
