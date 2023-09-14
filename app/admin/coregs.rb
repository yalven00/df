ActiveAdmin.register Coreg do

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :name
      f.input :taken_default
      f.input :screen_key
      f.input :endpoint
      f.input :revenue
      f.input :description, :input_html => {:cols => 10 }, :as => :text
      f.input :prompt, :input_html => {:cols => 10 }, :as => :text
      f.input :image, :as => :file, :hint => f.template.image_tag(f.object.image.url(:thumb))
      f.input :expires_on, :prompt => {:day => "Day", :month => "Month", :year => "Year", :hour => "Hr", :minute => "Min", :seconds => "Sec"}
    end

    f.has_many :coreg_params do |coreg_param|
      coreg_param.inputs
    end

    f.buttons
  end

  index do
    column :id, :sortable => :id do |coreg|
      link_to coreg.id, admin_coreg_path(coreg)
    end
    column :image, :sortable => false do |f|
      link_to image_tag(f.image.url(:thumb)), admin_coreg_path(f)
    end
    column :name
    column :revenue
    column :screen_key
    column :endpoint
    column :taken_default
    column "Created", :created_at
    column "Updated", :updated_at
    column :expires_on
    default_actions
  end

  show do
    attributes_table do 
      [:id, :name, :screen_key, :endpoint, :description, :prompt, :image, :taken_default, :created_at, :updated_at,:expires_on].each {|x| row x}
      panel "Coreg Params" do
        table_for(coreg.coreg_params) do 
          column("id", :sortable => :id) {|coreg_param| link_to "##{coreg_param.id}", admin_coreg_param_path(coreg_param) }
          [:name, :label, :field_type, :sequence, :value, :display, :match, :required, :select_options, :select_prompt, :min_length].each {|x| column x}
        end
      end
    end
  end

end
