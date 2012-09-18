# == Schema Information
#
# Table name: income_variants
#
#  id                     :integer         not null, primary key
#  quote_id               :integer
#  number_of_participants :integer
#  price_per_participant  :integer
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  currently_chosen       :boolean
#

require 'spec_helper'

describe IncomeVariant do

  # Create model instance
  let(:offer)  { FactoryGirl.create(:offer) }
  let(:quote)  { FactoryGirl.create(:quote, offer: offer) }
  let!(:iv1)     { FactoryGirl.create(:income_variant, quote: quote) }
  let!(:iv2)     { FactoryGirl.create(:income_variant, quote: quote) }
  let!(:iv3)     { FactoryGirl.create(:income_variant, quote: quote) }

  # Set subject for following test cases
  subject { iv1 }

  # Responses to methods
  it { should respond_to(:number_of_participants) }
  it { should respond_to(:price_per_participant) }
  it { should respond_to(:currently_chosen) }
  it { should respond_to(:quote_id) }
  it { should respond_to(:total_income) }
  its(:quote) { should == quote }
  its(:currently_chosen) { should be_false }
  its(:total_income) { should == 15000 }

  it { should be_valid }
  
  # Accessible attributes
  describe "accesible attributes" do
    it "should not allow access to quote_id attribute" do
      expect do
        IncomeVariant.new(quote_id: 5)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  # Validations
  describe "when number_of_participants is not a number" do
    before { iv1.number_of_participants = "a" }
    it { should_not be_valid }
  end

  describe "when number_of_participants is not positive" do
    before { iv1.number_of_participants = 0 }
    it { should_not be_valid }
  end

  describe "when price_per_participant is not a number" do
    before { iv1.price_per_participant = "aaa" }
    it { should_not be_valid }
  end

  describe "when price_per_participant is negative" do
    before { iv1.price_per_participant = -1 }
    it { should_not be_valid }
  end

  describe "when setting iv currently_chosen true for the first time" do
    before { iv1.currently_chosen = true }
    it { should be_valid }
    its(:currently_chosen) { should be_true }
  end

  describe "there should be only one currently_chosen income_variant per quote at a time" do  

    describe "when saving another iv with currently_chosen set to true (same quote)" do
      before do
        iv1.currently_chosen = true
        iv1.save
        iv2.currently_chosen = true
        iv2.save
        iv1.reload
        iv2.reload
      end
      specify { iv1.currently_chosen.should be_false }
      specify { iv2.currently_chosen.should be_true  }
      specify { iv3.currently_chosen.should be_false }
    end

    describe "when saving another iv with currently_chosen set to true (same quote)" do
      before do
        iv1.currently_chosen = true
        iv1.save
        iv2.currently_chosen = true
        iv2.save
        iv3.currently_chosen = true
        iv3.save
        iv1.reload
        iv2.reload
        iv3.reload
      end
      specify { iv1.currently_chosen.should be_false }
      specify { iv2.currently_chosen.should be_false }
      specify { iv3.currently_chosen.should be_true  }
    end

    describe "when saving another iv with currently_chosen set to false (same quote)" do
      before do
        iv1.currently_chosen = true
        iv1.save
        iv2.currently_chosen = false
        iv2.save
        iv1.reload
        iv2.reload
      end
      specify { iv1.currently_chosen.should be_true }
      specify { iv2.currently_chosen.should be_false }
      specify { iv3.currently_chosen.should be_false }
    end

  end

  # Associations


  # Other Test Cases
  describe "return value of total_income method" do
    
    before(:each) do
      iv1.number_of_participants = 0
      iv1.price_per_participant = 0
    end

    describe "when number_of_participants and price_per_participant are both 0" do
      its(:total_income) { should be_zero }
    end

    describe "when number_of_participants is 0" do
      before { price_per_participant = 1000 }
      its(:total_income) { should be_zero }
    end
    
    describe "when price_per_participant is 0" do
      before { number_of_participants = 20 }
      its(:total_income) { should be_zero }
    end
    
    describe "when number_of_participants and price_per_participant are positive" do
      before do
        iv1.number_of_participants = 30
        iv1.price_per_participant = 1000
      end
      its(:total_income) { should == 30000 }
    end
  end
end
