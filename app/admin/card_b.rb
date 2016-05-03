ActiveAdmin.register CardB do
	menu false
	belongs_to :card_b_tpl, :optional=>true

	scope :all
	scope :has_locked
	scope :locked_none
	scope :bingo
	# scope :not_acquired
	

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
end
