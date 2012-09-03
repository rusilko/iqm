# == Schema Information
#
# Table name: cost_items
#
#  id          :integer         not null, primary key
#  quote_id    :integer
#  name        :string(255)
#  single_cost :integer
#  factor_type :string(255)
#  total_cost  :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class CostItem < ActiveRecord::Base
  FACTOR_TYPES = %w(per_day per_person per_event)
  
  attr_accessor :factor_types

  belongs_to :quote

  attr_accessible :name, :single_cost, :factor_type

  #validates :name, presence: true
  validates :single_cost, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :factor_type, inclusion: { in: FACTOR_TYPES, message: "%{value} is not a valid factor_type" }, allow_blank: true
  #validates :quote_id, presence: true

  default_scope :order => 'id'

  def factor_types
    FACTOR_TYPES
  end

end
