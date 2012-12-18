class CreateEventTypes < ActiveRecord::Migration
  def change
    create_table :event_types do |t|
      t.string  :name
      t.text    :introduction
      t.text    :description
      t.integer :default_price_per_person, :precision => 8, :scale => 2
      t.integer :default_number_of_days

      t.timestamps
    end
    add_index :event_types, :name
  end
end
