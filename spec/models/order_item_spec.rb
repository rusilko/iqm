# == Schema Information
#
# Table name: order_items
#
#  id               :integer         not null, primary key
#  quantity         :integer
#  order_id         :integer
#  productable_id   :integer
#  productable_type :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

require 'spec_helper'

describe OrderItem do
  pending "add some examples to (or delete) #{__FILE__}"
end
