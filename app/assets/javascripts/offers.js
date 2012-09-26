jQuery(function() {

// Adding and removing Quote tabs and quote tab-panes

  // Add a Quote tab and a Quote tab-pane
  $('#add_quote_btn').click( function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    // add tab-pane
    $('.tab-content').append($(this).data('fields').replace(regexp, time));
    // add tab 
    $('#quote_tabs a:last').before($(this).data('tab').replace(regexp, time));
    // show freshly added tab-pane
    $('#quote_tabs').find('a[id="q_'+time+'_tab"]').tab('show');
    event.preventDefault();
  });

  // Simulate "+ Add Quote" button click
  $('#add_quote_top_btn').click( function() {
    $("#add_quote_btn").click();
  });

  // Remove Quote tab and a Quote tab-pane
  $('form').on('click', '.remove_quote_btn', function(event) {
    // set hidden field so quote is removed from db after offer update
    $(this).prev('input[type=hidden]').val('1');
    // hide tab-pane
    $(this).closest('.tab-pane').hide();
    // hide tab
    var tab_id = $(this).prop('id')+'_tab';
    $('#'+tab_id).hide();
    // show first nothidden tab
    $('#quote_tabs').find('a[style!="display: none; "]:first').tab('show');
    event.preventDefault();
  });

// Adding, removing and toggling Income Variants
  
  // Remove an Income Variant box
  $('form').on('click', '.remove_variant_btn', function(event) {
    // set _destroy field value, so variant is removed from db on form submit
    $(this).prev('input[type=hidden]').val('1');
    // hide the entire variant box
    $(this).closest('fieldset').hide();
    // uncheck checkbox
    $(this).siblings('.hidden').find('input[type="checkbox"]').prop('checked', false);
    // remove "chosen" class so update_cost_item_total function may recalculate properly
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
  $('form').on('click', '.add_variant_btn', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    // Add iv box
    $(this).before($(this).data('fields').replace(regexp, time));
    event.preventDefault();
  });

  // Income Variants toggling
  $('body').on('click change', '.income_variant_fieldset', function(event) {
    // Toggle income variant fieldset only on click
    if (event.type == "click") {
      hidden_checkbox = $(this).find('input[type="checkbox"]');
      // uncheck all currently checked checboxes (should be 1)
      $(this).siblings().find('input[type="checkbox"]').prop('checked', false);
      // remove greyish class
      $(this).siblings('.income_variant_fieldset').removeClass("chosen");
      // check new checkbox (the one in the clicked fieldset)
      hidden_checkbox.prop('checked', true);
      // add greyish class if checking was succesful
      if(hidden_checkbox.is(':checked')) { $(this).addClass("chosen"); }
    }

    // Find and update QUOTE TOTAL income value
    number_of_participants = $(this).find('input[name*="number_of_participants"]').prop('value'); 
    price_per_participant  = $(this).find('input[name*="price_per_participant"]').prop('value'); 
    quote_total_income =     $(this).siblings('table').find('tr.total_income td:last');
    quote_total_income.text(number_of_participants*price_per_participant);

    //Update per_person item_costs totals on click or on input change
    $(this).siblings('table').find('td.factor_type select').each(function(){
      if ($(this).val() == "per_person") {
        update_cost_item_total($(this).closest('td').siblings('.total'));
      }
    });

    // find and update QUOTE TOTAL gain cell
    income = $(this).siblings('table').find('tr.total_income td:last').text();
    quote_total_gain = $(this).siblings('table').find('tr.total_gain td:last');
    cost_sum = $(this).siblings('table').find('tr.total_cost td:last').text();
    quote_total_gain.text(income - cost_sum);
  });

// Adding, removing and toggling Cost Items

  // Add Cost Item row
  $('form').on('click', '.add_cost_item_btn', function(event) {
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    // Add ci row
    $(this).siblings('table:last').find('tr:last').before($(this).data('fields').replace(regexp, time));
    event.preventDefault();
  });

  // Remove Cost Item row
  $('form').on('click', '.remove_cost_item_btn', function(event) {
    // mark destroy field as 1
    $(this).prev('input[type=hidden]').val('1');
    // hide ci row
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