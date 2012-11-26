class Seat < ActiveRecord::Base
  attr_accessible :client_id, :training_id, :order_item_id, :client_attributes
  validates_associated :client
  #before_save :copy_training_id_from_order_item
  before_validation :avs
  belongs_to  :client, autosave: true
  accepts_nested_attributes_for :client
  
  belongs_to  :order_item

  validates :client_id, uniqueness: { scope: :training_id, :message => "cannot be added twice to the same training" }
  # validates :training_id, uniqueness: { scope: :client_id, :message  => "this client is already registered for this training" }
  def avs
    if new_client = Client.find_by_email(client.email)      
      self.client = new_client
    end
    # binding.pry
  end
  
  def copy_training_id_from_order_item
    self.training_id = self.order_item.productable_id
  end

  def autosave_associated_records_for_client
    # Find or create the client by email
    # if customer = Customer.find_by_name_and_customerable_type(client.email, "User")      
    #   c_id = customer.customerable_id
    #   self.client = Client.find(c_id)
    if new_client = Client.find_by_email(client.email)      
      self.client = new_client
    else
      #not quite sure why I need the part before the if, but somehow seat is losing its client_id value
      self.client = client if self.client.save!
    end
  end

end
