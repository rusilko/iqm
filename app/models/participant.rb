class Participant < ActiveRecord::Base
  has_many    :event_participations, dependent: :destroy
  has_many    :events, through: :event_participations
  attr_accessible :email, :name

  validates :name,  presence: true,
                    length: { within: 5..50 }

  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:    true,
                    format:      { with: valid_email_regex },
                    uniqueness:  { case_sensitive: false }                 
end
