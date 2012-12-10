# == Schema Information
#
# Table name: companies
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  phone_1    :string(255)
#  phone_2    :string(255)
#  nip        :string(255)
#  regon      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Company do
  pending "add some examples to (or delete) #{__FILE__}"
end
