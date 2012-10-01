class AddVatToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :vat, :string, default: "23"
  end
end
