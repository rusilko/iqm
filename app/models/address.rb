# == Schema Information
#
# Table name: addresses
#
#  id               :integer         not null, primary key
#  line_1           :string(255)
#  line_2           :string(255)
#  city             :string(255)
#  postcode         :string(255)
#  country          :string(255)
#  default_sending  :boolean
#  default_billing  :boolean
#  other_details    :string(255)
#  addressable_id   :integer
#  addressable_type :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  attr_accessible :city, :default_billing, :default_sending, :line_1, :other_details, :postcode

  validates :line_1,    presence: true
  validates :city,      presence: true
  validates :postcode,  presence: true,
                        format: { with: /\d{2}[\s-]?\d{3}/, message: "Invalid format, please try XX-XXX."}
end
