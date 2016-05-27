ActiveAdmin.register CardTpl do
  decorate_with CardTplDecorator
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
    if resource.is_a? CardATpl
      redirect_to card_a_tpl_card_as_path(resource)
    end

    if resource.is_a? CardBTpl
      redirect_to card_b_tpl_card_bs_path(resource)
    end
  end

  member_action :activate do
    resource.activate if resource.can_activate?
    if request.get?
      redirect_to card_tpls_path
    else
      render :json=>{}
    end
  end

  member_action :pause do
    resource.pause if resource.can_pause?
    if request.get?
      redirect_to card_tpls_path
    else
      render :json=>{}
    end
  end

  member_action :deactivate do
    resource.deactivate if resource.can_deactivate?
    if request.get?
      redirect_to card_tpls_path
    else
      render :json=>{}
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



  action_item :new_card_a_tpl, :only=>:index do 
    link_to I18n.t('active_admin.new_model', model: CardATpl.model_name.human), new_card_a_tpl_path
  end

  action_item :new_card_b_tpl, :only=>:index do 
    link_to I18n.t('active_admin.new_model', model: CardBTpl.model_name.human), new_card_b_tpl_path
  end

  index do
    selectable_column
    id_column
    column :client_id
    column :type do |i|
      I18n.t("activerecord.models.#{i.type.underscore}")
    end

    column :acquire_type do |i|
      I18n.t("activerecord.models.#{i.acquire_type.underscore}")
    end

    column :state do |i|
      i.color_state
    end
    column :title
    column :acquire_range do |i|
      "#{i.acquire_from.strftime("%F %T")}<br/>#{i.acquire_to.strftime("%F %T")}".html_safe
    end
    column :remain do |i|
      "#{i.remain}<br/>总#{i.total}".html_safe
    end    
    actions :defaults=>true do |i|
      links = [
        link_to('设定器', setting_card_tpl_path(i)),
        link_to('权限', permission_card_tpl_path(i)),
        link_to('报表', report_card_tpl_path(i)),
        # link_to('暂停', pause_card_tpl_path(i)),
      ]
      links.push(link_to(I18n.t('helpers.submit.activate'), activate_card_tpl_path(i))) if i.can_activate?
      links.push(link_to(I18n.t('helpers.submit.deactivate'), deactivate_card_tpl_path(i))) if i.can_deactivate?
      links.push(link_to(I18n.t('helpers.submit.pause'), pause_card_tpl_path(i))) if i.can_pause?
      links.join(' ').html_safe
    end
  end

  filter :id
  filter :type, :as=>:select, :collection=>CardTpl::Type
  filter :title
  filter :state, :as=>:select, :collection=>CardTpl::State
end
