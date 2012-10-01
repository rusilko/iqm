class ChangeColumnPricePerParticipatnInIncomeVariants < ActiveRecord::Migration
  def up
    remove_column :income_variants, :price_per_participant
    add_column :income_variants, :price_per_participant, :decimal, :precision => 8, :scale => 2
  end

  def down
    remove_column :income_variants, :price_per_participant
    add_column :income_variants, :price_per_participant, :integer
  end
end
