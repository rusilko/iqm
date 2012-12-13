class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string  :name, null: false
      t.string  :email, null: false
      t.string  :phone_1
      t.string  :phone_2      
      t.integer :company_id
      t.string  :position
      t.boolean :confirmed
      t.timestamps
    end
    add_index :clients, :email
    add_index :clients, :name
  end
end
