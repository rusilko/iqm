class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.integer :offer_id
      t.string :name
      t.string :type
      t.integer :number_of_days

      t.timestamps
    end
  end
end
