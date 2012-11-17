class Event < ActiveRecord::Base
  belongs_to  :event_type
  has_many    :event_participations, dependent: :destroy
  has_many    :participants, through: :event_participations

  attr_accessible :city, :date, :event_type_id, :name, :price_per_participant

  validates :name, presence: true,
                   length: { within: 6..50 }
  validates :city, presence: true
  validates :date, presence: true
end
