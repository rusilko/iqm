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
  attr_accessible :name
  has_many :quotes

  validates :name, presence: true
end
