class Task < ActiveRecord::Base
  enum status: [ :not_performed, :performed ]

  belongs_to :user

  scope :already_need_perform, -> { not_performed.where('start_date <= ?', Time.now) }

  scope :in_future, -> { not_performed.where('start_date > ?', Time.now) }
end
