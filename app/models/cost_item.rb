# == Schema Information
#
# Table name: cost_items
#
#  id                :integer         not null, primary key
#  quote_id          :integer
#  factor_type       :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  vat               :string(255)
#  single_cost       :decimal(8, 2)
#  cost_item_type_id :integer
#

class CostItem < ActiveRecord::Base
  
  FACTOR_TYPES = { per_day: 'daily', per_person: 'person', per_event: 'globally' }
  VAT_VALUES =  %w(zw 0 8 23)
  
  before_save   :create_new_cost_item_type
  attr_accessor :new_cost_item_type

  belongs_to :quote
  belongs_to :cost_item_type

  attr_accessible :single_cost, :factor_type, :vat, :cost_item_type_id, :new_cost_item_type

  validates :single_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :factor_type, inclusion: { in: FACTOR_TYPES.keys.map {|k| k.to_s}, message: "%{value} is not a valid factor_type" }, allow_blank: true
  validates :vat, inclusion: { in: VAT_VALUES, message: "%{value} is not a valid vat type"}, allow_blank: true
  
  default_scope :order => 'id'

  def factor_types
    FACTOR_TYPES
  end

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

  def cost_item_total_netto
    sc = single_cost || 0
    factor = case factor_type
      when "per_day"
        quote.try(:number_of_days) || 0
      when "per_person"
        quote.current_income_variant.try(:number_of_participants) || 0
      when "per_event"
        1
      else
        0
    end
    sc * factor
  end

  def cost_item_total_brutto
    cost_item_total_netto * vat_factor
  end

  def create_new_cost_item_type
    unless new_cost_item_type.blank?
      if cit = CostItemType.find_by_name(new_cost_item_type.downcase)
        self.cost_item_type = cit
      else
        create_cost_item_type(name: new_cost_item_type.downcase)
      end
    end
  end

end
