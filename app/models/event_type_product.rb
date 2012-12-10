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

class EventTypeProduct < ActiveRecord::Base
  belongs_to :event_type
  belongs_to :product
  attr_accessible :event_type_id, :product_id
end
