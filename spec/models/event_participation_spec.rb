require 'spec_helper'

describe EventParticipation do
  
    # Create model instances
    let(:p1)          { FactoryGirl.create(:participant) }
    let(:event)       { FactoryGirl.create(:event) }
    let(:ev_part)     { p1.event_participations.build(event_id: event.id) }
  
    # Set subject for following test cases
    subject { ev_part }
  
    # Responses to methods
    it { should respond_to(:event) }
    it { should respond_to(:participant) }

    its(:event)       { should == event }
    its(:participant) { should == p1 }
    
    it { should be_valid }
  
    # Accessible attributes
    # describe "accesible attributes" do
    #   it "should not allow access to particpant_id attribute" do
    #     expect do
    #       EventParticipation.new(particpant_id: p1.id)
    #     end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    #   end
    # end
    
    # Validations
  
    describe "when event id is not present" do
      before { ev_part.event_id = nil }
      it { should_not be_valid }
    end

    describe "when participant id is not present" do
      before { ev_part.participant_id = nil }
      it { should_not be_valid }
    end

    # Associations
  
    # Other Test Cases
  
end
