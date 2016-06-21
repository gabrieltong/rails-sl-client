ActiveAdmin.register CardB do
  menu false
  decorate_with CardDecorator
  belongs_to :card_b_tpl, :optional=>true
  includes [:card_tpl=>{}, :locked_card=>{:card_tpl=>{},:locked_by_card=>{:card_tpl=>{}}}]

  # scope :all
  # scope :locked_other
  # scope :locked_none
  # scope :bingo
  # scope :not_acquired
  
  controller do
    def scoped_collection
      end_of_association_chain.locked_other
    end
  end
  
  index do 
    column :added_quantity_id
    column :code
    column :locked_card
    column :state do |i|
      i.locked_card.decorate.state_zh if i.locked_card
    end
    column :phone
  end

  # filter :type, :as=>:select, :collection=>Card::Type
  # filter :type, :as=>:select, :collection=>CardTpl::Type
  filter :phone
  # filter :card_tpl
end
