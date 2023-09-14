ActiveAdmin.register PageCoreg do

  index do
    column :coreg, :sortable => false do |f|
      f.coreg.present? ? image_tag(f.coreg.image.url(:thumb)) : ''
    end
    column :page do |f|
      label f.page.try :name
    end
    column "Created", :created_at
    column "Updated", :updated_at
    default_actions
  end

end
