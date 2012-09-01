class AddColumnToIncomeVariants < ActiveRecord::Migration
  def change
    add_column :income_variants, :currently_chosen, :boolean
  end
end
