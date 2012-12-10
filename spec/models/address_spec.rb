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

require 'spec_helper'

describe Address do
  pending "add some examples to (or delete) #{__FILE__}"
end
