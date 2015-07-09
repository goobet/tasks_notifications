class Task < ActiveRecord::Base
  enum status: [ :not_performed, :performed ]

  belongs_to :user

  scope :already_need_perform, -> { not_performed.where('start_date <= ?', Time.now) }

  scope :in_future, -> { not_performed.where('start_date > ?', Time.now) }

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
end


