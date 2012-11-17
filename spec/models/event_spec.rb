require 'spec_helper'

describe Event do
  
  # Create model instances
  let(:et)     { FactoryGirl.create(:event_type) }
  let(:event)  { FactoryGirl.create(:event, event_type: et) }
  # Set subject for following test cases
  subject { event }

  # Responses to methods
  it { should respond_to(:name) }
  it { should respond_to(:event_type_id) }
  it { should respond_to(:city) }
  it { should respond_to(:price_per_participant) }
  it { should respond_to(:date) }
  it { should respond_to(:participants) }

  its(:event_type) { should == et }

  it { should be_valid }

  # Accessible attributes

  # Validations
  describe "when name is not present" do
    before { event.name = " " }
    it { should_not be_valid }
  end

  describe "when name is to short" do
    before { event.name = "a"*5 }
    it { should_not be_valid }
  end

  describe "when city is not present" do
    before { event.city = " " }
    it { should_not be_valid }
  end

  describe "when date is not present" do
    before { event.date = " " }
    it { should_not be_valid }
  end

  # Associations

  # Other Test Cases

end
