ActiveAdmin.register Client do
  menu :priority=>20

  permit_params :show_name,:show_phone,:show_sex,:show_borned_at,:show_pic,:show_address,:show_email

  scope_to :current_client

  controller do
    def index
      redirect_to client_path(current_client)
    end

    def update
      update! do
        redirect_to client_members_path
        return
      end
    end
  end
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
  action_item :client_members, :only=>:show do
    link_to ClientMember.model_name.human, client_client_members_path(resource)
  end

  # action_item :groups, :only=>:show do 
  #   link_to Group.model_name.human, client_groups_path(resource)
  # end
  
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
      f.input :show_borned_at
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
      image_row :logo
      row :type
      row :service_started
      row :service_ended_at
      row :website
      row :tags_text
      row :wechat_account
      row :wechat_title       
      image_row :wechat_logo
      row :admin_phone
      row :sp, :collection=>Client.sp
    end
  end

  filter :title
end
