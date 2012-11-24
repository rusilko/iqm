class Customer < ActiveRecord::Base
  attr_accessible :name, :phone_1, :phone_2

  belongs_to  :customerable, polymorphic: true, dependent: :destroy
  has_many    :addresses, as: :addressable
  has_many    :orders, include: :order_items, dependent: :destroy
end
