module AddressableMixin
  def self.included(base)
    base.instance_eval { has_many :addresses, :as => :addressable }
  end

  def number_of_addresses
    self.addresses.size
  end  

  def billing_address
    self.addresses.billing.first || self.addresses.select { |a| a.default_billing }.first
  end

  def sending_address
    self.addresses.sending.first || self.addresses.select { |a| a.default_sending }.first
  end
  
end