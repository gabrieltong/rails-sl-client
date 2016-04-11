ActiveAdmin.register ClientMember do
	menu false
	
	includes :member
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

	index do
		selectable_column
    column :id do |cm|
    	cm.member.id
    end

    column :phone do |cm|
    	cm.member.phone
    end

    column :wechat_binded do |cm|
    	cm.member.wechat_binded
    end

    actions
	end

	filter :group
end
