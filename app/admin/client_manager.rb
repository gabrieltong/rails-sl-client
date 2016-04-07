ActiveAdmin.register ClientManager do
	permit_params ClientManager.permit_params

	scope :all
	scope :admin
	scope :checker
	scope :sender

	controller do
    belongs_to :client, optional: true

    def create
    	m = Member.find_by_phone(params[:client_manager][:phone])
    	unless m 
    		m = Member.new(:phone=>params[:client_manager][:phone])
    		m.password = 12345678
    		m.save
    	end
    	params[:client_manager][:member_id] = m.id
    	create!
    end

    def update
    	m = Member.find_by_phone(params[:client_manager][:phone])
    	unless m 
    		m = Member.new(:phone=>params[:client_manager][:phone])
    		m.password = 12345678
    		m.save
    	end
    	params[:client_manager][:member_id] = m.id
    	update!
    end
  end

  form do |f|
		f.semantic_errors *f.object.errors.keys
		inputs I18n.t(:detail) do
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
    column :phone
		column :name
		column :admin
		column :checker
		column :sender
    actions
	end

	show do 
		attributes_table do
			row :phone
			row :name
			shifou_row :admin
			shifou_row :checker
			shifou_row :sender
		end
	end

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
