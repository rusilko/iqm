class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line_1
      t.string :line_2
      t.string :city
      t.string :postcode
      t.string :country
      t.boolean :default_sending
      t.boolean :default_billing
      t.string :other_details
      t.references :addressable, polymorphic: true  
      t.timestamps
    end
  end
end
