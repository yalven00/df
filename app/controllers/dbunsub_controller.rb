class DbunsubController < ApplicationController
	before_filter :authenticate 
	
	def new
		@unsubscribe = false
		if request.post?
			if Member.find_all_by_email(params[:dbunsub][:email]).empty?
				@message = "Unable to unsubscribe given email: #{params[:dbunsub][:email]}. Email not found."
			else
				@unsubscribe = true
				@message = "#{params[:dbunsub][:email]}. Email Unsubscribed"
				member = Member.find_by_email(params[:dbunsub][:email])
				#eway = Eway.new
				#eway.dfm_unsubscribe(member)
        Resque.enqueue(EwaySender, :dfm_unsubscribe, member.id)
			end
		end
	end
	
	protected 
	
	def authenticate 
		#if Rails.evn == "production"
			authenticate_or_request_with_http_basic do |username, password|
				username == 'dfmnimda' && password=='$$_BiLL_YA_$$'
			end
		#end
	end
end 
