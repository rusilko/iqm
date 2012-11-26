class CreateSeats < ActiveRecord::Migration
  def change
    create_table :seats do |t|
      t.integer :client_id
      t.integer :order_item_id
      t.integer :training_id
      t.timestamps
    end
    add_index :seats, :client_id
    add_index :seats, :order_item_id
    add_index :seats, [:client_id, :order_item_id], unique: true
    add_index :seats, [:client_id, :training_id], unique: true
  end
end
