ActiveAdmin.register Client do
	permit_params :show_name,:show_phone,:show_sex,:show_borded_at,:show_pic,:show_address,:show_email

	# scope_to :current_member, :association_method=>:managed_clients
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
 	action_item :members, :only=>:show do 
    link_to Member.model_name.human, client_client_members_path(resource)
  end

  action_item :groups, :only=>:show do 
    link_to Group.model_name.human, client_groups_path(resource)
  end
  
  action_item :shops, :only=>:show do 
    link_to Shop.model_name.human, client_shops_path(resource)
  end

  action_item :client_managers, :only=>:show do 
    link_to ClientManager.model_name.human, client_client_managers_path(resource)
  end
	
	index do |subject|
		selectable_column
    id_column
    column :title
    actions
	end

	form do |f|
		f.semantic_errors *f.object.errors.keys
		inputs I18n.t(:detail) do
			f.input :show_name
			f.input :show_phone
			f.input :show_sex
			f.input :show_borded_at
			f.input :show_pic
			f.input :show_address
			f.input :show_email
		end
		actions
	end

	show do 
		attributes_table do
			row :id
			row :hqhj
			row :hyzx
			row :title
			row :reg
			row :address
			row :location_y
			row :localtion_x
			row :area
			row :phone
			row :logo do 
				image_tag resource.logo.url(:thumb)
			end
			row :type
			row :service_started
			row :service_ended_at
			row :website
			row :tags_text
			row :wechat_account
			row :wechat_title				
			row :logo do 
				image_tag resource.wechat_logo.url(:thumb)
			end
			row :admin_phone
			shifou_row :is_sp
			if resource.sp
				row :sp, :collection=>Client.sp			
			end
			shifou_row :show_name
			shifou_row :show_phone
			shifou_row :show_sex
			shifou_row :show_borded_at
			shifou_row :show_pic
			shifou_row :show_address
			shifou_row :show_email
		end
	end

	filter :title
end
