jQuery(function() {
  
  // Remove Income Variant box
  $('form').on('click', '.remove_variant', function(event) {
    //set _destroy field value, so variant is permanently removed on form submit
    $(this).prev('input[type=hidden]').val('1');
    //hide the entire variant box
    $(this).closest('fieldset').hide();
    //uncheck checkbox
    $(this).siblings('.hidden').find('input[type="checkbox"]').prop('checked', false);
    //remove "chosen" class so update_cost_item_total function may recalculate properly
    $(this).closest('fieldset').removeClass("chosen");
        
    //Update per_person item_costs totals (to 0)
    $(this).closest('fieldset').siblings('table').find('td.factor_type select').each(function(){
      if ($(this).val() == "per_person") {
        update_cost_item_total($(this).closest('td').siblings('.total'));
        //this adds unnecessary operations, 
        //we could as well just reset per_person totals to 0 and call sum_up_cost_cells
        //so this is a potential place to work on performance.
      }
    });

    // find and reset QUOTE TOTAL income cell to 0
    quote_total_income = $(this).closest('fieldset').siblings('table').find('tr.total_income td:last');
    quote_total_income.text(0);

    // find and update QUOTE TOTAL gain cell
    quote_total_gain = $(this).closest('fieldset').siblings('table').find('tr.total_gain td:last');
    cost_sum = $(this).closest('fieldset').siblings('table').find('tr.total_cost td:last').text();
    quote_total_gain.text(-cost_sum);

    event.stopPropagation(); // stop propagation so income variant toggling is not fired
                             // as this would add "chosen" class to the fieldset again
    event.preventDefault();
  });  

  // Add an Income Variant box
  $('form').on('click', '.add_variant', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    event.preventDefault();
  });

  // Income Variants toggling
  $('body').on('click change', '.income_variant_fieldset', function(event) {
    //Toggle income variant fieldset only on click
    if (event.type == "click") {
      hidden_checkbox = $(this).find('input[type="checkbox"]');
      // uncheck currently checked checkbox and remove greyish class
      $(this).siblings().find('input[type="checkbox"][checked="checked"]').prop('checked', false);
      $(this).siblings('.income_variant_fieldset').removeClass("chosen");
      // check new checkbox (the one in the clicked fieldset)
      hidden_checkbox.prop('checked', true);
      if(hidden_checkbox.is(':checked')) { $(this).addClass("chosen"); }
    }

    //Update per_person item_costs totals on click or on input change
    $(this).siblings('table').find('td.factor_type select').each(function(){
      if ($(this).val() == "per_person") {
        update_cost_item_total($(this).closest('td').siblings('.total'));
      }
    });

    // find and update QUOTE TOTAL income cell
    number_of_participants = $(this).find('input[name*="number_of_participants"]').prop('value'); 
    price_per_participant  = $(this).find('input[name*="price_per_participant"]').prop('value'); 
    quote_total_income = $(this).siblings('table').find('tr.total_income td:last');
    quote_total_income.text(number_of_participants*price_per_participant);

    // find and update QUOTE TOTAL gain cell
    income = $(this).siblings('table').find('tr.total_income td:last').text();
    quote_total_gain = $(this).siblings('table').find('tr.total_gain td:last');
    cost_sum = $(this).siblings('table').find('tr.total_cost td:last').text();
    quote_total_gain.text(income - cost_sum);
  });


  // Remove Quote tab
  $('form').on('click', '.remove_quote', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('.tab-pane').hide();
    var tab_id = $(this).prop('id')+'_tab';
    $('#'+tab_id).hide();
    $('#quote_tabs').find('a[style!="display: none; "][class!="add_quote_from_tab_bar"]').first().tab('show');
    event.preventDefault();
  });

  // Add a Quote tab
  $('form').on('click', '.add_quote', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    $('#quote_tabs a:last').before($(this).data('tab').replace(regexp, time));
    var new_tab_id = 'q_'+time+'_tab';
    $('#quote_tabs').find('a[id="'+new_tab_id+'"]').tab('show');
    event.preventDefault();
  });

  // Simulate real "+ Add Quote" button click
  $('.add_quote_top_btn').click( function() {
      $(".add_quote").click();
    });

  // Add Cost Item row
  $('form').on('click', '.add_cost_item', function(event) {
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    //console.log($(this).siblings('table:last').find('tbody:last'));
    $(this).siblings('table:last').find('tr:last').before($(this).data('fields').replace(regexp, time));
    event.preventDefault();
  });

  // Remove Cost Item row
  $('form').on('click', '.remove_cost_item', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('tr').hide();
    event.preventDefault();
  }); 

  // Function that sums up cost_items total cells and returns the sum
  function sum_up_cost_cells(cost_cell){
    sum = 0;
    cost_cell.parents('table').find('tr[style!="display: none; "]').each( function(){
      td = $(this).find('td.total');
      if (td.length > 0) sum+= parseFloat(td.find('input').val());
    });
    return sum;
  }

  // Function that updates one cost_items total, cost_cell is the cost_item total cell to be updated
  function update_cost_item_total(cost_cell){
    single_cost = cost_cell.siblings('.single_cost').find('input').prop('value');
    number_of_days = cost_cell.closest('table').siblings('.quote_field').find('input[name*="number_of_days"]').prop('value');
    chosen_fieldset = cost_cell.closest('table').siblings('fieldset.chosen');
    if (chosen_fieldset.length > 0) { 
      number_of_participants = chosen_fieldset.find('input[name*="number_of_participants"]').prop('value');      
    } else {
      number_of_participants = 0;      
    }
    factor_type = cost_cell.siblings('.factor_type').find('select').prop('value');
    switch(factor_type) {
      case "per_day":
        factor = number_of_days;
        break;
      case "per_person":
        factor = number_of_participants;
        break;
      case "per_event":
        factor = 1;
        break;
      default:
        factor = 0;
        break;
      }
    // update cost_item total cell  
    cost_cell.find('input').val(single_cost*factor);
    // find and update QUOTE TOTAL cost cells
    quote_total_cost_secondary = cost_cell.parents('tr').siblings(':last').children('td:last');
    quote_total_cost_primary = cost_cell.parents('table').siblings('table').find('tr.total_cost td:last');
    cost_sum = sum_up_cost_cells(cost_cell);
    quote_total_cost_secondary.text(cost_sum);
    quote_total_cost_primary.text(cost_sum);

    // find and update QUOTE TOTAL gain cell
    income = cost_cell.parents('table').siblings('table').find('tr.total_income td:last').text();
    quote_total_gain = cost_cell.parents('table').siblings('table').find('tr.total_gain td:last');
    quote_total_gain.text(income - cost_sum);
  };

  // Update cost_item_total when single cost or factor_type gets changed
  $('form').on('click change', 'input[name*="single_cost"], select[name*="factor_type"], td.trashbin', function (){
    update_cost_item_total($(this).closest('td').siblings('.total'));
  });

  // Update per_day cost_items totals when NUMBER OF DAYS gets changed
  $('form').on('click change', 'input[name*="number_of_days"]', function (){
    $(this).closest('div.quote_field').siblings('table').find('td.factor_type select').each( function(){
      if ($(this).val() == "per_day") {
        update_cost_item_total($(this).closest('td').siblings('.total'));
      }
    });
  });

});