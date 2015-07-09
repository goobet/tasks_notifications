class SplitTaskRepeatInterval < ActiveRecord::Migration
  def up
    remove_column :tasks, :repeat_interval
    change_table :tasks do |t|
      t.integer :every_minutes, default: 0
      t.integer :every_hours, default: 0
      t.integer :every_days, default: 0
      t.integer :every_months, default: 0
      t.integer :every_years, default: 0
    end
  end

  def down
    remove_columns :tasks, :every_minutes, :every_hours, :every_days, :every_months, :every_years
    add_column :tasks, :repeat_interval, :datetime
  end
end