module SessionsHelper
  
  def sign_in_dfm(member)
    cookies.permanent.signed[:remember_token] = [member.id, member.salt]
    session[:member_id] = member.id
    self.current_member = member
  end
  
  def current_member=(member)
    @current_member = member
  end
  
  def current_member
    @current_member ||= member_from_remember_token
  end

  def signed_in_dfm?
    !current_member.nil?
  end

  def sign_out_dfm
    cookies.delete(:remember_token)
    session[:member_id] = nil
    self.current_member = nil
  end

  def current_member?(member)
    member == current_member
  end

  def authenticate
    deny_access unless signed_in_dfm?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

  def member_from_remember_token
    Member.authenticate_with_salt(*remember_token)
  end
    
  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end

  def auth_with_token
    return unless params[:token].present?
    id,expiration = Crypto.decrypt(params[:token]).split('|')
	  if Time.parse(expiration).to_i < Time.now.to_i
      flash[:error] = 'The token used to reset this account has expired - Please request a new link'
      redirect_back_or :recover_password
    else
      self.current_member = Member.find(id)
      sign_in_dfm(self.current_member)
    end
  end
end