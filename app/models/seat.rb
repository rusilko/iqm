class Seat < ActiveRecord::Base
  attr_accessible :client_id, :order_item_id
  belongs_to  :client
  belongs_to  :order_item, inverse_of: :seat
end
