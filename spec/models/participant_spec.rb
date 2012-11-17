require 'spec_helper'

describe Participant do
  
  # Create model instances
  let(:p1)  { FactoryGirl.create(:participant) }
  let(:ev)  { FactoryGirl.create(:event) }
  # Set subject for following test cases
  subject { p1 }

  # Responses to methods
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:events) }
  
  it { should be_valid }

  # Accessible attributes
  
  # Validations

  describe "when name is not present" do
    before {p1.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too short" do
    before { p1.name = "a"*4 }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { p1.name = "a"*51 }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { p1.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    invalid_addresses = %w[ user@foo,com user_at_foo.org user@foo. ]
    invalid_addresses.each do |invalid_address|
      before { p1.email = invalid_address}
      it { should_not be_valid }
    end
  end

  describe "when email format is valid" do
    valid_addresses = %w[ user@foo.com USER@foo.org first.last@foo.jp ]
    valid_addresses.each do |valid_address|
      before { p1.email = valid_address}
      it { should be_valid }
    end
  end

  describe "when email address is already taken" do
    let(:p2) { FactoryGirl.create(:participant) }
    before do
      p2.email = p1.email.upcase
      p2.save
    end
    specify { p2.should_not be_valid }
  end


  # Associations

  # Other Test Cases
  
end
