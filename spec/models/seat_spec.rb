# == Schema Information
#
# Table name: seats
#
#  id            :integer         not null, primary key
#  client_id     :integer
#  order_item_id :integer
#  training_id   :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

require 'spec_helper'

describe Seat do
  pending "add some examples to (or delete) #{__FILE__}"
end
