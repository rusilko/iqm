class Client < User
  attr_accessible :name, :email, :phone_1, :phone_2, 
                  :nip, :regon, :company_id, :company_primary_contact, 
                  :addresses_attributes

  has_many :orders, as: :customer, include: :order_items, dependent: :destroy
  has_many :coordinated_orders, class_name: "Order", foreign_key: :coordinator_id

  has_many :seats
  has_many :order_items, through: :seats

  has_many :addresses, as: :addressable
  accepts_nested_attributes_for :addresses

  belongs_to :company

  before_validation :strip_phone_number, only: :phone_1

  validates :name,    presence:    true, 
                      length:      { within: 3..50}

  validates :email,   presence:    true,
                      format:      { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                      uniqueness:  { case_sensitive: false }                      

  validates :phone_1, presence:    true,
                      format:      { with: /\d{9}/i, message: "Nie poprawny format, powinno byc 9 cyfr." } 

  def number_of_addresses
    self.addresses.size
  end

  private

  def strip_phone_number
    self.phone_1 = self.phone_1.gsub(/\s+/, "")  
  end

end
