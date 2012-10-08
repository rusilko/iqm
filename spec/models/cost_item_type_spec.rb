# == Schema Information
#
# Table name: cost_item_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe CostItemType do
  
  # Create model instances
  let(:offer)   { FactoryGirl.create(:offer) }
  let(:quote)   { FactoryGirl.create(:quote, number_of_days: 10, offer: offer) }
  let(:ci_type) { FactoryGirl.create(:cost_item_type) }
  let(:ci_type2) { FactoryGirl.create(:cost_item_type) }
  let!(:ci1)     { FactoryGirl.create(:cost_item, quote: quote, cost_item_type: ci_type) }
  let!(:ci2)     { FactoryGirl.create(:cost_item, quote: quote, cost_item_type: ci_type) }
  let!(:ci3)     { FactoryGirl.create(:cost_item, quote: quote, cost_item_type: ci_type) }


  # Set subject for following test cases
  subject { ci_type }

  # Responses to methods
  it { should respond_to(:name) }
  it { should respond_to(:cost_items) }
  its(:cost_items) { should == [ci1, ci2, ci3] }

  it { should be_valid }

  # Accessible attributes

  # Validations
  describe "when name is not present" do
    before { ci_type.name = "" }
    it { should_not be_valid }
  end

  describe "when creating second type with the same name" do
    before do
      ci_type2.name = "abcd"
      ci_type2.save
      ci_type.name = "ABCD"
    end
    it { should_not be_valid }
  end
  # Associations
  describe "cost items associations" do
    it "should not destroy associated cost imtes upon destroying the ci type" do
      cost_items = ci_type.cost_items
      ci_type.destroy
      cost_items.each do |ci|
        CostItem.find_by_id(ci.id).should_not be_nil
      end
    end
  end
  # Other Test Cases
  
end
