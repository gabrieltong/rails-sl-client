ActiveAdmin.register CardBTpl do
  menu false
  permit_params :website, :title, :cover, :share_cover, :short_desc, :guide_cover, :desc, :intro, :draw_type, :prediction,
  :person_limit, :acquire_from, :acquire_to, :change_remain, :_from, :allow_share, :public,
  :group_ids=>[], :images_attributes=>[:id, :file, :_destroy], :draw_awards_attributes=>[:id, :title, :award_id, :number], :acquire_weeks=>[],:periods_attributes=>[:id, :from, :to, :number, :person_limit, :_destroy]
  # permit_params
  scope_to :current_client, :association_method=>:card_b_tpls

  controller do
    def index
      redirect_to card_tpls_path(:scope=>:b)
    end
  end

  member_action :setting, :method=>[:get, :patch] do 
    if request.get?
      resource.change_remain = 0
    else
      if resource.update_attributes(permitted_params[:card_b_tpl])
        redirect_to setting_card_b_tpl_path(resource), :notice=>I18n.t(:update_success)
      end
    end
  end

  member_action :permission, :method=>[:get, :patch] do
    if request.get?
    else
      if resource.update_attributes(permitted_params[:card_b_tpl])
        redirect_to permission_card_b_tpl_path(resource), :notice=>I18n.t(:update_success)
      end
    end
  end

  action_item :setting, :only=>:show do
    link_to '设定器', setting_card_b_tpl_path(resource)
  end

  action_item :permission, :only=>:show do 
    link_to '权限', permission_card_b_tpl_path(resource)
  end

  action_item :report, :only=>:show do 
    link_to '报表', card_b_tpl_card_bs_path(resource)
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
      f.input :cover, :hint=>"图片建议尺寸640像素*200像素，大小不超过512kb <br/> #{thumb(f.object, :cover)}".html_safe
      f.input :share_cover, :hint=>"图片建议尺寸140像素*140像素，大小不超过200kb <br/> #{thumb(f.object, :share_cover)}".html_safe
      f.input :short_desc, :as=>:string, :hint=>'简单描述提供的优惠或特色服务，吸引消费者。长度不超过30个汉字'
    end

    # f.inputs "Meta Data", for: [:card_tpl_setting, f.object.card_tpl_setting || CardTplSetting.new] do |setting_f|
    # 	setting_f.input :use_h01
    # end

    f.inputs '抽奖详情' do
      f.input :draw_type, :as=>:radio, :collection=>CardBTpl::DrawType
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

    f.inputs '奖项设置' do
      # , heading: 'Themes', allow_destroy: true, new_record: true
      f.has_many :draw_awards, heading: false, allow_destroy: true do |d_f|
        d_f.input :title
        d_f.input :award_tpl, :collection=>Client.find(session[:current_client_id]).card_a_tpls
        d_f.input :number
      end

      f.input :prediction, :hint=>'直接影响中奖概率'
    end

    f.actions		
  end


  show do
    panel I18n.t(:detail) do
      attributes_table_for resource do
        row :title
        thumb_row :cover
        thumb_row :share_cover
        row :short_desc
      end
    end

    panel '抽奖详情' do
      attributes_table_for resource do
        row :draw_type do
          I18n.t("draw_type.#{resource.draw_type}")
        end
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

    panel '奖项设置' do
      table_for resource.draw_awards do
        column :title
        column :award
        column :number
      end
      attributes_table_for resource do
        row :prediction
      end
    end	
  end
end