class Participant < ActiveRecord::Base
  has_many    :event_participations, dependent: :destroy
  has_many    :events, through: :event_participations
  attr_accessible :email, :name, :associated_event_id
  attr_accessor :associated_event_id

  validates :name,  presence: true,
                    length: { within: 5..100 }

  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:    true,
                    format:      { with: valid_email_regex },
                    uniqueness:  { case_sensitive: false }

  def register_for_event!(event)
    self.event_participations.create!(event_id: event.id)
  end

  def unregister_from_event!(event)
    self.event_participations.find_by_event_id(event.id).destroy
  end

end
