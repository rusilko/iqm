# == Schema Information
#
# Table name: offers
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Offer do

  # Create model instance
  let(:offer)   { FactoryGirl.create(:offer) }
  let!(:quote1) { FactoryGirl.create(:quote, offer: offer) }
  let!(:quote2) { FactoryGirl.create(:quote, offer: offer) }

  # Set subject for following test cases
  subject { offer }

  # Responses to methods
  it { should respond_to(:name)   }
  it { should respond_to(:quotes) }
  its(:quotes) { should == [quote1, quote2] }

  it { should be_valid }

  # Accessible attributes
  # describe "accesible attributes" do
  #   pending "check if protected attributes are not accesible"
  # end

  # Validations
  describe "when name is not present" do
    before { offer.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { offer.name = "a" * 51 }
    it { should_not be_valid } 
  end

  describe "when name is too short" do
    before { offer.name = "a" * 2 }
    it { should_not be_valid }
  end

  # Associations
  describe "quotes associations" do
    it "should destroy associated quotes upon destroying the offer" do
      quotes = offer.quotes
      offer.destroy
      quotes.each do |quote|
        Quote.find_by_id(quote.id).should be_nil
      end
    end
  end

  # Other Test Cases
  
end
