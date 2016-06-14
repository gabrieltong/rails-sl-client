ActiveAdmin.register Import do
  menu false
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  scope_to :current_client, :association_method=>:imports

  permit_params :file, :group_id
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
  controller do
    def create
      super do |format|
        if resource.valid?
          resource.run
          redirect_to client_members_path
          return
        end
      end
    end
  end

  form do |f|
    f.inputs I18n.t(:detail) do
      f.input :group, :collection=>resource.client.groups
      f.input :file, :hint=>(link_to 'sample.xlsx', '/import-members-sample.xlsx')
    end
    actions
  end
end
