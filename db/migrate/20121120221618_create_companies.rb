class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :email
      t.string :phone_1
      t.string :phone_2
      t.string :nip
      t.string :regon
      t.boolean :confirmed
      t.timestamps
    end
    add_index :companies, :email
    add_index :companies, :name
  end
end
