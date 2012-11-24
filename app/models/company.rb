class Company < ActiveRecord::Base
  acts_as_customer
  has_many :employees, :class_name => "Client", conditions: { type: "Client" }
  attr_accessible :regon, :nip, :name, :phone_1, :phone_2
end
