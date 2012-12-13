# == Schema Information
#
# Table name: companies
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  phone_1    :string(255)
#  phone_2    :string(255)
#  nip        :string(255)
#  regon      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Company < ActiveRecord::Base


  has_many :employees, :class_name => "Client", conditions: { type: "Client" }
  has_many :orders, as: :customer, include: :order_items
  include AddressableMixin
  
  accepts_nested_attributes_for :addresses
  
  attr_accessible :name, :email, :phone_1, :phone_2, :regon, :nip, :confirmed, :addresses_attributes

  validates :name,    presence:    true

  validates :email,   presence:    true,
                      format:      { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                      uniqueness:  { scope: :confirmed, :if => Proc.new{ |company| company.confirmed }, case_sensitive: false }                      

  validates :phone_1, presence:    true,
                      format:      { with: /\d{9}/i }

  validates :nip,     nip:         true #123-456-32-18
end
