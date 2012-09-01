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
  
  let(:offer)  { FactoryGirl.create(:offer) }
  let(:quote1) { offer.quotes.build(name: "Quote 1") }
  let(:quote2) { FactoryGirl.create(:quote, offer: offer) }

  subject { quote1 }

  it { should respond_to(:name) }
  it { should respond_to(:number_of_days) }
  it { should respond_to(:event_type) }
  it { should respond_to(:offer_id) }
  it { should respond_to(:income_variants) }
  it { should respond_to(:cost_items) }
  its(:offer) { should == offer }

  it { should be_valid }

  #Accessible attributes
  describe "accesible attributes" do
    it "should not allow access to offer_id attribute" do
      expect do
        Quote.new(name: "Lorem ipsum", offer_id: offer.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  #Validations
  describe "when name is not present" do
    before { quote1.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { quote1.name = "a" * 16 }
    it { should_not be_valid } 
  end

  describe "when name is too short" do
    before { quote1.name = "a" * 2 }
    it { should_not be_valid }
  end

  describe "when number of days is too small" do
    before { quote1.number_of_days = 0 }
    it { should_not be_valid }
  end  

  describe "when number of days is too big" do
    before { quote1.number_of_days = 11 }
    it { should_not be_valid }
  end

  describe "validations for event_type" do
    pending "what do we want here, a fixed drop down list?"
  end

  #Associations

  describe "when offer_id is not present" do
    before { quote1.offer_id = nil }
    it { should_not be_valid}
  end

end
