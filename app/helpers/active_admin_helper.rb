# encoding: utf-8
module ActiveAdmin
  module Views
    class TableFor
      def date_column(attribute, options={})
        column(attribute, options) do  |model| 
          model[attribute].strftime('%F') unless model[attribute].nil?
        end
      end

      def truncate_column(attribute, options={})
        column(attribute, options){ |model| truncate(model[attribute], omision: "...", length: 30)}
      end

      def safe_column(attribute, options={})
        column(attribute, options){ |model| model[attribute].try(:html_safe) }
      end

      def yesno_column(attribute, options={})
        column(attribute, options) do |model| 
          case model[attribute] 
          when true
            '&#x2714;'.html_safe
          when false
            '&#x2717;'.html_safe 
          else
            ''
          end
        end
      end

      def shifou_column(attribute, options={})
        column(attribute, options) do |model| 
          case model[attribute] 
          when true
            '是'
          when false
            '否'
          else
            ''
          end
        end
      end

      def blank_column(attribute, options={})
        column(attribute, options){ |model| model[attribute] ? '&#x2714;'.html_safe : '&#x2717;'.html_safe }
      end
      def i18n_column(attribute, options={})
        column(attribute, options){ |model| model[attribute] ? I18n.t(model[attribute]) : ''}
      end
    end
    class AttributesTable
      
      
      def i18n_row_by_key(attribute)
        row(attribute) do  |model| 
          if model[attribute] && !model[attribute].blank?
            I18n.t "#{attribute}.#{model[attribute]}" 
          end
        end
      end

      def i18n_row(attribute)
        row(attribute) do  |model| 
          if model[attribute] && !model[attribute].blank?
            I18n.t model[attribute] 
          end
        end
      end

      
      def a_row(attribute)
        row(attribute) do  |model| 
          c = model[attribute]
          "<a href=#{c}>#{c}</a>".html_safe
        end
      end

      def safe_row(attribute)
        row(attribute){ |model| model[attribute].try(:html_safe) }
      end

      def yesno_row(attribute)
        row(attribute) do  |model| 
          case model[attribute] 
          when true
            '&#x2714;'.html_safe
          when false
            '&#x2717;'.html_safe 
          else
            ''
          end
        end
      end

      def shifou_row(attribute)
        row(attribute) do  |model| 
          case model[attribute] 
          when true
            '是'
          when false
            '否'
          else
            ''
          end
        end
      end

      def blank_row(attribute)
        row(attribute){ |model| model[attribute] ? model[attribute] : '无' }
      end

      def image_row(attribute)
        row(attribute) do |model|
          if !model.try(attribute).blank?
            link_to image_tag(model.try(attribute).url(:medium)),model.try(attribute).url,target: '_blank'
          end
        end
      end

      def thumb_row(attribute)
        row(attribute) do |model|
          if !model.try(attribute).blank?
            link_to image_tag(model.try(attribute).url(:thumb)),model.try(attribute).url,target: '_blank'
          end
        end
      end

      def file_row(attribute)
        row(attribute) do |model|
          link_to model.try("#{attribute}_file_name"),model.try(attribute).url,target: '_blank'
        end
      end
    end
  end
end

module ActiveAdminHelper
  def feedbacked(review)
    review.feedbacked ? '已反馈' : '未反馈'
  end

  def set_feedbacked_link(project,review)
    unless review.feedbacked
      link_to '设置为反馈',set_feedbacked_project_review_path(project,review),:class=>'btn btn-mini'
    else
      feedbacked(review)
    end
  end

  def shifou(value)
    return '是' if value == true || value == 1
    return '否' if value == false || value == 0
    '否'
  end

  def need(value)
    return '需要' if value == true || value == 1
    return '不需要' if value == false || value == 0
    ''
  end

  def keyi(value)
    return '可以' if value == true || value == 1
    return '不可以' if value == false || value == 0
    ''
  end

  def youxian(value)
    return '优先' if value == true || value == 1
    return '不优先' if value == false || value == 0
    ''
  end

  class MyOption
    attr_accessor :label
    attr_accessor :value
  end

  def i18n_collection(keys)
    keys.map do |key|
      s = MyOption.new
      s.label = t key
      s.value = key
      s 
    end
  end

  def percentage(value)
    "#{(value*100).round(3)}%"
  end

  def response_msg notification
    unless notification.normal?
      msg = ''
      msg = msg + t(notification.response) if notification.response 
      msg = msg + link_to('同意',confirm_admin_notification_path(notification),:class=>'btn btn-mini') unless notification.response
      msg = msg + ' '  
      msg = msg + link_to('不同意',unconfirm_admin_notification_path(notification),:class=>'btn btn-mini') unless notification.response 
      msg.html_safe
    end
  end
end
