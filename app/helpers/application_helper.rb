module ApplicationHelper
	def thumb(model, attribute)
		if !model.try(attribute).blank?
		  link_to image_tag(model.try(attribute).url(:thumb)),model.try(attribute).url,target: '_blank'
	  end
	end

	# def i18n_by_key(model, attribute)
	# 	if !model.try(attribute).blank?
	# 	  link_to image_tag(model.try(attribute).url(:thumb)),model.try(attribute).url,target: '_blank'
	#   end
	# end
end
