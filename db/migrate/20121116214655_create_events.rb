class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.date :date
      t.decimal :price_per_participant, :precision => 8, :scale => 2
      t.integer :event_type_id
      t.string :city

      t.timestamps
    end
    add_index :events, :name
    add_index :events, :date
    add_index :events, :city
  end
end
