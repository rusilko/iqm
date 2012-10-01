class AddColumnEventDateToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :event_date, :date
  end
end
