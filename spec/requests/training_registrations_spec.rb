require 'spec_helper'

describe "Registering" do
    
  before do
    let(:et)      { FactoryGirl.create(:event_type) }
    let(:traning) { FactoryGirl.create(:training, event_type: et) }
  end 

  before(:each) do
    visit new_training_order_item_path(training)
  end

  subject { page }

  describe "as a Company with" do
    describe "1 participant," do
      describe "1 address, no coordinator" do
        it "is a pending example"
      end

      describe "2 addresses, no coordinator" do
        it "is a pending example"        
      end

      describe "1 address, 1 coordinator" do
        it "is a pending example" 
      end

      describe "2 addresses, 1 coordinator" do
        it "is a pending example"  
      end

      describe "1 addresses, toggling 2nd address box" do
        it "is a pending example"        
      end

      describe "1 address, toggling coordinator box" do
        it "is a pending example"        
      end      
    end
    describe "several participants,d" do
      describe "1 address, no coordinator" do
        it "is a pending example"       
      end

      describe "2 addresses, no coordinator" do
        it "is a pending example"        
      end

      describe "1 address, 1 coordinator" do
        it "is a pending example"
      end

      describe "2 addresses, 1 coordinator" do
        it "is a pending example"
      end

      describe "toggling 2nd address box" do
        it "is a pending example"
      end

      describe "toggling coordinator box" do
        it "is a pending example"
      end      
    end
  end

  describe "as a Person with" do
    describe "1 participant," do
      describe "1 address" do
        it "is a pending example"
      end

      describe "2 addresses" do
        it "is a pending example"
      end

      describe "1 addresses and toggling 2nd address box" do
        it "is a pending example"
      end
    end
    describe "several participants," do
      describe "1 address" do
        it "is a pending example"  
      end

      describe "2 addresses" do
        it "is a pending example"  
      end

      describe "toggling 2nd address box" do
        it "is a pending example"  
      end
    end
  end

end
