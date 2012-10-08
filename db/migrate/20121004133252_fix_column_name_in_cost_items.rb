class FixColumnNameInCostItems < ActiveRecord::Migration
  def up
    remove_column :cost_items, :name
    add_column    :cost_items, :cost_item_type_id, :integer
  end

  def down
    remove_column :cost_items, :cost_item_type_id
    add_column    :cost_items, :name, :string
  end
end
