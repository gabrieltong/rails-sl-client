class Capcha < ActiveRecord::Base
	Validity = 60 * 10
	acts_as_paranoid

	scope :not_expired, ->{where(arel_table[:expired_at].gteq(DateTime.now))}
  scope :by_phone, ->(phone){where(:phone=>phone)}
  scope :by_type, ->(type){where(:type=>type)}
  scope :by_client, ->(client_id){where(:client_id=>client_id)}

	def self.allow_create obj, type
    record = obj.capchas.by_type(type).order('id desc').first
    if record
      return (record.created_at - DateTime.now).abs > Validity.seconds
    else
      return true
    end
  end

  def self.create_instance client_id, phone, type
    not_expired.by_client(client_id).by_type(type).by_phone(phone).destroy_all
    by_client(client_id).by_type(type).by_phone(phone).create! :expired_at=>DateTime.now+Validity.seconds, :code=>rand(100000..999999)
  end

  def self.inheritance_column
    nil
  end

  def self.validate_check_cards client_id, phone, card_tpl_id, number
    card_tpl = CardTpl.find(card_tpl_id)
    capcha = self.create_instance client_id, phone, __callee__

    config = {
      'type'=>__callee__,
      'smsType'=>'normal',
      'smsFreeSignName'=>'红券',
      'smsParam'=>{code: capcha.code.to_s, cardname: card_tpl.try(:title), cardnumber: number.to_s},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_8560750'
    }
  
    dy = Dayu.createByDayuable(card_tpl, config)
    dy.run
    dy.sended
  end

  def self.validate_group client_id, phone
  	client = Client.find(client_id)
    capcha = self.create_instance client_id, phone, __callee__

    config = {
      'type'=>__callee__,
      'smsType'=>'normal',
      'smsFreeSignName'=>'红券',
      'smsParam'=>{code: capcha.code.to_s, brand: client.try(:brand)},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_8480487'
    }
  
    dy = Dayu.createByDayuable(Member.find_by_phone(phone), config)
    dy.run
    dy.sended
  end

  def self.validate_spend_money client_id, phone, money
  	client = Client.find(client_id)
    capcha = self.create_instance client_id, phone, __callee__

    config = {
      'type'=>__callee__,
      'smsType'=>'normal',
      'smsFreeSignName'=>'红券',
      'smsParam'=>{code: capcha.code.to_s, brand: client.try(:title), consumptionamount: money.to_s},
      'recNum'=>phone,
      'smsTemplateCode'=>'SMS_8515444'
    }
  
    dy = Dayu.createByDayuable(Member.find_by_phone(phone), config)
    dy.run
    dy.sended
  end

  def send_capcha_bind_wechat
  end
  def send_capcha_update_password
  end

  def self.send_capcha_recover_password client_id, phone
    member = Member.find_by_phone(phone)
    if member
      capcha = self.create_instance client_id, phone, __callee__

      config = {
        'type'=>__callee__,
        'smsType'=>'normal',
        'smsFreeSignName'=>'红券',
        'smsParam'=>{code: capcha.code.to_s, phonenumber: phone.to_s },
        'recNum'=>phone,
        'smsTemplateCode'=>'SMS_8510408'
      }
    
      dy = Dayu.createByDayuable(Member.find_by_phone(phone), config)
      dy.run
      dy.sended
    else
      :no_member
    end
  end

  def self.send_capcha_bind_phone phone
    if phone.to_s.match ChinaPhoneValidator::REGEX
      member = Member.find_by_phone(phone)
      if member.nil?
        member = Member.new(:phone=>phone)
        member.password = rand(10000000..99999999)
        member.save
      end

      capcha = self.create_instance nil, phone, __callee__

      config = {
        'type'=>__callee__,
        'smsType'=>'normal',
        'smsFreeSignName'=>'红券',
        'smsParam'=>{code: capcha.code.to_s, product: "红卷" },
        'recNum'=>phone,
        'smsTemplateCode'=>'SMS_2100912'
      }
    
      dy = Dayu.createByDayuable(Member.find_by_phone(phone), config)
      dy.run
      dy.sended
    else
      :phone_is_invalid
    end
  end

  
  def send_capcha_validate_user
  end

  def self.valid_code(client_id, phone, type, code)
  	instance = not_expired.by_client(client_id).by_phone(phone).by_type(type).order('id desc').first
  	if instance and instance.code == code
  		true
  	else
  		false
  	end
  end
  
end