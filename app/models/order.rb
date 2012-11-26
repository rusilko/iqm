class Order < ActiveRecord::Base
  STATUSES = %w(placed paid canceled)
  attr_accessible :customer_id, :date_placed, :status, :order_items_attributes, :customer_attributes
  belongs_to :customer
  accepts_nested_attributes_for :customer
  has_many  :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true
end
