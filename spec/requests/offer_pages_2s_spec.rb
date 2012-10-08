require 'spec_helper'

describe "OfferPages 2", browser_required: true do
  
  subject { page }
  before  { 3.times { FactoryGirl.create(:offer) } }

  describe "edit offer OfferPages" do  # or a new offer page for that matter, I will just test on edit page
    let(:offer)   { FactoryGirl.create(:offer) }

    describe "when manipulating income variants" do
      let!(:quote)      { FactoryGirl.create(:quote, name: "kalk1", offer: offer) }
      let(:add_iv_btn)  { page.find('.tab-content').first('.tab-pane').find('.add_variant_btn') }
      let(:rmv_iv_btn)  { page.find('.tab-content').first('.tab-pane').find('fieldset').first('.income_variant_fieldset').find('.remove_variant_btn') }
      before            { visit edit_offer_path(offer) }

      describe "calucating total income and gain", js: true do
        let!(:iv1) { FactoryGirl.create(:income_variant, number_of_participants: 10, price_per_participant: 1000, currently_chosen: true, quote: quote) }
        let!(:iv2) { FactoryGirl.create(:income_variant, number_of_participants: 15, price_per_participant: 1000, quote: quote) }
        let!(:ci1) { FactoryGirl.create(:cost_item, single_cost: 100, factor_type: 'per_event', quote: quote) }
        let(:iv1_box) { page.find('.tab-content').first('.tab-pane').find('fieldset').all('.income_variant_fieldset')[0] }
        let(:iv2_box) { page.find('.tab-content').first('.tab-pane').find('fieldset').all('.income_variant_fieldset')[1] }
        before do 
          visit edit_offer_path(offer)
        end

        it "should change value upon changing values of fields inside iv box" do
          iv1_box.fill_in('offer[quotes_attributes][0][income_variants_attributes][0][number_of_participants]', with: '10')
          iv1_box.click
          page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_income td', text: '10000.00')

          iv1_box.fill_in('offer[quotes_attributes][0][income_variants_attributes][0][price_per_participant]', with: '2000.00')
          iv1_box.click
          page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_income td', text: '40000.00')
        end

      end
    end

    describe "when manipulating cost items" do
      let!(:quote)      { FactoryGirl.create(:quote, number_of_days: 3, name: "kalk1", offer: offer) }
      let(:add_ci_btn)  { page.find('.tab-content').first('.tab-pane').find('.add_cost_item_btn') }
      let(:rmv_ci_btn)  { page.find('.tab-content').first('.tab-pane').first('.remove_cost_item_btn') }
      before            { visit edit_offer_path(offer) }

      describe "calucating cost totals" do
        describe "when changing income variants", js: true do
          let!(:ci1) { FactoryGirl.create(:cost_item, quote: quote, single_cost: 100, factor_type: 'per_person') } # 100 per person
          let!(:ci2) { FactoryGirl.create(:cost_item, quote: quote, single_cost: 200, factor_type: 'per_person') } # 200 per person
          let!(:iv1) { FactoryGirl.create(:income_variant, quote: quote, currently_chosen: true) } # 10 participants
          let!(:iv2) { FactoryGirl.create(:income_variant, quote: quote, currently_chosen: false, number_of_participants: 20) } # 20 participants
          let(:iv1_box) { page.find('.tab-content').first('.tab-pane').find('fieldset').all('.income_variant_fieldset')[0] }
          let(:iv2_box) { page.find('.tab-content').first('.tab-pane').find('fieldset').all('.income_variant_fieldset')[1] }

          describe "when changing iv number_of_participants field" do
            it "should update both cost item totals" do
              visit edit_offer_path(offer)
              iv1_box.fill_in('offer[quotes_attributes][0][income_variants_attributes][0][number_of_participants]', with: '20')
              iv1_box.click
              page.find('.tab-content').first('.tab-pane').all('.total')[0].should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '2000.00')
              page.find('.tab-content').first('.tab-pane').all('.total')[1].should have_field('offer[quotes_attributes][0][cost_items_attributes][1][cost_item_total]', with: '4000.00')

            end

            it "should have proper total cost and total gain" do
              visit edit_offer_path(offer)
              iv1_box.fill_in('offer[quotes_attributes][0][income_variants_attributes][0][number_of_participants]', with: '20')
              iv1_box.click
              page.should have_selector('td.quote_total_value', text: '6000.00')
              page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '6000.00')
              page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_gain td', text: '24000.00')     
            end
          end

          describe "when toggling income variants" do
            it "should update both cost item totals" do
              visit edit_offer_path(offer)
              iv2_box.click
              page.find('.tab-content').first('.tab-pane').all('.total')[0].should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '2000.00')
              page.find('.tab-content').first('.tab-pane').all('.total')[1].should have_field('offer[quotes_attributes][0][cost_items_attributes][1][cost_item_total]', with: '4000.00')
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
            page.find('.tab-content').first('.tab-pane').all('.total')[0].should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '500.00' )
            page.find('.tab-content').first('.tab-pane').all('.total')[1].should have_field('offer[quotes_attributes][0][cost_items_attributes][1][cost_item_total]', with: '1000.00')
            page.find('.tab-content').first('.tab-pane').all('.total')[2].should have_field('offer[quotes_attributes][0][cost_items_attributes][2][cost_item_total]', with: '300.00' )
          end
          
          it "should have proper total cost" do
            visit edit_offer_path(offer)
            fill_in('offer_quotes_attributes_0_number_of_days', with: 5)            
            page.find('.tab-content').click
            page.should have_selector('td.quote_total_value', text: '1800.00')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '1800.00')    
          end
        end

        describe "changing per_ factors", js: true do
          let!(:ci1) { FactoryGirl.create(:cost_item, quote: quote, single_cost: 100, factor_type: 'per_day') } # 100 per day
          let!(:iv1) { FactoryGirl.create(:income_variant, quote: quote, currently_chosen: true) } # 10 participants

          it "should update cost items total and have proper total cost" do
            visit edit_offer_path(offer)
            page.select('daily', from: 'offer[quotes_attributes][0][cost_items_attributes][0][factor_type]')
            page.find('.tab-content').first('.tab-pane').first('.total').should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '300.00')
            page.should have_selector('td.quote_total_value', text: '300.00')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '300.00')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_gain td', text: '14700.00')  

            page.select('person', from: 'offer[quotes_attributes][0][cost_items_attributes][0][factor_type]')
            page.find('.tab-content').first('.tab-pane').first('.total').should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '1000.00')
            page.should have_selector('td.quote_total_value', text: '1000.00')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '1000.00')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_gain td', text: '14000.00')  

            page.select('globally', from: 'offer[quotes_attributes][0][cost_items_attributes][0][factor_type]')
            page.find('.tab-content').first('.tab-pane').first('.total').should have_field('offer[quotes_attributes][0][cost_items_attributes][0][cost_item_total]', with: '100.00')
            page.should have_selector('td.quote_total_value', text: '100.00')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_cost td', text: '100.00')
            page.find('.tab-content').first('.tab-pane').should have_selector('tr.total_gain td', text: '14900.00')              
          end
        end
      end
    end
  end
end

