# == Schema Information
#
# Table name: cost_items
#
#  id          :integer         not null, primary key
#  quote_id    :integer
#  name        :string(255)
#  single_cost :integer
#  factor_type :string(255)
#  total_cost  :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe CostItem do

  #Create model instance
  let(:offer) { FactoryGirl.create(:offer) }
  let(:quote) { FactoryGirl.create(:quote, offer: offer) }
  let(:ci)    { FactoryGirl.create(:cost_item, quote: quote) }
  
  subject { ci }

  #Responses to methods
  it { should respond_to(:name) }
  it { should respond_to(:single_cost) }
  it { should respond_to(:factor_type) }
  it { should respond_to(:total_cost) }
  its(:quote) { should == quote }

  #Accessible attributes
  describe "accesible attributes" do
    
    it "should not allow access to quote_id attribute" do
      expect do
        CostItem.new(name: "Lorem ipsum", quote_id: quote.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to total_cost attribute" do
      expect do
        CostItem.new(name: "Lorem ipsum", total_cost: 1200)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

  end

  #Validations

  # describe "when name is not present" do
  #   before { ci.name = " " }
  #   it { should_not be_valid }
  # end

  # describe "when single_cost is not present" do
  #   before { ci.single_cost = nil }
  #   it { should_not be_valid }
  # end

  describe "when single_cost is not a number" do
    before { ci.single_cost = "a"}
    it { should_not be_valid }
  end

  describe "when single_cost is a negative number" do
    before { ci.single_cost = -1 }
    it { should_not be_valid }
  end

  describe "when factor_type is not in allowed enum values" do
    before { ci.factor_type = (0...8).map{65.+(rand(25)).chr}.join }
    it { should_not be_valid}
  end

  %w(per_day per_person per_event).each do |per|
    describe "when factor_type is in allowed enum values" do
      before { ci.factor_type = per }
      it { should be_valid }
    end
  end
   
  #Associations
  # describe "when quote_id is not present" do
  #   before { ci.quote_id = nil }
  #   it { should_not be_valid }
  # end

end
