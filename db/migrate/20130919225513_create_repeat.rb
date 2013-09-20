class CreateRepeat < ActiveRecord::Migration
  def change
    create_table :repeats do |t|
      t.integer :event_id
      t.integer :day_of_month
      t.string :weekday
      t.boolean :daily

      t.timestamps
    end
  end
end
