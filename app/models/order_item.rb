class OrderItem < ActiveRecord::Base
  attr_accessible :training_id, :order_id, :quantity
  belongs_to :productable, polymorphic: true, inverse_of: :order_item
  has_many :seats
  has_many :participants, through: :seats, source: :client
end
