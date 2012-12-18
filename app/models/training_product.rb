class TrainingProduct < ActiveRecord::Base
  belongs_to :training
  belongs_to :product
  attr_accessible :product_id, :training_id
end
