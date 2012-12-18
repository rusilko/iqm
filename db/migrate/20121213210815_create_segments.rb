class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.string :name
      t.integer :number_of_hours
      t.text :scenario
      t.integer :event_type_id
      t.integer :default_lineup
      t.timestamps
    end
    add_index :segments, :event_type_id
  end
end
