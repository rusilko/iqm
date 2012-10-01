class ChangeColumnSingleCostInCostItems < ActiveRecord::Migration
  def up
    remove_column :cost_items, :single_cost
    add_column :cost_items, :single_cost, :decimal, :precision => 8, :scale => 2
  end

  def down
    remove_column :cost_items, :single_cost
    add_column :cost_items, :single_cost, :integer
  end
end