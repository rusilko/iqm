$(function () {

  $( '.day_box, #available_segments' ).sortable({ connectWith: ".connectedSortable" }).disableSelection();

  $('.new_training input[type=checkbox]').click(function () {

    if ( $(this).is(':checked') ) {

      // get no of days
      var no_of_days = get_event_type_number_of_days($(this));
      console.log(no_of_days);
      // create proper amount of day boxes
      for(i=0;i<no_of_days;i++){
        $('form').find('.add_day_btn').click();
      }
      // enable associated segments for dragging


    } else {

      // remove associated segments from days if any

      // disable associated segments

    };


    //var checked_trainig_types = [];
    //checked_trainig_types = $(this).parents('.check_boxes').find('input[type=checkbox]:checked');

    // .each(function(index) {
    //   checked_trainig_types.push(parseInt($(this).val()));
    // });

    // $.each(checked_trainig_types, function() { 
    //   console.log($(this).parent().text()); 
    // });
   
    
    // Try loading segments with ajax, but for now we don't have many segments
    // checked_trainig_types.each(function(index) {
    //   // get training_type default segments from the server
    //   event_type_id = parseInt($(this).val());
    //   $.ajax({
    //     url: '/event_types/'+event_type_id+'/segments',
    //     success: function(data) {
    //       $('#segments').html(data);
    //       alert('Load was performed.');
    //     }
    //   });
    // });


  });


  // Add day box
  $('form').on('click', '.add_day_btn', function(event) {
    $(this).prev().append($(this).data('html'));
    var x = $(this).prev().find('ul:last');
    $(x).sortable( {
      connectWith: ".connectedSortable",
      receive: function( event, ui ) {
        var date = $(this).find('input').val();
        $('.add_training_segment_btn').trigger('click', [date, ui.item.attr('data-segment')]);
      }
    }).disableSelection();

    event.preventDefault();
  });

  // Remove day box
    $('form').on('click', '.remove_day_btn', function(event) {
      var b = $(this);
      b.closest('ul').remove();                           
      event.preventDefault();
  });

  // Add TrainingSegment fields
  $('form').on('click', '.add_training_segment_btn', function(event, date, segment_id) {
    console.log(date+", "+segment_id);
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    var segment_id_field = $('input[id*="'+time+'_segment_id"]');
    var start_time_field = $('input[id*="'+time+'_start_time"]');
    segment_id_field.val(segment_id);
    start_time_field.val(date);   
    event.preventDefault();
  });    

  // Datepickers
  $('form').on('click', 'input[name*="day_date"], input[name*="start_time"]', function(event) {
    $(this).datepicker({
        dateFormat: "yy-mm-dd"
    }).focus();
  });

  function get_event_type_number_of_days(obj){
    return 3;
  }

});