# == Schema Information
#
# Table name: trainings
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  start_date       :date
#  end_date         :date
#  city             :string(255)
#  price_per_person :integer
#  training_type_id :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class Training < ActiveRecord::Base
  belongs_to :training_type, class_name: "EventType"

  has_many   :order_items, as: :productable, include: :seats
  has_many   :associated_products, source: :products, through: :training_type

  attr_accessible :city, :end_date, :name, :price_per_person, :start_date, :training_type_id

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
