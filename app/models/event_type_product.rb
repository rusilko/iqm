class EventTypeProduct < ActiveRecord::Base
  attr_accessible :event_type_id, :product_id
  belongs_to :event_type
  belongs_to :product
end
