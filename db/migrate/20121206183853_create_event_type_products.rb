class CreateEventTypeProducts < ActiveRecord::Migration
  def change
    create_table :event_type_products do |t|
      t.integer :event_type_id
      t.integer :product_id

      t.timestamps
    end
    add_index :event_type_products, :event_type_id
    add_index :event_type_products, :product_id
    add_index :event_type_products, [:event_type_id, :product_id], unique: true
  end
end
