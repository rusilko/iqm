class Segment < ActiveRecord::Base
  belongs_to :event_type
  has_many   :training_segments
  has_many   :trainings, through: :training_segments
  attr_accessible :event_type_id, :number_of_hours, :name, :scenario, :default_lineup
  #default_scope include: :event_type, order: 'event_types.id, default_lineup'

  validates :name, presence: true
end
