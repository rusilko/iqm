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
  before_save :falsify_all_others, if: :currently_chosen

  attr_accessible :number_of_participants, :price_per_participant, :currently_chosen

  validates :number_of_participants, numericality: { greater_than: 0 },
                                     allow_blank: true
  validates :price_per_participant,  numericality: { greater_than_or_equal_to: 0 }, 
                                     allow_blank: true

  # validation below is not needed as we are running a before_save callback to falsify other ivs
  # validates :currently_chosen, uniqueness: { scope: :quote_id }, if: :currently_chosen

  default_scope :order => 'id'

  def total_income
    (number_of_participants || 0) * (price_per_participant || 0)
  end

  protected
  # when trying to set currently_chosen attribute to true, 
  # we need to set false to every other iv belonging to the same quote
  # TODO - try to find a way to do it without a where clause.
  def falsify_all_others
    IncomeVariant.where("id != ? AND quote_id = ? AND currently_chosen = 'true'", id, quote_id).
                  update_all("currently_chosen = 'false'") 
  end
end
