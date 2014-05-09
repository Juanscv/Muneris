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
//= require jquery-ui
//= require jquery.ui.all
//= require jquery.modal
//= require jquery_ujs

//= require turbolinks
//= require_tree .
//= require gmaps/google

//= require wice_grid

//= require webflow

//= require highstock
//= require highstock/highcharts-more

//= require highstock/adapters/mootools-adapter
//= require highstock/adapters/prototype-adapter
//= require highstock/adapters/standalone-framework

//= require highstock/modules/annotations
//= require highstock/modules/canvas-tools
//= require highstock/modules/data
//= require highstock/modules/drilldown
//= require highstock/modules/exporting
//= require highstock/modules/funnel
//= require highstock/modules/heatmap
//= require highstock/modules/no-data-to-display

//= require highstock/themes/dark-blue
//= require highstock/themes/dark-green
//= require highstock/themes/gray
//= require highstock/themes/grid
//= require highstock/themes/skies


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
