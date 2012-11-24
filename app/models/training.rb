class Training < ActiveRecord::Base
  attr_accessible :city, :end_date, :name, :price_per_person, :start_date, :training_type_id
  has_many   :order_items, as: :productable, include: :seats
  belongs_to :training_type, class_name: "EventType", foreign_key: "event_id"
end
