ActiveAdmin.register Member do
  menu false
  permit_params Member.client_permit_params

  # scope_to :current_member, :association_method=>:managed_members

  

  controller do
    belongs_to :client, optional: true
    def edit
      # edit!
      # @member.clients.where(:id=>current_member.managed_clients).first
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs I18n.t(:detail) do
      f.input :name
      f.input :sex
      f.input :borded_at
      f.input :pic
      f.input :address
      f.input :email
    end

    f.actions
  end

  show do 
    attributes_table do
      row :name
      row :sex
      row :borded_at
      row :pic
      row :address
      row :email
    end
  end
end
