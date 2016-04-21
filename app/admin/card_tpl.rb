ActiveAdmin.register CardTpl do
  menu :priority=>30

  permit_params :allow_share, :public

  scope_to :current_client

  scope :all
  scope :a
  scope :b

  controller do 
		def create
			redirect_to card_tpls_path
		end

		def edit
			if resource.is_a? CardATpl
				redirect_to edit_card_a_tpl_path(resource)
			end

			if resource.is_a? CardBTpl
				redirect_to edit_card_b_tpl_path(resource)
			end
		end

		def show
			if resource.is_a? CardATpl
				redirect_to card_a_tpl_path(resource)
			end

			if resource.is_a? CardBTpl
				redirect_to card_b_tpl_path(resource)
			end
		end

	end

	member_action :setting do 
		if resource.is_a? CardATpl
			redirect_to setting_card_a_tpl_path(resource)
		end

		if resource.is_a? CardBTpl
			redirect_to setting_card_b_tpl_path(resource)
		end		
	end

	member_action :permission do 
		if resource.is_a? CardATpl
			redirect_to permission_card_a_tpl_path(resource)
		end

		if resource.is_a? CardBTpl
			redirect_to permission_card_b_tpl_path(resource)
		end
	end

	member_action :report do 

	end

	member_action :pause do 

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



  action_item :new_card_a_tpl, :only=>:index do 
    link_to I18n.t('active_admin.new_model', model: CardATpl.model_name.human), new_card_a_tpl_path
  end

  action_item :new_card_b_tpl, :only=>:index do 
    link_to I18n.t('active_admin.new_model', model: CardBTpl.model_name.human), new_card_b_tpl_path
  end

	index do 
		selectable_column
    id_column
    column :type
    column :title
    actions :defaults=>true do |i|
    	[
    		link_to('设定器', setting_card_tpl_path(i)),
    		link_to('权限', permission_card_tpl_path(i)),
	    	link_to('报表', report_card_tpl_path(i)),
	    	link_to('暂停', pause_card_tpl_path(i))
	    ].join(' ').html_safe
    end
	end

	filter :id
	filter :type
	filter :title
	filter :status
end
