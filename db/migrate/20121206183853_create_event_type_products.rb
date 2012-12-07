class CreateEventTypeProducts < ActiveRecord::Migration
  def change
    create_table :event_type_products do |t|
      t.integer :event_type_id
      t.integer :product_id

      t.timestamps
    end
  end
end
