jQuery(function() {

  // Calendar
  $('form').on('click', 'input[name*="date"]', function(event) {
    $(this).datepicker({
        dateFormat: "yy-mm-dd"
    }).focus();
  });

 //  // Adding and removing Participants

 //  // Add Participant row
 //  $('form').on('click', '.add_participant_btn', function(event) {
 //    time = new Date().getTime();
 //    regexp = new RegExp($(this).data('id'), 'g');
 //    // Add participant association row
 //    console.log($(this).data('fields'));
 //    //$(this).siblings('table:last').find('tr:last').after($(this).data('fields').replace(regexp, time));
 //    $(this).siblings('table:last').find('tbody').append($(this).data('fields').replace(regexp, time));
 //    event.preventDefault();
 //  });

 // // Remove Participant row
 //  $('form').on('click', '.remove_event_participation_btn', function(event) {
 //    // mark destroy field as 1
 //    console.log($(this));
 //    $(this).prev('input[type=hidden]').val('1');
 //    // hide ci row
 //    $(this).closest('tr').hide();
 //    event.preventDefault();
 //  }); 

});