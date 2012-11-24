class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :nip
      t.string :regon
      t.timestamps
    end
  end
end
