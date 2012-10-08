# == Schema Information
#
# Table name: event_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe EventType do
  
  # Create model instances
  let(:offer) { FactoryGirl.create(:offer) }  
  let(:et)    { FactoryGirl.create(:event_type) }
  let!(:q1)    { FactoryGirl.create(:quote, number_of_days: 10, offer: offer, event_type: et) }
  let!(:q2)    { FactoryGirl.create(:quote, number_of_days: 10, offer: offer, event_type: et) }
  let!(:q3)    { FactoryGirl.create(:quote, number_of_days: 10, offer: offer, event_type: et) }   
  # Set subject for following test cases
  subject { et }

  # Responses to methods
  it { should respond_to(:name)   }
  it { should respond_to(:quotes) }
  its(:quotes) { should == [q1, q2, q3] }

  it { should be_valid }

  # Accessible attributes

  # Validations
  describe "when name is not present" do
    before { et.name = "" }
    it { should_not be_valid }
  end

  # Associations

  describe "quotes associations" do
    it "should not destroy associated quotes upon destroying the event_type" do
      quotes = et.quotes
      et.destroy
      quotes.each do |q|
        Quote.find_by_id(q.id).should_not be_nil
      end
    end
  end

  
  # Other Test Cases
  
end
