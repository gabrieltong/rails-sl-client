
ActiveAdmin.register CardA do
  menu false
  belongs_to :card_a_tpl, :optional=>true
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
  scope :all
  scope :checkable
  scope :acquirable
  scope :locked
  scope :not_locked
  scope :acquired
  scope :not_acquired
  scope :checked
  scope :not_checked
  scope :active
  scope :inactive
  

  index do 
    column :added_quantity_id
    column :code
    column :sender_phone
    column :phone
    column :checker_phone
    column :time
    column :state
  end

  # filter :type, :as=>:select, :collection=>Card::Type
  # filter :type, :as=>:select, :collection=>CardTpl::Type
  filter :phone
  filter :card_tpl
  filter :locked_by_tpl
  filter :sender_phone
  filter :checker_phone
  filter :acquired_at
  filter :checked_at
  filter :from
  filter :to
end