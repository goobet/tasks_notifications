class SmsNotification < ActiveRecord::Base
  enum status: [ :need_send, :canceled, :delivered, :error_on_deliver, :sent]
  belongs_to :task
  before_create :set_delivery_date
  after_create :create_job

  def phone
    task.user.phone
  end

  def message_text
    "You need perform #{task.name}"
  end

  private

  def set_delivery_date
    self.delivery_date = task.start_date
  end

  def create_job
    logger.debug("[SMS] Create job for SmsNotification\##{id} #{delivery_date}")
    SendSmsJob.set(wait_until: task.start_date).perform_later(sms_notification_id: id)
  end
end