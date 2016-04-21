ActiveAdmin.register Group do
	# menu :priority=>20 
  menu false
	permit_params Group.permit_params
  scope_to :current_client, :association_method=>:groups
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

  member_action :set_default, method: :get do 
    resource.to_default
    redirect_to request.referer, notice: "设置默认成功"
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
      shifou_row :default
      shifou_row :active      
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
    actions :default=>true,  min_width: "180px" do |group|
      link_to '设为默认', set_default_group_path(group)
    end
  end  

	filter :title
	filter :position
	filter :default
	filter :active      
	filter :desc
end
