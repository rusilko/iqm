class FixColumnEventTypeInQuotes < ActiveRecord::Migration
  def up
    remove_column :quotes, :event_type
    add_column    :quotes, :event_type_id, :integer
  end

  def down
    remove_column :quotes, :event_type_id
    add_column    :quotes, :event_type, :string
  end
end
