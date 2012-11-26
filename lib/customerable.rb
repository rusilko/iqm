module Customerable
  def self.included(base)
    base.has_one :customer, as: :customerable, autosave: true, dependent: :destroy
    base.validate :customer_must_be_valid
    base.alias_method_chain :customer, :autobuild
    base.extend ClassMethods
    base.define_customer_accessors
  end

  def customer_with_autobuild
    customer_without_autobuild || build_customer
  end

  def method_missing(meth, *args, &blk)
    customer.send(meth, *args, &blk)
  rescue NoMethodError
    super
  end

  module ClassMethods
    def define_customer_accessors
      all_attributes = Customer.content_columns.map(&:name)
      ignored_attributes = ["created_at", "updated_at", "customerable_type"]
      attributes_to_delegate = all_attributes - ignored_attributes
      attributes_to_delegate.each do |attrib|
        class_eval <<-RUBY
          def #{attrib}
            customer.#{attrib}
          end
         
          def #{attrib}=(value)
            self.customer.#{attrib} = value
          end
         
          def #{attrib}?
            self.customer.#{attrib}?
          end
        RUBY
      end
    end
  end

  protected
  
    def customer_must_be_valid
      unless customer.valid?
        customer.errors.each do |attr, message|
          errors.add(attr, message)
        end
      end
    end

end