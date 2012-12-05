class Order < ActiveRecord::Base
  STATUSES = %w(placed paid canceled)
  CUSTOMER_TYPES = %w(Client Company)
  attr_accessible :customer_id, :customer_type, :date_placed, :status, :order_items_attributes, :customer_attributes, :coordinator_id, :coordinator_attributes
  
  belongs_to :customer, polymorphic: true, autosave: true
  accepts_nested_attributes_for :customer
  #validates_associated :customer

  has_many  :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true

  belongs_to :coordinator, class_name: "Client", autosave: true
  accepts_nested_attributes_for :coordinator
  validates_associated :coordinator

  def customer_attributes=(attributes)
    self.customer = eval(self.customer_type).where(id: attributes[:customer_id]).first_or_initialize(attributes)
  end

  def build_customer(params, assignment_options={})
    c_type = params[:customer_type]
    raise "Unknown customer_type: #{c_type}" unless CUSTOMER_TYPES.include?(c_type)
    new_params = params.reject!{ |k| k == :customer_type } 
    self.customer = c_type.constantize.new(new_params)
  end

  def coordinator_attributes=(attributes)
    unless attributes[:_destroy]=="1"
      self.coordinator = Client.where(id: attributes[:coordinator_id]).first_or_initialize(attributes.except(:_destroy))
    else
      self.coordinator = nil
    end
   end

  def build_coordinator(params={}, assignment_options={})
    self.coordinator = Client.new(params)
  end

  before_validation :validating_order, only: :order_items
  def validating_order
    logger.fatal   "validating order"
  end
end
