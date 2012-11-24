require 'customerable.rb'

class ActiveRecord::Base
  def self.acts_as_customer
    include Customerable
  end
end