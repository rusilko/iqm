class RenameColumnTypeInQuotes < ActiveRecord::Migration
  def change
    rename_column :quotes, :type, :event_type
  end
end
