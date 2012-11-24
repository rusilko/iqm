class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string   :name
      t.string  :phone_1
      t.string  :phone_2
      t.integer  :customerable_id
      t.string   :customerable_type
      t.timestamps
    end
    add_index :customers, :name
    add_index :customers, [:customerable_id, :customerable_type]
  end
end
