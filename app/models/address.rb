class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  attr_accessible :city, :country, :default_billing, :default_sending, :line_1, :line_2, :other_details, :postcode
end
