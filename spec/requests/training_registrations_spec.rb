require 'spec_helper'

def test_models_persistence(order,order_items,seats,clients,customer,addresses,coordinator,training)
  order_items.size.should == 1
  coordinator.first.should == clients.first
  seats.size.should == 1
  order.first.order_items.first.seats.first.client.should == clients.first
end

describe "Valid Registration" do

  let(:et)      { FactoryGirl.create(:event_type) }
  let(:training) { FactoryGirl.create(:training, training_type: et) } 

  before(:each) do
    visit new_training_order_path(training)
  end

  # elements repo
  # click_link('add_seat_btn')
  # all("input[name*='name']")[0].set("Jimmy") 

  subject { page }

  describe "as a Company with", js: true do
    describe "1 participant," do
      before do
        within(".participants_table_wrapper") do
          find("input[name*='name']").set("Jimmy") 
          find("input[name*='email']").set("jimmy@gmail.com") 
          find("input[name*='phone_1']").set("123 456 789") 
        end
        within(".customer_wrapper") do
          find("input[name*='name']").set("Jimland co")
          find("input[name*='email']").set("jimmy@jimland.com")
          find("input[name*='phone_1']").set("987 654 321")
          find("input[name*='nip']").set("123-456-32-18")
        end
        within(".customer_wrapper .address_box") do
          find("input[name*='line_1']").set("Madison Avenue")
          find("input[name*='line_2']").set("58/12")
          find("input[name*='city']").set("New York")
          find("input[name*='postcode']").set("32-087")
        end
      end
      describe "1 address, no coordinator" do
        it "is a pending example" do
          expect { click_button('create_or_update_offer_btn') }.to change(Order, :count).by(1)

          order       = Order.all
          order_items = OrderItem.all
          seats       = Seat.all
          clients     = Client.all
          customer    = Company.all 
          addresses   = Address.all 
          coordinator = Client.all
          test_models_persistence(order,order_items,seats,clients,customer,addresses,coordinator,training)

        end
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
    describe "several participants," do
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
