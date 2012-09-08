class RemoveColumnTotalCostFromCostItems < ActiveRecord::Migration
  def up
    remove_column :cost_items, :total_cost
  end

  def down
    add_column :cost_items, :total_cost, :integer
  end
end
