class AddVatToCostItem < ActiveRecord::Migration
  def change
    add_column :cost_items, :vat, :string
  end
end
