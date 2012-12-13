class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string  :line_1
      t.string  :postcode
      t.string  :city
      t.boolean :default_sending
      t.boolean :default_billing
      t.references :addressable, polymorphic: true  
      t.timestamps
    end
  end
end
