class Training < ActiveRecord::Base
  attr_accessible :city, :end_date, :name, :price_per_person, :start_date, :training_type_id
  has_many   :order_items, as: :productable, include: :seats
  belongs_to :training_type, class_name: "EventType"
  has_many   :associated_products, source: :products, through: :training_type

  def book
    associated_products.first if self.has_book?
  end

  def has_book?
    !associated_products.empty?
  end

  def price
    self.price_per_person
  end
end
