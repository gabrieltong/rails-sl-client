class User < ActiveRecord::Base
  include Clearance::User

  has_many :client_users
  has_many :clients, :through=>:client_users
  validates :phone, presence: true, :uniqueness=>true
  def self.permit_params
  	[:password, :phone]
  end

  def email_optional?
  	true
  end

  def self.authenticate(phone, password)
    return nil  unless user = find_by_phone(phone)
    return user if     user.authenticated?(password)
  end
end
