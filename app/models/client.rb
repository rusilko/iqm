class Client < User
  attr_accessible :name, :phone_1, :phone_2
  acts_as_customer
  belongs_to :company
  has_many :seats
  has_many :order_items, through: :seats
end
