class Client < User
  attr_accessible :name, :phone_1, :phone_2
  acts_as_customer
  belongs_to :company
  has_many :seats
  has_many :order_items, through: :seats

  # this is needed for as long as I figure out why find_by_name does not work at all
  def self.find_by_customer_name(name)
    client_id = Customer.find_by_name_and_customerable_type(name, "User").try(:customerable_id)
    Client.find(client_id) if client_id
  end

end
