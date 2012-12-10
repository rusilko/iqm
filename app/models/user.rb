# == Schema Information
#
# Table name: users
#
#  id                      :integer         not null, primary key
#  name                    :string(255)
#  phone_1                 :string(255)
#  phone_2                 :string(255)
#  nip                     :string(255)
#  regon                   :string(255)
#  email                   :string(255)
#  password_digest         :string(255)
#  type                    :string(255)
#  company_id              :integer
#  company_primary_contact :boolean
#  position                :string(255)
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password_digest
end
