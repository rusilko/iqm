class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string  :status
      t.date    :date_placed
      t.integer :customer_id

      t.timestamps
    end
    add_index :orders, :status
    add_index :orders, :date_placed
    add_index :orders, :customer_id
  end
end
