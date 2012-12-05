class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  attr_accessible :city, :country, :default_billing, :default_sending, :line_1, :line_2, :other_details, :postcode

  # validates :line_1,    presence: true
  # validates :city,      presence: true
  # # validates :country,   presence: true
  # validates :postcode,  presence: true,
  #                       format: { with: /\d{2}[\s-]?\d{3}/, message: "Niepoprawny format. Sprobuj xx-xxx."}

end
