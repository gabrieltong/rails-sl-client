ActiveAdmin.register Group do
	menu false

	permit_params Group.permit_params
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

	controller do
    belongs_to :client, optional: true
  end

	form do |f|
    f.inputs I18n.t(:detail) do
      f.input :title
      f.input :position
      f.input :default
      f.input :active      
      f.input :desc, :as=>:text
    end

    f.actions
  end  

  show do 
    attributes_table do
      row :title
      row :position
      row :default
      row :active      
      row :desc
    end
  end

  index do
    selectable_column
    id_column
    column :title
    column :position
    column :default
    column :active      
    column :desc
    actions
  end  

	filter :title
	filter :position
	filter :default
	filter :active      
	filter :desc
end
