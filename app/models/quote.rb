# == Schema Information
#
# Table name: quotes
#
#  id             :integer         not null, primary key
#  offer_id       :integer
#  name           :string(255)
#  number_of_days :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  event_date     :date
#  vat            :string(255)     default("23")
#  event_type_id  :integer
#

class Quote < ActiveRecord::Base
  VAT_VALUES = %w(zw 23)

  belongs_to  :offer
  belongs_to  :event_type
  has_many    :income_variants, dependent: :destroy
  has_many    :cost_items, dependent: :destroy
  accepts_nested_attributes_for :income_variants, allow_destroy: true
  accepts_nested_attributes_for :cost_items, allow_destroy: true

  attr_accessible :name, :event_type_id, :number_of_days, :income_variants_attributes, :cost_items_attributes, :event_date, :vat

  validates :number_of_days, numericality: { greater_than: 0 }, allow_blank: true
  validates :vat, inclusion: { in: VAT_VALUES, message: "%{value} is not a valid vat type"}, allow_blank: true

  # This validation should not be commented out, 
  # but it doesn't work with accepts_nested_attributes_for - I need to figure out why
  # validates :offer_id, presence: true

  default_scope order: 'id'

  def vat_values
    VAT_VALUES
  end

  def vat_factor
    case vat
      when "zw"
        1
      else
        1 + vat.to_f/100
    end
  end

  def total_cost
    self.cost_items.map { |n| n.cost_item_total_netto }.inject(0) { |acc,n| acc+n }
  end

  def total_cost_brutto
    self.cost_items.map { |n| n.cost_item_total_brutto }.inject(0) { |acc,n| acc+n }
  end

  def total_income
    self.current_income_variant.try(:total_income) || 0
  end  

  def total_income_brutto
    total_income * vat_factor
  end

  def current_income_variant
    self.income_variants.find_by_currently_chosen(true)
  end
  
end 
