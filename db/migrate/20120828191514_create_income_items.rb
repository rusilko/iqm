class CreateIncomeItems < ActiveRecord::Migration
  def change
    create_table :income_items do |t|
      t.integer :quote_id
      t.integer :number_of_participants
      t.integer :price_per_participant

      t.timestamps
    end
  end
end
