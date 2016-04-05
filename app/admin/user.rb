ActiveAdmin.register User, as: "Member" do
	permit_params User.permit_params	
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

	index do |subject|
		selectable_column
    id_column
    column :phone
    actions
	end

	form do |f|
		f.semantic_errors *f.object.errors.keys
		inputs I18n.t(:detail) do
			f.input :phone
	    f.input :password
	  end
		actions		
	end

	show do 
		attributes_table do
			row :phone
	    row :password
		end
	end
end
