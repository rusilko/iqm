class EventParticipation < ActiveRecord::Base
  attr_accessible :event_id, :participant_id
  belongs_to  :event
  belongs_to  :participant

  validates :event_id, presence: true
  validates :participant_id, presence: true
end
