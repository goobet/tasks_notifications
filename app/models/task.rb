class Task < ActiveRecord::Base
  enum status: [ :not_performed, :performed ]
  belongs_to :user, dependent: :destroy
  has_one :sms_notification
  
  after_initialize :set_default_start_date

  scope :already_need_perform, -> { not_performed.where('start_date <= ?', Time.now) }

  scope :in_future, -> { not_performed.where('start_date > ?', Time.now) }

  before_update :update_sms_notification

  def mark_as_performed
    return self.status = :performed if repeat_count == 0
    
    self.repeat_count -= 1
    self.start_date = next_start_date
  end

  def save_as_performed
    mark_as_performed
    save
  end

  def next_start_date
    start_date + every_minutes.minutes + every_hours.hours + every_days.days + every_months.months + every_years.years
  end

  def repeating
    every_attributes = attributes.select {|k, v| (k =~ /^every/) && (v > 0)}

    every_attributes.empty? ? I18n.t("tasks.repeating.none") : repeating_text(every_attributes)
  end

  def repeatable?
    repeat_count > 0
  end

  def notify_by_sms
    sms_notification.present?
  end

  def sms_delivered?
    sms_notification.delivered?
  end

  private

  def set_default_start_date
    start_date ||= Time.now
  end

  def repeating_text(attributes)
    attributes_as_string = attributes.map { |k,v| "#{v} #{I18n.t(k, scope:'tasks.form')}"}.join(', ')
    "#{I18n.t('tasks.repeating.every')} #{attributes_as_string}"
  end

  def update_sms_notification
    if sms_notification.present? && sms_notification.delivery_date != start_date
      sms_notification.delete
      create_sms_notification 
    end
  end
end