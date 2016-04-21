ActiveAdmin.register ClientMember do
  menu :priority=>10
  
  scope_to :current_client, :association_method=>:client_members
  
  includes [:member]
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :member_phone, :name, :sex, :borned_at, :pic, :address, :email
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  action_item :edit_profile, only: :index do
    link_to '编辑资料项', edit_client_path(Client.find(session[:current_client_id]))
  end

  action_item :import, only: :index do
    link_to '导入会员', new_import_path
  end

  action_item :groups, only: :index do
    link_to '编辑会员组', groups_path
  end  

  collection_action :import do
    
  end

  show do 
    attributes_table do
      row :id do
        resource.member.try(:id)
      end
      row :member_phone if Client.find(session[:current_client_id]).show_phone
      image_row :pic if Client.find(session[:current_client_id]).show_pic
      row :name if Client.find(session[:current_client_id]).show_name
      i18n_row :sex if Client.find(session[:current_client_id]).show_sex
      row :borned_at if Client.find(session[:current_client_id]).show_borned_at
      row :address if Client.find(session[:current_client_id]).show_address
      row :email if Client.find(session[:current_client_id]).show_email
    end

    panel "所属会员组" do
      table_for resource.group_members.by_client(resource.client_id) do
        column('会员组') do |i|
          i.group.try(:title)
        end
        column('有效期') do |i|
          "#{i.started_at} ~ #{i.ended_at}"
        end
      end
    end
  end

  form do |f|
    f.inputs I18n.t(:detail) do
      f.input :id , :input_html => { :disabled=>true, :value=>f.object.member.try(:id) } 
      if Client.find(session[:current_client_id]).show_phone
        f.input :member_phone, :input_html => { :disabled=>true } 
      end

      if Client.find(session[:current_client_id]).show_pic
        f.input :pic
      end
      
      if Client.find(session[:current_client_id]).show_name
        f.input :name
      end
      
      if Client.find(session[:current_client_id]).show_sex
        f.input :sex, :collection=> Member::Sex
      end
      
      if Client.find(session[:current_client_id]).show_borned_at
        f.input :borned_at, as: :date_time_picker, datepicker_options: { min_date: "2013-10-8",        max_date: "+3D" }
      end
      
      if Client.find(session[:current_client_id]).show_address
        f.input :address
      end
      
      if Client.find(session[:current_client_id]).show_email
        f.input :email
      end
      
    end

    f.actions    
  end

  index do
    selectable_column
    column :id do |cm|
      cm.member.id if cm.member
    end

    column :phone do |cm|
      cm.member_phone
    end

    column :wechat_binded do |cm|
      shifou cm.member.try(:wechat_binded)
    end

    column '会员组/有效期' do |cm|
      s = ''
      # 
      cm.group_members.by_client(cm.client_id).each do |gm|
        s = "#{s} #{gm.group.title} #{gm.started_at} ~ #{gm.ended_at}<br/>"
      end
      s.html_safe
    end
    actions
  end

  filter :member_phone
  filter :name
  filter :groups, :collection => proc{ Client.find(session[:current_client_id]).groups }
end
