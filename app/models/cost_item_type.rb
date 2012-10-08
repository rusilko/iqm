# == Schema Information
#
# Table name: cost_item_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class CostItemType < ActiveRecord::Base
  attr_accessible :name
  has_many :cost_items

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }

  default_scope :order => 'id'
end
