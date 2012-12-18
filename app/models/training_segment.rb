class TrainingSegment < ActiveRecord::Base
  belongs_to :segment
  belongs_to :training
  attr_accessible :number_of_hours, :scenario, :segment_id, :start_time, :training_id, :lineup
  default_scope include: :training, order: 'lineup ASC'
end
