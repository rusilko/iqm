# == Schema Information
#
# Table name: event_type_products
#
#  id            :integer         not null, primary key
#  event_type_id :integer
#  product_id    :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

require 'spec_helper'

describe EventTypeProduct do
  pending "add some examples to (or delete) #{__FILE__}"
end
