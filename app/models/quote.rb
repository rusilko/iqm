# == Schema Information
#
# Table name: quotes
#
#  id             :integer         not null, primary key
#  offer_id       :integer
#  name           :string(255)
#  event_type     :string(255)
#  number_of_days :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class Quote < ActiveRecord::Base
  belongs_to  :offer
  has_many    :income_variants,  dependent: :destroy
  has_many    :cost_items,    dependent: :destroy
  accepts_nested_attributes_for :income_variants, allow_destroy: true
  accepts_nested_attributes_for :cost_items, allow_destroy: true

  attr_accessible :name, :number_of_days, :event_type, :income_variants_attributes, :cost_items_attributes

  validates :name, presence: true,
                   length:   { within: 3..15 }

  validates :number_of_days, numericality: { greater_than: 0, less_than: 11},
                             allow_nil:    true

  validates :offer_id, presence: true

   default_scope order: 'id'
end 
