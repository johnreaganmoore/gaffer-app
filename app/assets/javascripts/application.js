// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require turbolinks
//= require snackbar
//= require underscore
//= require gmaps/google
//= require materialize-sprockets
//= require rails_env_favicon
//= require_tree .

$( document ).on('turbolinks:load', function() {
  $.each( flashMessages, function(key, value){
    $.snackbar({content: value, style: key, timeout: 10000});
  });

  $('.dropdown-button').dropdown({
     inDuration: 300,
     outDuration: 225,
     constrain_width: false, // Does not change width of dropdown to that of the activator
     hover: false, // Activate on hover
     gutter: 0, // Spacing from edge
     belowOrigin: false, // Displays dropdown below the button
     alignment: 'right' // Displays dropdown with edge aligned to the left of button
   }
 );

 $('.collapsible').collapsible({
    // accordion : false // A setting that changes the collapsible behavior to expandable instead of the default accordion style
  });



  // Materialize initializers
  $('select').material_select();
  $('.season-date').pickadate({
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 2 // Creates a dropdown of years without a limited range
  });

  $('.birthdate').pickadate({

    selectMonths: true, // Creates a dropdown to control month
    selectYears: 100, // Creates a dropdown of years without a limited range
    max: maxDate
    // selectYears: 2 // Creates a dropdown of 2 years to control year
  });

  // $('.datepicker').pickadate({
  //   selectMonths: true, // Creates a dropdown to control month
  //   selectYears: 100 // Creates a dropdown of years without a limited range
  //   // selectYears: 2 // Creates a dropdown of 2 years to control year
  // });
  $(".button-collapse").sideNav();

})

function maxDate() {
    var date = new Date();
    date.setFullYear(date.getFullYear() - 13);
    return date;
}

var loadFile = function(event) {
  var avatar = document.getElementById('avatar');
  avatar.src = URL.createObjectURL(event.target.files[0]);
};

var loadLogo = function(event) {
  var logo = document.getElementById('logo');
  var modalLogo = document.getElementById('edit-modal-logo');
  logo.src = URL.createObjectURL(event.target.files[0]);
  modalLogo.src = URL.createObjectURL(event.target.files[0]);

};

function LightenDarkenColor(col, amt) {

    var usePound = false;

    if (col[0] == "#") {
        col = col.slice(1);
        usePound = true;
    }

    var num = parseInt(col,16);

    var r = (num >> 16) + amt;

    if (r > 255) r = 255;
    else if  (r < 0) r = 0;

    var b = ((num >> 8) & 0x00FF) + amt;

    if (b > 255) b = 255;
    else if  (b < 0) b = 0;

    var g = (num & 0x0000FF) + amt;

    if (g > 255) g = 255;
    else if (g < 0) g = 0;

    return (usePound?"#":"") + (g | (b << 8) | (r << 16)).toString(16);

}
