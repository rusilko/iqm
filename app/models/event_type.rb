# == Schema Information
#
# Table name: event_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class EventType < ActiveRecord::Base  
  has_many :quotes
  has_many :trainings, foreign_key: "training_type_id"
  has_many :products, through: :event_type_products
  has_many :event_type_products
  has_many :segments
  has_many :event_type_trainings
  has_many :trainings, through: :event_type_trainings
  attr_accessible :name, :description, :default_price_per_person, :default_number_of_days 
  validates :name, presence: true

  def label
    name + " (#{default_number_of_days})"
  end
end
