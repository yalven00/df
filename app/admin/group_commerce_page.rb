class GroupCommercePage < ActiveRecord::Base
end

ActiveAdmin.register GroupCommercePage do
  config.comments = false
  config.clear_action_items!
  before_filter do @skip_sidebar = true end


  controller do
    def index
      params[:action] = "Group Commerce Page" # this sets the page title (so it doesnt just render 'index')
      gc = Groupcommerce.new
      offers = gc.getBroadcastSegmentsListings
      @first_deal   = offers.first
      #@first_offer_img_src = first_deal.images.first.sizes.second.url
      #first.images.first.sizes.second.url
      @second_deal  = offers.second
      @third_deal   = offers.third
      render 'admin/groupcommercepage/index', :layout => 'active_admin' # renders the index view in app/views/admin/charts
    end
  end
end