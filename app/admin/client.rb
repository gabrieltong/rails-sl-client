ActiveAdmin.register Client do
	permit_params Client.permit_params
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
    column :title
    column :service_deadline
    column :admin_phone
    column :sp
    actions
	end

	form do |f|
		f.semantic_errors *f.object.errors.keys
		inputs I18n.t(:detail) do
			f.input :title
			f.input :reg
			f.input :address
			f.input :location_y
			f.input :localtion_x
			f.input :area
			f.input :logo, :hint=>image_tag(resource.logo.url(:thumb))
			f.input :phone
			f.input :type
			f.input :service_started, :as=>:datepicker
			f.input :service_ended_at, :as=>:datepicker
			f.input :website
			f.input :tags_text, :input_html=>{:class=>:tags}
			f.input :wechat_account
			f.input :wechat_title	
			f.input :wechat_logo, :hint=>image_tag(resource.wechat_logo.url(:thumb))
			f.input :admin_phone, :hine=>I18n.t('activerecord.attributes.clients.admin_phone_hint')
			f.input :is_sp
			f.input :sp, :collection=>Client.sp
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
		end
	end

	filter :title
	filter :reg
	filter :address
	filter :location_y
	filter :localtion_x
	filter :area
	filter :phone
	filter :type
	filter :service_started
	filter :service_ended_at
	filter :website
	filter :wechat_account
	filter :wechat_title
end
