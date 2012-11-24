class User < ActiveRecord::Base
  attr_accessible :email, :password_digest, :company_id, :company_primary_contact
end
