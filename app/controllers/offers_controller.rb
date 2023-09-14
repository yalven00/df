class OffersController < ApplicationController
	def index
	  if signed_in_dfm?
	  @show = 1
    end
    @show_deals = false 
		unless params[:divisions].nil?
      session[:division_request] = params[:divisions]
    end
		@groupon_deals, @groupon_divisions  = groupon_deals.dup, groupon_divisions.dup
    unless @groupon_deals.empty?
      @show_deals = true
			@division_id = @groupon_deals.first.division.id
			@location_display = @groupon_deals.first.division.name
    end
    if session[:division_request].nil?
      unless current_member.nil? || current_member.address.nil?
         @location_display = current_member.address.city 
      end     
    end
	end
end
