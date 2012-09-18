# == Schema Information
#
# Table name: cost_items
#
#  id          :integer         not null, primary key
#  quote_id    :integer
#  name        :string(255)
#  single_cost :integer
#  factor_type :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe CostItem do

  # Create model instances
  let(:offer) { FactoryGirl.create(:offer) }
  let(:quote) { FactoryGirl.create(:quote, number_of_days: 10, offer: offer) }
  let(:ci1)   { FactoryGirl.create(:cost_item, quote: quote) } # 100 perday
  let!(:ci2)  { FactoryGirl.create(:cost_item, quote: quote, single_cost: 200, factor_type: "per_person" ) } # 200 per person
  let!(:ci3)  { FactoryGirl.create(:cost_item, quote: quote, single_cost: 500, factor_type: "per_event"  ) } # 500 per event
  let!(:iv1)  { FactoryGirl.create(:income_variant, currently_chosen: true, quote: quote) } # 10 participants  
  # Set subject for following test cases
  subject { ci1 }

  # Responses to methods
  it { should respond_to(:name) }
  it { should respond_to(:single_cost) }
  it { should respond_to(:factor_type) }
  it { should respond_to(:factor_types)}
  it { should respond_to(:cost_item_total) }
  its(:cost_item_total) { should == 100 * 10 }
  its(:quote) { should == quote }

  # Accessible attributes
  describe "accesible attributes" do
    
    it "should not allow access to quote_id attribute" do
      expect do
        CostItem.new(name: "Lorem ipsum", quote_id: quote.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to cost_item_total attribute" do
      expect do
        CostItem.new(name: "Lorem ipsum", cost_item_total: 1200)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

  end

  # Validations

  describe "when single_cost is not a number" do
    before { ci1.single_cost = "a"}
    it { should_not be_valid }
  end

  describe "when single_cost is a negative number" do
    before { ci1.single_cost = -1 }
    it { should_not be_valid }
  end

  describe "when factor_type is not in allowed enum values" do
    before { ci1.factor_type = (0...8).map{65.+(rand(25)).chr}.join }
    it { should_not be_valid}
  end

  %w(per_day per_person per_event).each do |per|
    describe "when factor_type is in allowed enum values" do
      before { ci1.factor_type = per }
      it { should be_valid }
    end
  end
   
  # Associations
  # describe "when quote_id is not present" do
  #   before { ci1.quote_id = nil }
  #   it { should_not be_valid }
  # end

  # Other Test Cases
  
  describe "return value of cost_item_total" do
    before(:each) do 
      iv1.save
      ci1.single_cost = 0
      ci1.factor_type = nil
      ci1.save
    end

    describe "when single_cost is 0 and factor_type is not set" do
      its(:cost_item_total) { should be_zero }
    end

    describe "when single_cost is 0" do
      before do
        ci1.factor_type = "per_day"      
      end
      its(:cost_item_total) { should be_zero }
    end

    describe "when factor_type is not set" do
      before do
        ci1.single_cost = 100
      end
      its(:cost_item_total) { should be_zero }
    end

    describe "when single_cost and factor types are both positive" do
      before do
        ci1.single_cost = 100
        ci1.factor_type = "per_person"        
      end      
      specify { ci1.cost_item_total.should == 10 * 100 }
      specify { ci2.cost_item_total.should == 10 * 200 }
      specify { ci3.cost_item_total.should == 1  * 500 }
    end
  end

end
