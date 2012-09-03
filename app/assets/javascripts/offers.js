jQuery(function() {
  
  // Remove Income Variant box
  $('form').on('click', '.remove_variant', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('fieldset').hide();
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

  // Remove Quote tab
  $('form').on('click', '.remove_quote', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('.tab-pane').hide();
    var tab_id = $(this).attr('id')+'_tab';
    $('#'+tab_id).hide();
    //console.log($('#quote_tabs').find('a[style!="display: none; "]'));//.tab('show');
    $('#quote_tabs').find('a[style!="display: none; "][class!="add_quote_from_tab_bar"]').first().tab('show');
    //console.log($('#quote_tabs').find('li.active').prev().length);
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
  })

  // Button to simulate real "+ Add Quote" button click
  $('.add_quote_top_btn').click( function() {
      $(".add_quote").click();
    });

  // Income Variants toggling
  $('body').on('click', '.income_variant_fieldset', function(event) {
    hidden_checkbox = $(this).find('input[type="checkbox"]');
    $(this).siblings().find('input[type="checkbox"][checked="checked"]').attr('checked', false);
    $(this).siblings('.income_variant_fieldset').css("background-color","white");
    hidden_checkbox.attr('checked', !hidden_checkbox.attr("checked"));
    if(hidden_checkbox.is(':checked')) { $(this).css("background-color","whiteSmoke");};
  });

});