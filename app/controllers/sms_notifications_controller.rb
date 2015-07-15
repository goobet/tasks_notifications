class SmsNotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :smsru_callback
  skip_before_action :authenticate_user!,  only: :smsru_callback

  layout false

  def smsru_callback
    parsed_params = smsru_callback_params
      
    if parsed_params.empty?
      logger.error "[SMS] Received bad callback params."
      return render(text: '100')
    end

    if parsed_params[:code] == 103
      sms = SmsNotification.where(sms_id: parsed_params[:sms_id]).last
      sms.status = :delivered
      sms.save

      logger.debug("[SMS] Sms notification \##{s.id} delivered")
    else
      logger.error('[SMS] Callback return status != 103')
    end

    render text: '100'
  end

  private

  def smsru_callback_params
    begin
      permited = params.require(:data).permit('0')
      splited_params = permited['0'].split("\n")
      if splited_params[0] == 'sms_status' 
        {
          method: splited_params[0],
          sms_id: splited_params[1],
          code: splited_params[2].to_i
        }
      else
        {}
      end
    rescue ActionController::ParameterMissing  
      {}
    end
  end

end