class CreateEventsTable < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.time :time
      t.string :location

      t.timestamps
    end
  end
end
