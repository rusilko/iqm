class CreateCostItems < ActiveRecord::Migration
  def change
    create_table :cost_items do |t|
      t.integer :quote_id
      t.string :name
      t.integer :single_cost
      t.string :factor_type
      t.integer :total_cost

      t.timestamps
    end
  end
end
