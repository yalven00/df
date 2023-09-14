Dealsformommy::Application.routes.draw do


  get "errors/fourofour"

  get "errors/fivehundred"

    ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  # resque for background job processing
  mount Resque::Server, :at => "/resque"  

  root :to => "members#new"

  resources :members
  resources :sessions, :only => [:new, :create, :destroy]
  resources :advertisers, :only => [:new, :create]
	resources :offers, :only => [:index]
  resources :coregs do
    resources :coreg_optins
  end

  match '/signin(/:token)', :to => 'sessions#new', :as => 'signin'
  match '/signout', :to => 'sessions#destroy'
  
  # #contest routes
  match '/contest' => 'contest#index'
  match '/contest/free-diapers-for-year' => 'contest#free_diapers_for_year'

  match '/free-diapers' => redirect('/saving-form1?f=full_form_member&utm_source=magazine&utm_medium=healthym=b&utm_campaign=free-diapers')


 #articles routes
  match '/articles' => 'articles#index'
  match 'articles/top-reasons-for-coupon-use-by-women' =>'articles#top_reasons_for_coupon_use_by_women'
  match '/deals-for-mommy-coupons-savings-and-samples' => 'articles#deals_for_mommy_coupons_savings_and_samples', :as => 'deals_for_mommy_coupons_savings_and_samples'
  match '/baby-coupons-gerber-and-other-infant-formula' =>'articles#baby_coupons_gerber_and_other_infant_formula', :as => 'baby_coupons_gerber_and_other_infant_formula'
  match '/diaper-coupons-making-moms-lives-easier' => 'articles#diaper_coupons_making_moms_lives_easier', :as => 'diaper_coupons_making_moms_lives_easier'
  match '/is-enfamil-the-best-for-your-baby' => 'articles#is_enfamil_the_best_for_your_baby', :as => 'is_enfamil_the_best_for_your_baby'
  match '/money-saving-tips-for-moms-baby-coupons-online' =>'articles#money_saving_tips_for_moms_baby_coupons_online', :as => 'money_saving_tips_for_moms_baby_coupons_online'
  match '/about' => 'pages#about', :as => 'about'
	match '/success' => 'pages#success'
	match '/fail' => 'pages#fail'
  match '/privacy-policy' => 'pages#privacy'
  match '/sitemap' => 'pages#sitemap'
  match '/terms-of-use' => 'pages#terms'
  match '/how-it-works' => 'pages#howitworks', :as => 'howitworks'
	match '/get-your-dashboard' => 'members#get_your_dashboard'
  match '/coupons' => 'pages#coupons', :as => 'coupons'
  match '/freebies-and-discounts' => 'pages#freebies', :as => 'freebies'
  match '/travel-deals' => 'pages#traveldeals', :as => 'traveldeals'
  match '/hot-deals' => 'pages#hotdeals', :as => 'hotdeals'
  match '/dbunsub' => 'dbunsub#new', :as => 'dbunsub'
  match '/unsubscribe' => 'members#unsubscribe', :as => 'unsubscribe'
  
  match '/advertisers', :to => 'advertisers#new', :as =>'advertisers'
  match '/flow_step' => 'members#flow_step'
  match '/step2' => 'members#step_two'
  match '/step3' => 'members#step_three'
  match '/promo/:promo' => 'members#promo'
  match '/home' => 'members#home', :as => 'home'
	match '/offers' => 'offers#index', :as => 'offers'
  match '/signup' => redirect('/')
  match '/profile', :to => 'members#edit'
  match '/reset_password', :to => 'members#reset_password', :as => 'reset_password'
  match '/recover_password', :to => 'members#recover_password', :as => 'recover_password'
	match '/newsletter' => 'pages#newsletter'
  match '/advertisers' => 'advertisers#new', :as => 'feature_a_deal'
  match '/kiwi' => redirect('/?utm_source=KiwiMag&utm_medium=DMInsert&utm_campaign=052012')
  match '/kiwimag' => redirect('/?utm_source=KiwiMag&utm_medium=DMInsert&utm_campaign=052012')
  match '/kiwimagazine' => redirect('/?utm_source=KiwiMag&utm_medium=DMInsert&utm_campaign=052012')
  match '/saving-form1', :controller => 'members', :action => 'new', :f => 'full_form_member'
  match '/saving-form1-virtualpiggy', :controller => 'members', :action => 'new', :f => 'full_form_member_virtualpiggy'
  match '/saving-form1-moolala', :controller => 'members', :action => 'new', :f => 'full_form_member_moolala'
  match '/saving-form1-shopsocial', :controller => 'members', :action => 'new', :f => 'full_form_member_shopsocial'
  match '/virtualpiggy', :controller => 'members', :action => 'new', :x => 'pm_virtual_piggy'

  #=========Redirects=========
  match'/mom365' => redirect('/saving-form1?utm_source=magazine&utm_medium=mom365&utm_campaign=free-diapers')
  match '/:path', :controller => 'content_pages', :action => 'show'

  namespace 'api' do
    match '/v1/:action' => 'v1'
    scope "/optins" do
      post "/register" => "coreg_optins#register_optin"
      #post ":coreg_id" => "coreg_optins#create"
      get  "coregs" => "coreg_optins#list"
      get  "coreg_optins/:id" => "coreg_optins#confirm"
   end
  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
   match '*a', :to => 'errors#fourofour'
end
