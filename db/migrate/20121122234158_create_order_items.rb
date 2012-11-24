class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :quantity
      t.integer :order_id
      t.references :productable, polymorphic: true  

      t.timestamps
    end
    add_index :order_items, [:productable_id, :productable_type]
    add_index :order_items, :productable_id
    add_index :order_items, :order_id
  end
end
