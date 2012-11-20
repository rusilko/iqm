class EventParticipation < ActiveRecord::Base
  attr_accessible :event_id, :participant_id, :participant_attributes
  belongs_to  :event
  belongs_to  :participant
  accepts_nested_attributes_for :participant, :reject_if => :check_if_exists

  validates :event_id, presence: true
  #validates :participant_id, presence: true

  protected

    def check_if_exists(attributes)
      return true if attributes['email'].blank? && attributes['name'].blank?

      ev = attributes['associated_event_id']
      pt = attributes['id']
      unless EventParticipation.find_by_event_id_and_participant_id(ev,pt)
        p = Participant.find_by_email(attributes['email'])
        if p  
          ep = EventParticipation.new(event_id: attributes['associated_event_id'], participant_id: p.id)
          ep.save 
          return true
        end
        return false
      end
      return false
    end

end
