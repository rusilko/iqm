class Seat < ActiveRecord::Base
  attr_accessor :double_client_error  
  
  belongs_to  :client, autosave: true
  belongs_to  :order_item

  accepts_nested_attributes_for :client
   
  before_validation :set_client_if_exists
  before_validation :check_for_double_errors, only: :client

  attr_accessible :client_id, :training_id, :order_item_id, :client_attributes

  validates :client_id, uniqueness: { scope: :training_id, :message => "Client cannot be added to the same training twice." }  

  def set_client_if_exists
    self.client = Client.where(email: self.client.email).first_or_initialize do |c|
      c.name    = client.name
      c.email   = client.email
      c.phone_1 = client.phone_1
    end
    logger.fatal "checking client in seat"
  end

  def check_for_double_errors
    self.client.double_error = self.double_client_error
    logger.fatal "validating seat"
  end

  def autosave_associated_records_for_client
    if new_client = Client.find_by_email(client.email)      
      self.client = new_client
    else
      #not quite sure why I need the part before the if, but somehow seat is losing its client_id value
      self.client = client if self.client.save!
    end
  end

end