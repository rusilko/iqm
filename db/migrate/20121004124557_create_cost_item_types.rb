class CreateCostItemTypes < ActiveRecord::Migration
  def change
    create_table :cost_item_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
