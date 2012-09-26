require 'spec_helper'

describe "OfferPages" do

  subject { page }
  before  { 3.times { FactoryGirl.create(:offer) } }
  
  describe "index page" do
    before { visit offers_path }

    it { should have_selector('title', text: 'Offers') }    

    it "should list each offer" do
      Offer.all.each do |offer|
        page.should have_selector('td', text: offer.name)
        page.should have_link('Edit', href: edit_offer_path(offer.id))
        page.should have_link('Destroy', href: offer_path(offer.id))
      end
    end

    it { should have_link('new_offer_btn') }

    describe "when clicking new offer button" do
      before { click_on 'new_offer_btn' }
      specify { current_path.should == new_offer_path }
    end

    describe "when clicking offer edit button" do
      before { first('a', text: 'Edit').click }
      specify { current_path.should == edit_offer_path(Offer.first.id) }
    end

    describe "when clicking offer destroy button" do
      it "should destroy offer" do
        expect { first('a', text: 'Destroy').click }.to change(Offer, :count).by(-1)
        page.should have_content("Successfully destroyed offer.")
      end
    end
  end

  describe "new offer page" do
    before(:each) do
      visit new_offer_path
    end

    it { should have_selector('title', text: "New Offer") }
    it { should have_button('create_or_update_offer_btn') }
    it { should have_link('Cancel') }
    
    describe "when creating an offer with a valid name" do
      offer_name = "IBM"
      before do
        fill_in 'offer_name', with: offer_name
      end

      it "should create a new offer" do
        expect { click_on 'create_or_update_offer_btn' }.to change(Offer, :count).by(1)
        expect { Offer.find_by_name(offer_name).should_not == nil }
        page.should have_content("Successfully created offer.")
      end
    end    

    describe "when creating and offer with an invalid name" do
      offer_name = "aa"
      before do
        fill_in 'offer_name', with: offer_name
      end

      it "should not create a new offer" do
        expect { click_on 'create_or_update_offer_btn' }.not_to change(Offer, :count)
        expect { Offer.find_by_name(offer_name).should == nil }
        page.should have_content("error")
      end
    end    
  end 

  describe "edit offer page" do  # or a new offer page for that matter, I will just test on edit page
    describe "when manipulating quotes" do
      let(:offer)   { FactoryGirl.create(:offer) }
      before        { visit edit_offer_path(offer) }
      
      it { should have_selector('title', text: "Edit #{offer.name}") }
      it { should have_link('add_quote_btn') }
      it { should have_link('add_quote_top_btn') }
      it { should have_no_selector('ul#quote_tabs li') }
      it { should have_no_selector('div.tab-content div.tab-pane') }

      describe "when adding new quotes", js: true do
        before { click_on 'add_quote_top_btn' }

        it "should display a new quote tab in tab-bar and new tab-pane in tab-content" do
          page.should have_selector('ul#quote_tabs li.active', text: "New Quote")
          page.should have_selector('div.tab-content div.tab-pane.active')
          
          click_on 'add_quote_top_btn' #lets click again
          page.should have_selector('ul#quote_tabs li', count: 2)
          page.should have_selector('div.tab-content div.tab-pane', count: 2)
        end

        it "should create and save a new quote to db" do
          expect { click_on 'create_or_update_offer_btn' }.to change(offer.quotes, :count).by(1)
        end

        it "should have name, type and # of days fields properly saved to db" do
          pending "how to find the fields?"
        end

      end

      describe "when removing a single quote", js: true do
        let!(:quote) { FactoryGirl.create(:quote, name: "kalk1", offer: offer) }
        
        it { should have_selector('.tab-content .tab-pane .remove_quote_btn') }
        before do
          visit edit_offer_path(offer)
          find('.tab-content').first('.tab-pane').find('.remove_quote_btn').click
        end

        it "should hide quote tab from tab-bar and tab-pane from tab-content" do
          page.should have_link("kalk1")
          page.should have_css('ul#quote_tabs li a', visible: false) #for some reason text: 'kalk1' does not work
          page.should have_selector('div.tab-content div.tab-pane', visible: false)
        end

        it "should delete quote from db" do
          expect { click_on 'create_or_update_offer_btn' }.to change(offer.quotes, :count).by(-1)
        end
      end
    end

    describe "when manipulating income variants" do
      let(:offer)       { FactoryGirl.create(:offer) }
      let!(:quote)      { FactoryGirl.create(:quote, name: "kalk1", offer: offer) }
      let(:add_iv_btn)  { page.find('.tab-content').first('.tab-pane').find('.add_variant_btn') }
      let(:rmv_iv_btn)  { page.find('.tab-content').first('.tab-pane').find('fieldset').first('.income_variant_fieldset').find('.remove_variant_btn') }
      before            { visit edit_offer_path(offer) }

      it { should have_selector('.tab-content .tab-pane a.add_variant_btn') }
      it { should have_no_selector('fieldset.income_variant_fieldset') } 

      describe "when adding income variants", js: true do
        before do 
          visit edit_offer_path(offer)
          add_iv_btn.click 
        end

        it "should display new income variant box" do
          page.should have_selector('fieldset.income_variant_fieldset')
          add_iv_btn.click #lets click again
          page.should have_selector('fieldset.income_variant_fieldset', count: 2)
        end  

        it "should create and save new income variant to db" do
          expect { click_on 'create_or_update_offer_btn' }.to change(quote.income_variants, :count).by(1)
        end
      end

      describe "when removing a single income variant", js: true do
        let!(:iv) { FactoryGirl.create(:income_variant, quote: quote) }
        before do
          visit edit_offer_path(offer)
          rmv_iv_btn.click
        end

        it { should have_selector('.income_variant_fieldset', visible: false) }

        it "should delete income variant from db" do
          expect { click_on 'create_or_update_offer_btn' }.to change(quote.income_variants, :count).by(-1)
        end
      end

      describe "when toggling income variants", js: true do
        let!(:iv1) { FactoryGirl.create(:income_variant, quote: quote) }
        let!(:iv2) { FactoryGirl.create(:income_variant, quote: quote) }
        let(:iv1_box) { page.find('.tab-content').first('.tab-pane').find('fieldset').all('.income_variant_fieldset')[0] }
        let(:iv2_box) { page.find('.tab-content').first('.tab-pane').find('fieldset').all('.income_variant_fieldset')[1] }
        before do 
          visit edit_offer_path(offer)
        end

        it "should properly mark currently chosen iv boxes with grey bg (chosen class)" do
          iv1_box.click
          iv1_box[:class].should =~ /chosen/
          iv2_box[:class].should_not =~ /chosen/
          iv2_box.click
          iv2_box[:class].should =~ /chosen/
          iv1_box[:class].should_not =~ /chosen/
        end


        it "should properly check checkboxes" do
          pending "don't know how to do it yet..."
          # iv1_box.click          
          # iv2_box[:class].should_not =~ /chosen/
          # iv2_box.click
          # iv2_box[:class].should =~ /chosen/
          # iv1_box[:class].should_not =~ /chosen/
        end

        it "should correctly store currently_chosen iv to db" do
          pending "to-do"
        end
      end

      describe "calucating total income", js: true do
        let!(:iv1) { FactoryGirl.create(:income_variant, number_of_participants: 10, price_per_participant: 1000, currently_chosen: true, quote: quote) }
        let!(:iv2) { FactoryGirl.create(:income_variant, number_of_participants: 15, price_per_participant: 1000, quote: quote) }
        let(:iv1_box) { page.find('.tab-content').first('.tab-pane').find('fieldset').all('.income_variant_fieldset')[0] }
        let(:iv2_box) { page.find('.tab-content').first('.tab-pane').find('fieldset').all('.income_variant_fieldset')[1] }
        before do 
          visit edit_offer_path(offer)
        end

        it "should have value of currently checked iv" do
          page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_income td', text: '10000')
          iv2_box.click
          page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_income td', text: '15000')
        end

        it "should change value upon changing values of fields inside iv box" do
          iv1_box.fill_in('offer[quotes_attributes][0][income_variants_attributes][0][number_of_participants]', with: '20')
          iv1_box.click
          page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_income td', text: '20000')
          iv1_box.fill_in('offer[quotes_attributes][0][income_variants_attributes][0][price_per_participant]', with: '2000')
          iv1_box.click
          page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_income td', text: '40000')
        end

        it "should have value of 0 when currently checked iv is removed" do
          iv1_box.click
          iv1_box.find('.remove_variant_btn').click
          page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_income td', text: '0')
        end
      end
    end

    describe "when manipulating cost items" do
      let(:offer)       { FactoryGirl.create(:offer) }
      let!(:quote)      { FactoryGirl.create(:quote, number_of_days: 3, name: "kalk1", offer: offer) }
      let(:add_ci_btn)  { page.find('.tab-content').first('.tab-pane').find('.add_cost_item_btn') }
      let(:rmv_ci_btn)  { page.find('.tab-content').first('.tab-pane').first('.remove_cost_item_btn') }
      before            { visit edit_offer_path(offer) }

      it { should have_selector('a.add_cost_item_btn') }
      it { should have_no_selector('.cost_items_table tbody tr', count: 2) } 

      describe "when adding cost items", js: true do
        before do 
          visit edit_offer_path(offer)
          add_ci_btn.click 
        end

        it "should display new cost item row" do
          page.should have_selector('.cost_items_table tbody tr', count: 2)
          add_ci_btn.click #lets click again
          page.should have_selector('.cost_items_table tbody tr', count: 3)
        end  

        it "should create and save new cost item to db" do
          expect { click_on 'create_or_update_offer_btn' }.to change(quote.cost_items, :count).by(1)
        end
      end

      describe "when removing a single cost item", js: true do
        let!(:ci) { FactoryGirl.create(:cost_item, quote: quote) }
        before do
          visit edit_offer_path(offer)
          rmv_ci_btn.click
        end

        it { should have_selector('.cost_items_table tbody tr', count: 2) }

        it "should delete cost item from db" do
          expect { click_on 'create_or_update_offer_btn' }.to change(quote.cost_items, :count).by(-1)
        end
      end

      describe "calucating cost totals" do
        describe "when calucating per_day cost items" do
          let!(:ci1) { FactoryGirl.create(:cost_item, quote: quote) } # 100 per day
          it "should have proper cost item total cost" do 
            visit edit_offer_path(offer)
            page.find('.tab-content').first('.tab-pane').first('.total').should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '300')
          end

          it "should have proper total cost" do
            visit edit_offer_path(offer)
            page.should have_selector('td.quote_total_value', text: '300')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '300')    
          end
        end

        describe "when calucating per_person cost items" do
          let!(:ci1) { FactoryGirl.create(:cost_item, quote: quote, single_cost: 100, factor_type: 'per_person') } # 100 per person
          let!(:iv1) { FactoryGirl.create(:income_variant, quote: quote, currently_chosen: true) } # 10 participants per 1500
          it "should have proper cost item total cost" do 
            visit edit_offer_path(offer)
            page.find('.tab-content').first('.tab-pane').first('.total').should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '1000')
          end

          it "should have proper total cost and total gain" do
            visit edit_offer_path(offer)
            page.should have_selector('td.quote_total_value', text: '1000')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '1000')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_gain td', text: '14000')    
          end          
        end

        describe "when calucating per_event cost items" do
          let!(:ci1) { FactoryGirl.create(:cost_item, quote: quote, single_cost: 100, factor_type: 'per_event') } # 100 per event
          it "should have proper cost item total cost" do 
            visit edit_offer_path(offer)
            page.find('.tab-content').first('.tab-pane').first('.total').should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '100')
          end 
        end

        describe "when changing income variants", js: true do
          let!(:ci1) { FactoryGirl.create(:cost_item, quote: quote, single_cost: 100, factor_type: 'per_person') } # 100 per person
          let!(:ci2) { FactoryGirl.create(:cost_item, quote: quote, single_cost: 200, factor_type: 'per_person') } # 200 per person
          let!(:iv1) { FactoryGirl.create(:income_variant, quote: quote, currently_chosen: true) } # 10 participants
          let!(:iv2) { FactoryGirl.create(:income_variant, quote: quote, currently_chosen: false, number_of_participants: 20) } # 20 participants
          let(:iv1_box) { page.find('.tab-content').first('.tab-pane').find('fieldset').all('.income_variant_fieldset')[0] }
          let(:iv2_box) { page.find('.tab-content').first('.tab-pane').find('fieldset').all('.income_variant_fieldset')[1] }
          
          it "should have proper cost item total cost and total" do 
            visit edit_offer_path(offer)
            page.find('.tab-content').first('.tab-pane').all('.total')[0].should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '1000')
            page.find('.tab-content').first('.tab-pane').all('.total')[1].should have_field('offer[quotes_attributes][0][cost_items_attributes][1][cost_item_total]', with: '2000')
          end

          it "should have proper total cost and total gain" do
            visit edit_offer_path(offer)
            page.should have_selector('td.quote_total_value', text: '3000')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '3000')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_gain td', text: '12000')    
          end

          describe "when changing iv number_of_participants field" do
            it "should update both cost item totals" do
              visit edit_offer_path(offer)
              iv1_box.fill_in('offer[quotes_attributes][0][income_variants_attributes][0][number_of_participants]', with: '20')
              iv1_box.click
              page.find('.tab-content').first('.tab-pane').all('.total')[0].should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '2000')
              page.find('.tab-content').first('.tab-pane').all('.total')[1].should have_field('offer[quotes_attributes][0][cost_items_attributes][1][cost_item_total]', with: '4000')
            end

            it "should have proper total cost and total gain" do
              visit edit_offer_path(offer)
              iv1_box.fill_in('offer[quotes_attributes][0][income_variants_attributes][0][number_of_participants]', with: '20')
              iv1_box.click
              page.should have_selector('td.quote_total_value', text: '6000')
              page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '6000')
              page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_gain td', text: '24000')     
            end
          end

          describe "when toggling income variants" do
            it "should update both cost item totals" do
              visit edit_offer_path(offer)
              iv2_box.click
              page.find('.tab-content').first('.tab-pane').all('.total')[0].should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '2000')
              page.find('.tab-content').first('.tab-pane').all('.total')[1].should have_field('offer[quotes_attributes][0][cost_items_attributes][1][cost_item_total]', with: '4000')
            end

            it "should have proper total cost" do
              visit edit_offer_path(offer)
              iv2_box.click
              page.should have_selector('td.quote_total_value', text: '6000')
              page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '6000')
              page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_gain td', text: '24000')     
            end
          end
        end

        describe "when changing quotes number of days", js: true do
          let!(:ci1) { FactoryGirl.create(:cost_item, quote: quote, single_cost: 100, factor_type: 'per_day') } # 100 per day
          let!(:ci2) { FactoryGirl.create(:cost_item, quote: quote, single_cost: 200, factor_type: 'per_day') } # 100 per day
          let!(:ci3) { FactoryGirl.create(:cost_item, quote: quote, single_cost: 300, factor_type: 'per_event') } # 200 per day

          it "should update two cost item totals" do
            visit edit_offer_path(offer)
            fill_in('offer_quotes_attributes_0_number_of_days', with: 5)
            page.find('.tab-content').click
            timeout(2) { page.find('.tab-content').click } 
            page.find('.tab-content').first('.tab-pane').all('.total')[0].should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '500' )
            page.find('.tab-content').first('.tab-pane').all('.total')[1].should have_field('offer[quotes_attributes][0][cost_items_attributes][1][cost_item_total]', with: '1000')
            page.find('.tab-content').first('.tab-pane').all('.total')[2].should have_field('offer[quotes_attributes][0][cost_items_attributes][2][cost_item_total]', with: '300' )
          end
          
          it "should have proper total cost" do
            visit edit_offer_path(offer)
            fill_in('offer_quotes_attributes_0_number_of_days', with: 5)            
            timeout(2) { page.find('.tab-content').click }
            page.should have_selector('td.quote_total_value', text: '1800')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '1800')    
          end
        end

        describe "changing per_ factors", js: true do
          let!(:ci1) { FactoryGirl.create(:cost_item, quote: quote, single_cost: 100, factor_type: 'per_day') } # 100 per day
          let!(:iv1) { FactoryGirl.create(:income_variant, quote: quote, currently_chosen: true) } # 10 participants

          it "should update cost items total and have proper total cost" do
            visit edit_offer_path(offer)
            page.select('daily', from: 'offer[quotes_attributes][0][cost_items_attributes][0][factor_type]')
            page.find('.tab-content').first('.tab-pane').first('.total').should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '300')
            page.should have_selector('td.quote_total_value', text: '300')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '300')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_gain td', text: '14700')  

            page.select('person', from: 'offer[quotes_attributes][0][cost_items_attributes][0][factor_type]')
            page.find('.tab-content').first('.tab-pane').first('.total').should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '1000')
            page.should have_selector('td.quote_total_value', text: '1000')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '1000')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_gain td', text: '14000')  

            page.select('globally', from: 'offer[quotes_attributes][0][cost_items_attributes][0][factor_type]')
            page.find('.tab-content').first('.tab-pane').first('.total').should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '100')
            page.should have_selector('td.quote_total_value', text: '100')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '100')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_gain td', text: '14900')              
          end
        end
      end
    end
  end
end

