class AddDefaultValueToCurrentlyChosenAttribute < ActiveRecord::Migration
  def change
    change_column :income_variants, :currently_chosen, :boolean, :default => false
  end
end
