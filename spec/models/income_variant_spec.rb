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
  let(:offer)  { FactoryGirl.create(:offer) }
  let(:quote)  { FactoryGirl.create(:quote, offer: offer) }
  let(:iv)     { FactoryGirl.create(:income_variant, quote: quote) }

  subject { iv }

  it { should respond_to(:number_of_participants) }
  it { should respond_to(:price_per_participant) }
  it { should respond_to(:currently_chosen) }
  it { should respond_to(:quote_id) }
  its(:quote) { should == quote }

  it { should be_valid }
  
  #Accessible attributes
  describe "accesible attributes" do
    it "should not allow access to quote_id attribute" do
      expect do
        IncomeVariant.new(quote_id: 5)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  #Validations
  describe "when number_of_participants is not a number" do
    before { iv.number_of_participants = "a" }
    it { should_not be_valid }
  end

  describe "when number_of_participants is not positive" do
    before { iv.number_of_participants = 0 }
    it { should_not be_valid }
  end

  describe "when price_per_participant is not a number" do
    before { iv.price_per_participant = "aaa" }
    it { should_not be_valid }
  end

  describe "when price_per_participant is negative" do
    before { iv.price_per_participant = -1 }
    it { should_not be_valid }
  end

  #Associations
  # describe "when quote_id is not present" do
  #   before { iv.quote_id = nil }
  #   it { should_not be_valid }
  # end

end
