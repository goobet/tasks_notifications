class CreateSmsNotifications < ActiveRecord::Migration
  def change
    create_table :sms_notifications do |t|
      t.belongs_to :task
      t.datetime :delivery_date
      t.string :sms_id, null: true
      t.integer :status, null: false, default: 0
      
      t.timestamps null: false
    end
  end
end
