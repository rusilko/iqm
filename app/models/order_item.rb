class OrderItem < ActiveRecord::Base
  attr_accessible :quantity, :productable_id, :productable_type, :order_attributes, :seats_attributes
  validates_associated :seats
  belongs_to :productable, polymorphic: true, inverse_of: :order_item
  
  belongs_to :order
  accepts_nested_attributes_for :order

  has_many :seats, dependent: :destroy
  accepts_nested_attributes_for :seats, allow_destroy: true

  has_many :clients, autosave: true, through: :seats

  # def autosave_associated_records_for_clients
  #   # Find or create the client by name
  #   existing_clients = []
  #   new_clients = []
  #   binding.pry
  #   clients.each do |client|
  #     if customer = Customer.find_by_name_and_customerable_type(client.name, "User")      
  #       existing_clients << Client.find(customer.customerable_id)
  #       binding.pry
  #     else
  #       new_clients << client
  #       binding.pry
  #     end
  #   end
  #   self.clients << new_clients + existing_clients
  # end

end
