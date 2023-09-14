ActiveAdmin.register CoregOptin do

index do
  column :id
  column :created_at do |coreg_optin|
    coreg_optin.created_at.strftime("%m-%d-%Y %H:%M")
  end
  column :success
  column :sent
  column :response do |coreg_optin|
    div :class=>"response" do
      coreg_optin.response
    end
  end
  column "query",:full_query do |coreg_optin|
    div :class=>"full_query" do
    coreg_optin.full_query
    end
  end
  column :email
  

end

  def create
    coreg = CoregOptin.find(params[:coreg_id])
  end

  #filter :title
  #filter :author, :as => :select, :collection => lambda{ Product.authors }
  filter :coreg_id
  filter :created_at
  filter :taken, :as => :select, :collection => [1, 0]
  filter :success, :as => :select, :collection => [1, 0]
  
end
