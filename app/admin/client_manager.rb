ActiveAdmin.register ClientManager do
  menu false
  permit_params ClientManager.permit_params

  includes :shop

  scope :all
  scope :admin
  scope :checker
  scope :sender

  controller do
    belongs_to :client, optional: true
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    inputs I18n.t(:detail) do
      f.input :shop, :collection=>Client.find(params[:client_id]).shops
      f.input :phone
      f.input :name
      f.input :admin
      f.input :checker
      f.input :sender
    end
    actions
  end

  index do
    selectable_column
    id_column
    column :shop
    column :phone
    column :name
    column :admin
    column :checker
    column :sender
    actions
  end

  show do
    attributes_table do
      row :shop
      row :phone
      row :name
      shifou_row :admin
      shifou_row :checker
      shifou_row :sender
    end
  end

  filter :shop
  filter :phone
  filter :name
  filter :admin
  filter :checker
  filter :sender
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


end
