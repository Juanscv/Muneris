// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.modal

//= require turbolinks
//= require_tree .
//= require gmaps/google

//= require wice_grid

//= require webflow

//= require highstock
//= require highstock/highcharts-more
//= require highstock/modules/no-data-to-display


$(function () {
  $('#people .pagination a').on('click', function () {
    $.getScript(this.href);
    return false;
  });

  $('#people_search').submit(function () {
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  });
});


$(function(){
    // For each radio button whose name is 'content[id]':
    jQuery("input[type='radio'][name='content[id]']").each(function(index, button){
        // Give the button a certain click behaviour:
        jQuery(button).click(function(){
            // Set the value of 'title' textfield to the radio's title
            jQuery("#title").val(this.title);
        });
    });
});
