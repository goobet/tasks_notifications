class SendSmsJob < ActiveJob::Base
  queue_as :default

  def perform(**args)
    begin
      sms = SmsNotification.find(args[:sms_notification_id])
    rescue ActiveRecord::RecordNotFound
      return
    end

    phone = sms.phone
    text = sms.message_text
    result = send_message(phone, text)
    if result.is_a? String
      sms_id = result
      sms.update(sms_id: sms_id, status: :sent)
      logger.debug "[SMS] Sent sms notification for #{phone}, notification_id: #{sms.id}, delivery_date: #{sms.delivery_date}, sms_id: #{sms_id}"
    else
      sms.update(status: :error_on_deliver)
      logger.error "[SMS] Error on send sms notification for #{phone}, notification_id: #{sms.id}, delivery_date: #{sms.delivery_date}, result_code: #{result}"
    end
  end

  private

  def send_message(phone, text)
    api_id = Rails.application.secrets.smsru['api_id']
    if api_id.blank?
      logger.error "WARN smsru.api_id does not set in secrets! Sms does not sent"
      return nil
    end

    params = {
      api_id: api_id, 
      to: phone,
      text: text
    }

    uri = URI App.smsru_send_url
    res = Net::HTTP.post_form(uri, params)
    if res.code == 200
      splited_res = res.body.split("\n")
      code = splited_res[0].to_i
      if code == 100
        sms_id = splited_res[1]
      else
        code
      end
    else
      0
    end
  end

end
