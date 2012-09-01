# == Schema Information
#
# Table name: income_variants
#
#  id                     :integer         not null, primary key
#  quote_id               :integer
#  number_of_participants :integer
#  price_per_participant  :integer
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  currently_chosen       :boolean
#

class IncomeVariant < ActiveRecord::Base
  belongs_to :quote

  attr_accessible :number_of_participants, :price_per_participant, :currently_chosen

  validates :number_of_participants, numericality: { greater_than: 0, }, allow_blank: true
  validates :price_per_participant,  numericality: { greater_than_or_equal_to: 0, }, allow_blank: true
  #validates :quote_id, presence: true

  default_scope :order => 'id'
end
