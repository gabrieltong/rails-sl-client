class MemberDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  def text_sex
  	case sex 
  	when 'male'
  		'男'
  	when 'female'
  		'女'
  	else
  		''
  	end  		
  end
end