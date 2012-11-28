class Company < ActiveRecord::Base
  has_many :employees, :class_name => "Client", conditions: { type: "Client" }
  has_many :orders, as: :customer, include: :order_items, dependent: :destroy
  has_many :addresses, as: :addressable
  accepts_nested_attributes_for :addresses
  attr_accessible :name, :email, :phone_1, :phone_2, :regon, :nip, :addresses_attributes

  validates :name, presence: true

end
