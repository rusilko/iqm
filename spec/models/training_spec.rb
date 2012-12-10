# == Schema Information
#
# Table name: trainings
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  start_date       :date
#  end_date         :date
#  city             :string(255)
#  price_per_person :integer
#  training_type_id :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

require 'spec_helper'

describe Training do
  pending "add some examples to (or delete) #{__FILE__}"
end
