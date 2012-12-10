# == Schema Information
#
# Table name: orders
#
#  id             :integer         not null, primary key
#  status         :string(255)
#  date_placed    :date
#  customer_id    :integer
#  customer_type  :string(255)
#  coordinator_id :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

require 'spec_helper'

describe Order do
  pending "add some examples to (or delete) #{__FILE__}"
end
