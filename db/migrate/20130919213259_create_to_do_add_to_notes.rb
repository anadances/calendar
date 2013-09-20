class CreateToDoAddToNotes < ActiveRecord::Migration
  def change
    create_table :to_dos do |t|
      t.string :name

      t.timestamps
    end
    add_column :notes, :notable_id, :integer
    add_column :notes, :notable_type, :string
  end
end
