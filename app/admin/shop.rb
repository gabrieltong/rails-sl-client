ActiveAdmin.register Shop do
  menu false
  permit_params Shop.permit_params

  controller do
    belongs_to :client, optional: true
  end

  form do |f|
    f.inputs I18n.t(:detail) do
      f.input :title
      f.input :address
      f.input :phone
      f.input :longitude
      f.input :latitude
    end
    actions
  end

  show do 
    attributes_table do
      row :title
      row :address
      row :phone
      row :longitude
      row :latitude
    end
  end

  index do
    selectable_column
    id_column
    column :title
    column :address
    column :phone
    column :longitude
    column :latitude
    actions
  end

  filter :title
  filter :address
  filter :phone
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
