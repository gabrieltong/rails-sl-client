
ActiveAdmin.register CardA do
  decorate_with CardDecorator
  menu false
  belongs_to :card_a_tpl, :optional=>true
  includes [:card_tpl]
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
  # scope :checkable
  scope :acquirable
  scope :locked
  scope :acquired
  scope :checked
  # scope :not_locked
  # scope :not_acquired
  
  # scope :not_checked
  # scope :active
  # scope :inactive
  

  index do 
    column :added_quantity_id
    column :code, :sortable=>false
    column :state do |i|
      i.state_zh
    end
    # date_column :from, :sortable=>false
    # date_column :to, :sortable=>false
    column :sender_phone
    column :phone
    column :checker_phone
    column :time
  end

  # filter :type, :as=>:select, :collection=>Card::Type
  # filter :type, :as=>:select, :collection=>CardTpl::Type
  filter :phone
  # filter :card_tpl
  filter :locked_by_tpl
  filter :sender_phone
  filter :checker_phone
  filter :acquired_at
  filter :checked_at
  filter :from
  filter :to
end