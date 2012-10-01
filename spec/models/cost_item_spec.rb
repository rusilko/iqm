# == Schema Information
#
# Table name: cost_items
#
#  id          :integer         not null, primary key
#  quote_id    :integer
#  name        :string(255)
#  factor_type :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  vat         :string(255)
#  single_cost :decimal(8, 2)
#

require 'spec_helper'

describe CostItem do

  # Create model instances
  let(:offer) { FactoryGirl.create(:offer) }
  let(:quote) { FactoryGirl.create(:quote, number_of_days: 10, offer: offer) }
  let(:ci1)   { FactoryGirl.create(:cost_item, quote: quote) } # 100 perday, vat 23
  let!(:ci2)  { FactoryGirl.create(:cost_item, quote: quote, single_cost: 200, factor_type: "per_person" ) } # 200 per person
  let!(:ci3)  { FactoryGirl.create(:cost_item, quote: quote, single_cost: 500, factor_type: "per_event"  ) } # 500 per event
  let!(:iv1)  { FactoryGirl.create(:income_variant, currently_chosen: true, quote: quote) } # 10 participants  
  # Set subject for following test cases
  subject { ci1 }

  # Responses to methods
  it { should respond_to(:name) }
  it { should respond_to(:single_cost) }
  it { should respond_to(:vat) }
  it { should respond_to(:vat_factor) }
  it { should respond_to(:factor_type) }
  it { should respond_to(:factor_types)}
  it { should respond_to(:cost_item_total_netto ) }
  it { should respond_to(:cost_item_total_brutto) }
  its(:cost_item_total_netto ) { should == 100 * 10 }
  its(:cost_item_total_brutto) { should == ci1.cost_item_total_netto * 1.23 }
  its(:quote) { should == quote }

  # Accessible attributes
  describe "accesible attributes" do
    
    it "should not allow access to quote_id attribute" do
      expect do
        CostItem.new(name: "Lorem ipsum", quote_id: quote.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it "should not allow access to cost_item_total_netto attribute" do
      expect do
        CostItem.new(name: "Lorem ipsum", cost_item_total_netto: 1200)
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

  describe "when vat is not in allowed enum values" do
    before { ci1.vat = (0...8).map{65.+(rand(25)).chr}.join }
    it { should_not be_valid }
  end

  %w(zw 0 8 23).each do |vat|
    describe "when vat is in allowed enum values" do
      before { ci1.vat = vat }
      it { should be_valid }
    end
  end
   
  # Associations
  # describe "when quote_id is not present" do
  #   before { ci1.quote_id = nil }
  #   it { should_not be_valid }
  # end

  # Other Test Cases
  
  describe "return value of cost_item_total netto and brutto" do
    before(:each) do 
      iv1.save
      ci1.single_cost = 0
      ci1.factor_type = nil
      ci1.vat = "23"
      ci1.save
    end

    describe "when single_cost is 0 and factor_type is not set" do
      its(:cost_item_total_netto)  { should be_zero }
      its(:cost_item_total_brutto) { should be_zero }
    end

    describe "when single_cost is 0" do
      before do
        ci1.factor_type = "per_day"      
      end
      its(:cost_item_total_netto) { should be_zero }
      its(:cost_item_total_brutto) { should be_zero }
    end

    describe "when factor_type is not set" do
      before do
        ci1.single_cost = 100
      end
      its(:cost_item_total_netto) { should be_zero }
      its(:cost_item_total_brutto) { should be_zero }
    end

    describe "when single_cost and factor types are both positive" do
      before do
        ci1.single_cost = 100
        ci1.factor_type = "per_person"        
      end      
      specify { ci1.cost_item_total_netto.should  == 10 * 100 }
      specify { ci1.cost_item_total_brutto.should == 10 * 100 * 1.23 }
      specify { ci2.cost_item_total_netto.should  == 10 * 200 }
      specify { ci2.cost_item_total_brutto.should == 10 * 200 * 1.23 }
      specify { ci3.cost_item_total_netto.should  == 1  * 500 }
      specify { ci3.cost_item_total_brutto.should == 1  * 500 * 1.23 }
    end

    describe "when changing vat values" do
      before do
        ci1.single_cost = 100
        ci1.factor_type = "per_person"
        ci1.vat = "zw"
      end

      its(:cost_item_total_brutto) { should == 10 * 100 }

      it "should change total brutto when changing vat type to 8%" do
        ci1.vat = "8"
        ci1.save
        ci1.cost_item_total_brutto.should == 10 * 100 * 1.08
      end

      it "should change total brutto when changing vat type to 0%" do
        ci1.vat = "0"
        ci1.save
        ci1.cost_item_total_brutto.should == 10 * 100
      end  
    end
  end
end
