# == Schema Information
#
# Table name: quotes
#
#  id             :integer         not null, primary key
#  offer_id       :integer
#  name           :string(255)
#  event_type     :string(255)
#  number_of_days :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

require 'spec_helper'

describe Quote do
  
  # Create model instances
  let(:offer)  { FactoryGirl.create(:offer) }
  # let(:quote1) { offer.quotes.build(name: "Quote 1") } - alternative way
  let(:quote) { FactoryGirl.create(:quote, number_of_days: 10, offer: offer) }
  let!(:iv1)   { FactoryGirl.create(:income_variant, currently_chosen: true, quote: quote) } # 10 participants, 1500 price

  let!(:iv2)   { FactoryGirl.create(:income_variant, number_of_participants: 12, 
                                    price_per_participant: 1200, quote: quote) }  
  let!(:iv3)   { FactoryGirl.create(:income_variant, number_of_participants: 15, 
                                    price_per_participant: 1100, quote: quote) }

  let!(:ci1)   { FactoryGirl.create(:cost_item, quote: quote) } # 100 per day
  let!(:ci2)   { FactoryGirl.create(:cost_item, single_cost: 200, factor_type: "per_person", quote: quote) }
  let!(:ci3)   { FactoryGirl.create(:cost_item, single_cost: 300, factor_type: "per_event", quote: quote) }

  # Set subject for following test cases
  subject { quote }

  # Responses to methods
  it { should respond_to(:name) }
  it { should respond_to(:number_of_days) }
  it { should respond_to(:event_type) }
  it { should respond_to(:offer_id) }
  it { should respond_to(:income_variants) }
  it { should respond_to(:cost_items) }
  it { should respond_to(:total_cost) }
  it { should respond_to(:total_income) }

  its(:offer)           { should == offer }
  its(:income_variants) { should == [iv1, iv2, iv3] }
  its(:cost_items)      { should == [ci1, ci2, ci3] }
  its(:total_income)    { should == 10 * 1500 } # this is also tested more thoroughly down below
  its(:total_cost)      { should == 10 * 100 + 200 * 10 + 300 } # this is also tested more thoroughly down below

  it { should be_valid }

  # Accessible attributes
  describe "accesible attributes" do
    it "should not allow access to offer_id attribute" do
      expect do
        Quote.new(name: "Lorem ipsum", offer_id: offer.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  # Validations
  describe "when number of days is too small" do
    before { quote.number_of_days = 0 }
    it { should_not be_valid }
  end

  # TO-DO
  # describe "validations for event_type" do
  #   pending "what do we want here, a fixed drop down list?"
  # end

  # Associations

  describe "income variant associations" do
    it "should destroy associated income variants upon destroying the quote" do
      income_variants = quote.income_variants
      quote.destroy
      income_variants.each do |iv|
        IncomeVariant.find_by_id(iv.id).should be_nil
      end
    end
  end

  describe "cost items associations" do
    it "should destroy associated cost items upon destroying the quote" do
      cost_items = quote.cost_items
      quote.destroy
      cost_items.each do |ci|
        CostItem.find_by_id(ci.id).should be_nil
      end
    end
  end

  # describe "when offer_id is not present" do
  #   before { quote.offer_id = nil }
  #   it { should_not be_valid}
  # end

  # Other Test Cases

  describe "return value of total_income method" do

    describe "when there is no currently chosen income variant" do
      before do
        quote.income_variants.each do |iv|
          iv.currently_chosen = false
          iv.save
        end
      end
      its(:total_income) { should be_zero }
    end

    describe "when there is a currently chosen income variant" do
      before do
        iv1.currently_chosen = true
        iv1.number_of_participants = 11
        iv1.price_per_participant = 100
        iv1.save
      end
      its(:total_income) { should == 11 * 100 }
    end

  end

  describe "return value of total_cost method" do

    describe "when there is a currently chosen income variant" do
      before do
        iv1.currently_chosen = true
        iv1.save
      end
      its(:total_cost) { should == 10 * 100 + 200 * 10 + 300 }
    end

    describe "when there is no currently chosen income variant" do
      before do
        quote.income_variants.each do |iv|
          iv.currently_chosen = false
          iv.save
        end
      end
      its(:total_cost) { should == 10 * 100 + 200 * 0 + 300 }
    end
  end

  describe "total values should change when currently_chosen income_variant changes" do
    before do
      iv1.currently_chosen = false
      iv2.currently_chosen = true
      iv1.save
      iv2.save
    end
    its(:total_income) { should == 14400 }
    its(:total_cost)   { should == 10 * 100 + 200 * 12 + 300 }
  end  

end
