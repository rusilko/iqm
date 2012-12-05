class Company < ActiveRecord::Base
  has_many :employees, :class_name => "Client", conditions: { type: "Client" }
  has_many :orders, as: :customer, include: :order_items, dependent: :destroy
  has_many :addresses, as: :addressable
  accepts_nested_attributes_for :addresses
  attr_accessible :name, :email, :phone_1, :phone_2, :regon, :nip, :addresses_attributes

  # validates :name, presence: true

  validates :email,   presence:    true,
                      format:      { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                      uniqueness:  { case_sensitive: false }                      

  # validates :phone_1, presence:    true,
  #                     format:      { with: /\d{9}/i, message: "Nie poprawny format, powinno byc 9 cyfr." }

  # validates :nip, :nip => true #123-456-32-18
  
  def number_of_addresses
    self.addresses.size
  end

end
