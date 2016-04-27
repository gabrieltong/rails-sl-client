class Dayu < ActiveRecord::Base
  belongs_to :dayuable, :polymorphic=>true

  scope :findByDayuable, -> (obj) { where(:dayuable_type => obj.class.name, :dayuable_id => obj.id) }

  serialize :smsParam

  scope :sended, ->{where(:sended=>true)}
  scope :not_sended, ->{where.not(:sended=>true)}

  def self.createByDayuable(dayuable, config)
    dayu = self.new
    dayu.smsType = config['smsType']
    dayu.smsFreeSignName = config['smsFreeSignName']
    dayu.smsParam = config['smsParam']
    dayu.recNum = config['recNum']
    dayu.smsTemplateCode = config['smsTemplateCode']
    dayu.dayuable = dayuable
    dayu.appkey = 123
    dayu.sended_at = '0000-00-00 00:00:00'
    dayu.save
    dayu
  end

  def self.table_name
    :gabe_dayus
  end

  def run
    bigfish = Alibaba::Bigfish.new(23265315,'a01020d3de3b53fc9cd86ed51d8bb981')

    params = {
        rec_num: recNum , 
        sms_type: smsType, 
        sms_free_sign_name: smsFreeSignName, 
        sms_template_code: smsTemplateCode, 
        sms_param: smsParam
    }

    result = bigfish.send_sms params
    self.result = result
    
    begin
      if JSON.parse(result).values[0]['result']['success'] == true
        self.sended_at = DateTime.now
        self.sended = true
      end
    rescue
    end

    self.save
  end

  def self.allow_send obj
    if obj.dayus.order('sended_at desc').first
      return (obj.dayus.order('sended_at desc').first.sended_at - DateTime.now).abs > 60
    else
      return true
    end
  end

  private
  def run2
    `
    php #{LaPath} dayu:send #{self.id}
    `
  end     
end