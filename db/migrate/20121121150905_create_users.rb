class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email #, null: false
      t.string :password_digest #, null: false
      t.string :type #, null: false
      t.integer :company_id
      t.boolean :company_primary_contact
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
