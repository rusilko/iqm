# == Schema Information
#
# Table name: offers
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Offer < ActiveRecord::Base
  has_many :quotes, :dependent => :destroy
  accepts_nested_attributes_for :quotes, allow_destroy: true

  attr_accessible :name, :quotes_attributes

  validates :name,  presence: true,
                    length: { within: 3..50 }


end
