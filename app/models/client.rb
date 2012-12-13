# encoding: utf-8 
# == Schema Information
#
# Table name: users
#
#  id                      :integer         not null, primary key
#  name                    :string(255)
#  phone_1                 :string(255)
#  phone_2                 :string(255)
#  nip                     :string(255)
#  regon                   :string(255)
#  email                   :string(255)
#  password_digest         :string(255)
#  type                    :string(255)
#  company_id              :integer
#  company_primary_contact :boolean
#  position                :string(255)
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#

class Client < ActiveRecord::Base
  attr_accessor :double_error, :nip
  
  belongs_to :company

  has_many :orders, as: :customer, include: :order_items
  has_many :coordinated_orders, class_name: "Order", foreign_key: :coordinator_id
  has_many :seats
  has_many :order_items, through: :seats
  include AddressableMixin

  accepts_nested_attributes_for :addresses

  before_validation :check_for_double_errors, only: :email
  before_validation :strip_phone_number, only: :phone_1

  attr_accessible :name, :email, :phone_1, :phone_2, :confirmed,
                  :company_id, :addresses_attributes, :position, :nip

  validates :name,    presence:    true, 
                      length:      { within: 5..50},
                      format:      { with: /[a-zA-ząęćżźśńłó]+\s+[a-zA-Ząęćżźśńłó]+/i }


  validates :email,   presence:    true,
                      format:      { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                      uniqueness:  { scope: :confirmed, :if => Proc.new{ |client| client.confirmed }, case_sensitive: false }                      

  validates :phone_1, presence:    true,
                      format:      { with: /^\d{9}$/i } 

  private

  def strip_phone_number
    self.phone_1 = self.phone_1.gsub(/\s+/, "") if self.phone_1
  end

  def check_for_double_errors
    message = case double_error
      when :same_form
      "Taki uczesnitk jest już na liście."
      when :same_training
      "Taki uczestnik jest już zapisany na to szkolenie."
    end
    errors.add(:email, message) if double_error 
  end

end
