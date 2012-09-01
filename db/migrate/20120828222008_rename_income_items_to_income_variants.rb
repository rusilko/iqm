class RenameIncomeItemsToIncomeVariants < ActiveRecord::Migration
  def change
    rename_table :income_items, :income_variants
  end
end
