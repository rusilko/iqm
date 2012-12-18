class EventTypeTraining < ActiveRecord::Base
  belongs_to :event_type
  belongs_to :training
  attr_accessible :event_type_id, :training_id
end
