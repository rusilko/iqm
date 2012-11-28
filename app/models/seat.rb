class Seat < ActiveRecord::Base
  attr_accessible :client_id, :training_id, :order_item_id, :client_attributes
  validates_associated :client
  #before_validation :set_client_if_exists
  belongs_to  :client, autosave: true
  accepts_nested_attributes_for :client, reject_if: :all_blank
  
  belongs_to  :order_item

  validates :client_id, uniqueness: { scope: :training_id, :message => "cannot be added twice to the same training" }
  # validates :training_id, uniqueness: { scope: :client_id, :message  => "this client is already registered for this training" }
  def set_client_if_exists
    if new_client = Client.find_by_email(client.email)      
      self.client = new_client
    end
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
