class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name, null: false, default: ""
      t.text :description, null: false, default: ""
      t.integer :status, null: false, default: 0
      t.datetime :repeat_interval
      t.integer :repeat_count, null: false, default: 1
      t.datetime :start_date, null: false
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
