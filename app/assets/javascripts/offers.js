jQuery(function() {

// Monitoring changes and update cost items totals and quote totals

  // Update per_day cost_items totals when number of days gets changed
  $('form').on('click change', 'input[name*="number_of_days"]', function(){
    var i = $(this);
    update_cost_item_totals(i.closest('fieldset'), "per_day", i.prop('value'));
  });

  // Update quote total income when income vat changes
  $('form').on('change', '.quote_field select[name*="vat"]', function(){
    var i = $(this);
    // simulate a click on current income variant
    $('.income_variant_fieldset.chosen input[name*="number_of_participants"]').click();
  });

  // Update quote total costs when any of the cost items totals changes
  $('form').on('click change', 'td.total input[name*="cost_item_total"], td.total_brutto input[name*="cost_item_total"]', function(){
    // console.log("triggering on change of cost_item_total"); 
    var i = $(this);
    update_quote_total_cost(i.closest('fieldset'));
  });

  // Update per_person cost_items and quote total income when currently chosen income variant fields changes
  $('form').on('click change', 'input[name*="number_of_participants"], input[name=*"price_per_participant"]', function(){
    var hidden_checkbox        = $(this).closest('fieldset').find('input[type="checkbox"]');
    var number_of_participants = $(this).closest('fieldset').find('input[name*="number_of_participants"]').prop('value'); 
    var price_per_participant  = $(this).closest('fieldset').find('input[name*="price_per_participant"]' ).prop('value');
    var vat_type = $(this).parents('fieldset').closest('fieldset').find('select[name*="vat"]').prop('value');
    var vat = get_vat_value_from(vat_type);
    //console.log(vat_type);
    // update per_person item_costs totals to new value
    update_cost_item_totals( $(this).parents('fieldset').parent('fieldset'), "per_person", number_of_participants );
    // update quote total income
    update_quote_total_income( $(this).parents('fieldset').parent('fieldset'), number_of_participants*price_per_participant, vat);
  });

  // Update quote total gain when quote total cost or quote total income changes
  $('form').on('click change', 'table.totals tr.total_cost td, table.totals tr.total_income td', function(){
    //console.log("triggered by change on"+$(this).parent().prop('class'));
    var cost_n      = $(this).parents('table').find('tr.total_cost td.netto').text();
    var income_n    = $(this).parents('table').find('tr.total_income td.netto').text();
    var gain_cell_n = $(this).parents('table').find('tr.total_gain td.netto');
    gain_cell_n.text((parseFloat(income_n) - parseFloat(cost_n)).toFixed(2)).change();

    var cost_b      = $(this).parents('table').find('tr.total_cost td.brutto').text();
    var income_b    = $(this).parents('table').find('tr.total_income td.brutto').text();
    var gain_cell_b = $(this).parents('table').find('tr.total_gain td.brutto');
    gain_cell_b.text((parseFloat(income_b) - parseFloat(cost_b)).toFixed(2)).change();
    // console.log("  update gain: "+(income - cost));
   });

  // Update cost_item_total when single cost or factor_type or vat gets changed
  // TO-DO cannot be click and change on selects - it runs twice!!
  $('form').on('click change', 'input[name*="single_cost"], select[name*="factor_type"], .cost_items_table select[name*="vat"], td.trashbin', function (){
    var target_cell_n   = $(this).closest('tr').find('.total');
    var target_cell_b   = $(this).closest('tr').find('.total_brutto');
    var factor_type     = $(this).closest('tr').find('.factor_type').find('select').prop('value');
    var vat_type        = $(this).closest('tr').find('.vat').find('select').prop('value');
    var single_cost     = $(this).closest('tr').find('.single_cost').find('input').prop('value');
    var number_of_days  = $(this).closest('fieldset').find('input[name*="number_of_days"]').prop('value'); 
    var chosen_fieldset = $(this).closest('fieldset').find('fieldset.chosen');
    var factor;
    if (chosen_fieldset.length > 0) { 
      var number_of_participants = chosen_fieldset.find('input[name*="number_of_participants"]').prop('value');      
    } else {
      var number_of_participants = 0;      
    }
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
    var vat = get_vat_value_from(vat_type);
    update_cost_item_total(target_cell_n, target_cell_b, factor, single_cost, vat);
  });

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

// Adding and removing Cost Items

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

// Adding, removing and toggling Income Variants

  // Add an Income Variant box
  $('form').on('click', '.add_variant_btn', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    // Add iv box
    $(this).before($(this).data('fields').replace(regexp, time));
    event.preventDefault();
  });

  // Remove an Income Variant box
  $('form').on('click', '.remove_variant_btn', function(event) {
    var b = $(this);
    // set _destroy field value, so variant is removed from db on form submit
    b.prev('input[type=hidden]').val('1');
    // hide the entire variant box
    b.closest('fieldset').hide();
    // check if we are removing a currently chosen variant
    var was_checked = b.siblings('.hidden').find('input[type="checkbox"]').prop('checked');
    // uncheck checkbox
    b.siblings('.hidden').find('input[type="checkbox"]').prop('checked', false);
    // remove "chosen" class so update_cost_item_total function may recalculate properly
    b.closest('fieldset').removeClass("chosen");    
    // if this iv was currently chosen, we need to update totals
    if (was_checked) {
      // update per_person item_costs totals (to 0)
      update_cost_item_totals(b.parents('fieldset').closest('fieldset'), "per_person", 0);
      // update quote total income
      update_quote_total_income(b.parents('fieldset').closest('fieldset'), 0, 0)
    }
    // stop propagation so income variant toggling is not fired
    // as this would add "chosen" class to the fieldset again
    event.stopPropagation();                             
    event.preventDefault();
  });  

  // Income Variants toggling
  $('form').on('click', '.income_variant_fieldset', function(event) {
    var hidden_checkbox = $(this).find('input[type="checkbox"]');
    var number_of_participants = $(this).find('input[name*="number_of_participants"]').prop('value'); 
    var price_per_participant  = $(this).find('input[name*="price_per_participant"]').prop('value');
    var vat_type = $(this).parent('fieldset').closest('fieldset').find('select[name*="vat"]').prop('value');
    var vat = get_vat_value_from(vat_type);
    //console.log(vat);
    // only if we click NOT currently chosen field
    if(!hidden_checkbox.prop('checked')){
      // uncheck all currently checked checboxes (should be exactly 1)
      $(this).siblings().find('input[type="checkbox"]').prop('checked', false);
      // remove greyish class
      $(this).siblings('.income_variant_fieldset').removeClass("chosen");
      // check new checkbox (the one in the clicked fieldset)
      hidden_checkbox.prop('checked', true);
      // if checking was succesful
      if(hidden_checkbox.is(':checked')) {
        // add greyish class 
        $(this).addClass("chosen");
        // update per_person item_costs totals to new value
        update_cost_item_totals( $(this).parent('fieldset'), "per_person", number_of_participants );
        // update quote total income
        update_quote_total_income( $(this).parent('fieldset'), number_of_participants*price_per_participant, vat);
      }
    }
  });

// Other

  $('form').on('click', 'input[name*="event_date"]', function(event) {
    $(this).datepicker({
        dateFormat: "yy-mm-dd"
    }).focus();
  });

// Helper functions

  // Function that updates several cost items totals based on factor type
  function update_cost_item_totals(current_fieldset, factor_type, factor_value) {
    // console.log("update_cost_item_totals("+factor_type, factor_value+")");
    current_fieldset.children('table.cost_items_table').find('td.factor_type select').each( function(){
      if ($(this).val() == factor_type) {
        var target_cell_n = $(this).closest('td').siblings('.total');
        var target_cell_b = $(this).closest('td').siblings('.total_brutto');
        var price_value   = $(this).closest('td').siblings('.single_cost').find('input').prop('value');
        var vat_type      = $(this).closest('td').siblings('.vat').find('select').prop('value');
        var vat = get_vat_value_from(vat_type);
        update_cost_item_total(target_cell_n, target_cell_b, factor_value, price_value, vat)
      }
    });
  }

  // Function that updates particular cost item total specified by target_cell
  function update_cost_item_total(target_cell_n, target_cell_b, factor_value, price_value, vat_value){
    //console.log("update_cost_item_total("+factor_value, price_value, vat_value+")");
    var inp_n = target_cell_n.find('input');
    inp_n.prop('disabled', false); // we need to enable this field to properly trigger change event 
    inp_n.val((price_value*factor_value).toFixed(2).toLocaleString()).change(); // need change here to imitate browser change
    inp_n.prop('disabled', true);  // lets disable it again so noone changes it accidentaly 

    var inp_b = target_cell_b.find('input');
    inp_b.prop('disabled', false); // we need to enable this field to properly trigger change event 
    inp_b.val((price_value*factor_value*vat_value).toFixed(2).toLocaleString()).change(); // need change here to imitate browser change
    inp_b.prop('disabled', true);  // lets disable it again so noone changes it accidentaly 
  }

  // Function that updates quote total costs in current fieldset i.e. currently selected tab
  function update_quote_total_cost(current_fieldset){
    // console.log("update_quote_total_cost("+current_fieldset+")");
    // add all cost items total and update both places with total cost
    var quote_total_cost_n_cell_top      = current_fieldset.find('table.totals tr.total_cost td.netto')
    var quote_total_cost_b_cell_top      = current_fieldset.find('table.totals tr.total_cost td.brutto')
    var quote_total_cost_n_cell_bottom = current_fieldset.find('table.cost_items_table tr:last td.quote_total_value');
    var quote_total_cost_b_cell_bottom = current_fieldset.find('table.cost_items_table tr:last td.quote_total_brutto_value');
    var netto_costs_sum  = sum_up_cost_cells(current_fieldset,"netto");
    var brutto_costs_sum = sum_up_cost_cells(current_fieldset,"brutto");
    quote_total_cost_n_cell_top.text( netto_costs_sum.toFixed(2) ).change();
    quote_total_cost_b_cell_top.text( brutto_costs_sum.toFixed(2) ).change();
    quote_total_cost_n_cell_bottom.text( netto_costs_sum.toFixed(2)  ).change();
    quote_total_cost_b_cell_bottom.text( brutto_costs_sum.toFixed(2) ).change();
  }

  // Function that updates quote total income in current fieldset i.e. currently selected tab
  function update_quote_total_income(current_fieldset, income_value, vat_value){
    // console.log("i ve been called with ("+current_fieldset+" "+income_value+")");
    var iv_n = income_value;
    var iv_b = iv_n * vat_value;
    var quote_total_income_n_cell = current_fieldset.find('table.totals tr.total_income td.netto')    
    var quote_total_income_b_cell = current_fieldset.find('table.totals tr.total_income td.brutto')    
    quote_total_income_n_cell.text( iv_n.toFixed(2) ).change();
    quote_total_income_b_cell.text( iv_b.toFixed(2) ).change();
  }

  // Function that sums up cost_items total cells and returns the sum
  function sum_up_cost_cells(current_fieldset, type){
    var sum = 0;
    switch(type) {
      case "netto":
        var cell = 'td.total';
        break;
      case "brutto":
        var cell = 'td.total_brutto';
        break;
    }
    current_fieldset.find('table.cost_items_table tr[style!="display: none; "]').each( function(){
      var td = $(this).find(cell);
      if (td.length > 0) sum+= parseFloat(td.find('input').val());
    });
    return sum;
  }

  function get_vat_value_from(vat){
    switch(vat) {
      case "zw":
        return 1;
        break;
      case "0":
        return 1;
        break;
      case "8":
        return 1.08;
        break;
      case "23":
        return 1.23;
        break;
      default:
        return 1;
        break
    }
  }
});