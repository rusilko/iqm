class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :email
      t.string :phone_1
      t.string :phone_2
      t.string :nip
      t.string :regon
      t.timestamps
    end
  end
end
