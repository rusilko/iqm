class Order < ActiveRecord::Base
  STATUSES = %w(placed paid canceled)
  CUSTOMER_TYPES = %w(Client Company)
  attr_accessible :customer_id, :customer_type, :date_placed, :status, :order_items_attributes, :customer_attributes, :coordinator_id, :coordinator_attributes
  

  belongs_to :customer, polymorphic: true, autosave: true
  accepts_nested_attributes_for :customer

  has_many  :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true

  belongs_to :coordinator, class_name: "Client", autosave: true
  accepts_nested_attributes_for :coordinator
  validates_associated :coordinator

  # def attributes=(attributes)
  #   self.customer_type = attributes[:customer_type]
  #   binding.pry 
  #   super
  # end

  def customer_attributes=(attributes)
    #self.customer_type = attributes[:customer_type]
    #self.customer = eval(attributes.delete(:customer_type)).where(id: attributes[:customer_id]).first_or_initialize(attributes) if self.valid?
    #binding.pry
    self.customer = eval(self.customer_type).where(id: attributes[:customer_id]).first_or_initialize(attributes) if self.valid?
  end

  def build_customer(params, assignment_options={})
    c_type = params[:customer_type]
    raise "Unknown customer_type: #{c_type}" unless CUSTOMER_TYPES.include?(c_type)
    new_params = params.reject!{ |k| k == :customer_type } 
    self.customer = c_type.constantize.new(new_params)
  end

  def coordinator_attributes=(attributes)
    unless attributes[:_destroy]=="1"
      self.coordinator = Client.where(id: attributes[:coordinator_id]).first_or_initialize(attributes.except(:_destroy))  #if self.valid?
    else
      self.coordinator = nil
    end
   end

  def build_coordinator(params={}, assignment_options={})
    self.coordinator = Client.new(params)
  end

  # def autosave_associated_records_for_customer
  #   c_type = self.customer_type.constantize
  #   if new_customer = c_type.find_by_email(client.email)      
  #     self.client = new_customer
  #   else
  #     #not quite sure why I need the part before the if, but somehow seat is losing its client_id value
  #     self.client = client if self.client.save!
  #   end
  # end
end
