jQuery(function() {
  // globals
  var number_of_clients = parseInt($('.participants_table_wrapper').find('tr:last td.no').html());
  var customer_type = "Company";
  // Increment index in add client button

  // Adding and removing Clients

  // Add Client row
  $('form').on('click', '.add_seat_btn', function(event) {
    number_of_clients += 1;
    time = new Date().getTime();
    regexp1 = new RegExp($(this).data('id'), 'g');
    regexp2 = new RegExp('<td class="no">.</td>', 'g');
    var new_fields = $(this).data('fields').replace(regexp1, time);
    new_fields = new_fields.replace(regexp2, '<td class="no">'+number_of_clients+'</td>');
    $(this).siblings('table:last').find('tbody').append(new_fields);
    event.preventDefault();
  });

 // Remove Client row
  $('form').on('click', '.remove_seat_btn', function(event) {
    number_of_clients -= 1;
    // mark destroy field as 1
    $(this).prev('input[type=hidden]').val('1');
    // hide client row
    $(this).closest('tr').hide();
    decrement_indexes($(this).parents('tr'));
    event.preventDefault();
  });

  // Add Address box
  $('form').on('click', '.add_address_btn', function(event) {
    if( !$(this).hasClass('disabled') ){
      var regexp, time;
      time = new Date().getTime();
      regexp = new RegExp($(this).data('id'), 'g');
      $(this).before($(this).data('fields').replace(regexp, time));
      $(this).siblings('.address_box.billing').first().find('p').html("Adres rozliczeniowy: ");
      $(this).siblings('.address_box.billing').first().find('input[name*="default_sending"]').val(false);
      $(this).addClass('disabled');
      //$(this).hide();
    }
    event.preventDefault();
  });

  // Remove Address box
  $('form').on('click', '.remove_address_btn', function(event) {
    // mark destroy field as 1
    $(this).prev('input[type=hidden]').val('1');
    // hide address div
    $(this).closest('div').hide();
    $(this).parent().next('.add_address_btn').removeClass('disabled');
    //$(this).parent().next('.add_address_btn').show();
    $(this).parent().siblings('.address_box').first().find('p').html("Adres rozliczeniowy i korespondencyjny: ");
    $(this).parent().siblings('.address_box').first().find('input[name*="default_sending"]').val(true);
    event.preventDefault();
  });

  // Add Coordinator box
  $('form').on('click', '.add_coordinator_btn', function(event) {
    if( !$(this).hasClass('disabled') ){
      var regexp, time;
      time = new Date().getTime();
      regexp = new RegExp($(this).data('id'), 'g');
      $(this).before($(this).data('fields').replace(regexp, time));
      $(this).addClass('disabled');
      //$(this).hide();
    }
    event.preventDefault();
  });

  // Remove Coordinator box
  $('form').on('click', '.remove_coordinator_btn', function(event) {
    // mark destroy field as 1
    $(this).prev('input[type=hidden]').val('1');
    // hide address div
    if(customer_type=="Company"){
      $(this).parent().next('.add_coordinator_btn').removeClass('disabled');
    }
    $(this).closest('div').remove();
    //$(this).parent().next('.add_coordinator_btn').show();
    event.preventDefault();
  });

  // Copy client <--> customer data
  $('form').on('change keyup', 'input[name*="name"]', function(event){
    if(customer_type=="Client") { // this is order customer_type field
      regexp = /customer/
      current_input_name = $(this).attr("name");
      if( regexp.test(current_input_name) ){
        copy_person_attribute("name","customer","participants");
      }else{
        copy_person_attribute("name","participants_table","customer");
      }
    }
  });

  $('form').on('change keyup', 'input[name*="phone_1"]', function(event){
    if(customer_type=="Client") { // this is order customer_type field
      regexp = /customer/
      current_input_name = $(this).attr("name");
      if( regexp.test(current_input_name) ){
        copy_person_attribute("phone_1","customer","participants");
      }else{
        copy_person_attribute("phone_1","participants_table","customer");
      }
    }
  });


  $('form').on('change keyup', 'input[name*="email"]', function(event){
    if(customer_type=="Client") { // this is order customer_type field
      regexp = /customer/
      current_input_name = $(this).attr("name");
      if( regexp.test(current_input_name) ){
        copy_person_attribute("email","customer","participants_table");
      }else{
        copy_person_attribute("email","participants_table","customer");
      }
    }
  });

  // Toggle Customer type
 $('form').on('click', 'input[name*="customer_type"]', function(event){
    customer_type = $(this).val();
    if(customer_type == "Client") {
      //copy client data to customer data
      // copy_person_name("participants","customer");
      // copy_person_tel("participants","customer");
      copy_person_attribute("name","participants_table","customer");
      copy_person_attribute("email","participants_table","customer");
      copy_person_attribute("phone_1","participants_table","customer");
      $('.customer_wrapper').find('input[name*="phone_1"]').prop('disabled', true);
      $('.customer_wrapper').find('input[name*="name"]').prop('disabled', true);
      $('.customer_wrapper').find('input[name*="email"]').prop('disabled', true);

      $('.coordinator_wrapper').find('.remove_coordinator_btn').click();
      $('.coordinator_wrapper').find('.add_coordinator_btn').addClass('disabled');

      //$('.coordinator_wrapper').find('.add_coordinator_btn').hide();
    }
    else if (customer_type == "Company") {
      $('.customer_wrapper').find('input').prop('disabled', false);
      $('.coordinator_wrapper').find('.add_coordinator_btn').removeClass('disabled');
      //$('.coordinator_wrapper').find('.add_coordinator_btn').show();
    }
  });

 // Functions

  function copy_person_attribute(attr, from,to){
    var source      = $('.'+from+'_wrapper').find('input[name*="'+attr+'"]').first();
    var destination = $('.'+ to +'_wrapper').find('input[name*="'+attr+'"]').first();
    destination.val(source.val());
  }

  function decrement_indexes(removed_row){
    removed_row.nextAll('tr').each( function(){
      var index_cell = $(this).find('td.no');
      current_value = parseInt(index_cell.html());
      index_cell.html(current_value-1);
    });
  }


});