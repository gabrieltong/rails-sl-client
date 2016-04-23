ActiveAdmin.register CardATpl do
	menu false
	permit_params :website, :title, :indate_type, :indate_from, :indate_to, :indate_after, :indate_today, :cover, :share_cover, :short_desc, 
  :guide_cover, :desc, :intro, :person_limit, :acquire_from, :acquire_to, :change_remain, :_from, :allow_share, :public,
  :group_ids=>[], :check_use_weeks=>[], :acquire_use_weeks=>[], :use_hours=>[], :images_attributes=>[:id, :file, :_destroy], :shop_ids=>[], :periods_attributes=>[:id, :from, :to, :number, :person_limit, :_destroy]
	# permit_params 
	scope_to :current_client, :association_method=>:card_a_tpls

	controller do 
		def index
			redirect_to card_tpls_path(:scope=>:a)
		end

    # def update
    #   update! do
    #     if !resource.valid? and resource._from == 'setting'
    #       redirect_to setting_card_a_tpl_path(resource)
    #       return
    #     end
    #   end
    # end

    # def setting
    #   if request.get?
    #     resource.change_remain = 0
    #     resource._from = :setting
    #   else
    #     resource = CardATpl.find(params[:id])
    #     if resource.update_attributes(permitted_params[:card_a_tpl])
    #       redirect_to card_a_tpl_path(resource)
    #     end
    #   end
    # end
	end

  member_action :setting, :method=>[:get, :patch] do 
    if request.get?
      resource.change_remain = 0
    else
      if resource.update_attributes(permitted_params[:card_a_tpl])
        redirect_to setting_card_a_tpl_path(resource), :notice=>I18n.t(:update_success)
      end
    end
  end

  member_action :permission, :method=>[:get, :patch] do
    if request.get?
    else
      if resource.update_attributes(permitted_params[:card_a_tpl])
        redirect_to permission_card_a_tpl_path(resource), :notice=>I18n.t(:update_success)
      end
    end
  end

  # member_action :setting, :method=>[:get, :patch, :put] do 
  #   if request.get?
  #     resource.change_remain = 0
  #     resource._from = :setting
  #   else
  #     resource = CardATpl.find(params[:id])
      
  #     if resource.update_attributes(permitted_params[:card_a_tpl])
  #       redirect_to card_a_tpl_path(resource)
  #     end
  #   end
  # end

  action_item :setting, :only=>:show do 
    link_to '设定器', setting_card_a_tpl_path(resource)
  end

  action_item :permission, :only=>:show do 
    link_to '权限', permission_card_a_tpl_path(resource)
  end

  sidebar '投放数量变化', :only=>[:setting] do 
    table_for resource.quantities.order('id desc'), :class=>'index index_table' do 
      column :number
      column :created_at
      column :member
    end
  end

	form do |f|
		f.semantic_errors *f.object.errors.keys

		f.inputs I18n.t(:detail) do
      f.input :title, :hint=>"建议添加优惠券提供的服务或商品名称，描述卡券提供的具体优惠"
      f.input :indate_type, :collection=>CardATpl::IndateType, :as=>:radio
      f.input :indate_from , as: :date_time_picker, datepicker_options: { min_date: "2013-10-8",        max_date: "+3D" }, :hint=>'请选择日期/时间'
      f.input :indate_to , as: :date_time_picker, datepicker_options: { min_date: "2013-10-8",        max_date: "+3D" }, :hint=>'请选择日期/时间'
      f.input :indate_after, :hint=>'领取后，多少天内有效'
      f.input :indate_today, :hint=>'勾选此项后，从领取次日计算有效期，否则从当日0点开始计时'
      f.input :check_use_weeks, :collection=>CardTpl::UseWeeks, :as=>:check_boxes
      f.input :use_hours, :collection=>CardTpl::UseHours, :as=>:check_boxes
      f.input :cover, :hint=>"图片建议尺寸640像素*200像素，大小不超过512kb <br/> #{thumb(f.object, :cover)}".html_safe
      f.input :share_cover, :hint=>"图片建议尺寸140像素*140像素，大小不超过200kb <br/> #{thumb(f.object, :share_cover)}".html_safe
      f.input :short_desc, :as=>:string, :hint=>'简单描述提供的优惠或特色服务，吸引消费者。长度不超过30个汉字'
      f.input :shops, :collection=>Client.find(session[:current_client_id]).shops, :as=>:check_boxes
    end

    # f.inputs "Meta Data", for: [:card_tpl_setting, f.object.card_tpl_setting || CardTplSetting.new] do |setting_f|
    # 	setting_f.input :use_h01
    # end

    f.inputs '优惠详情' do
    	f.input :desc, :as=>:text, :input_html=>{:rows=>5}, :hint=>'长度不超过300个汉字'
    	f.input :intro, :as=>:text, :input_html=>{:rows=>5}, :hint=>'长度不超过300个汉字'
    	f.input :website, :hint=>'可填写商家更多详细信息页面网址'
    	f.input :guide_cover, :hint=>"图片建议宽度960像素，大小不超过512kb <br/> #{thumb(f.object, :guide_cover)}".html_safe
    end	

    # f.has_many :images do |item|
    #   item.inputs '附件' do 
    #     item.input :file
    #   end
    # end
    f.inputs '图片展示' do
      # , heading: 'Themes', allow_destroy: true, new_record: true
      f.has_many :images, heading: false, allow_destroy: true do |i_f|
        i_f.input :file, :hint=>"图片大小<=1m, 最多10张图片<br/> #{thumb(i_f.object, :file)}".html_safe
      end
    end

    f.actions
	end	


  show do
    panel I18n.t(:detail) do
      attributes_table_for resource do
        row :title
        i18n_row_by_key :indate_type
        if resource.indate_type == 'fixed'
          row :indate_from
          row :indate_to
        end
        if resource.indate_type == 'dynamic'
          row :indate_after
          shifou_row :indate_today
        end
        row :check_use_weeks do 
          resource.check_use_weeks.reject {|i|i.blank?}.map {|i|I18n.t("check_use_weeks.#{i}")}.join(', ')
        end
        row :use_hours do 
          resource.use_hours.reject {|i|i.blank?}.map {|i|I18n.t("use_hours.#{i}")}.join(', ')
        end
        thumb_row :cover
        thumb_row :share_cover
        row :short_desc
        row :shops do 
          resource.shops.collect {|i|link_to(i.title, shop_path(i))}.join(',').html_safe
        end
      end
    end

    panel '优惠详情' do
      attributes_table_for resource do
        row :desc
        row :intro
        row :website
        thumb_row :guide_cover
      end
    end

    panel '图片展示' do
      table do
        tr do
          resource.images.each do |i|
          td do 
            thumb(i, :file)
          end
          end
        end
      end
    end 

  end
end