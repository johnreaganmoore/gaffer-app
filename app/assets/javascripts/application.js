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
//= require turbolinks
//= require snackbar
//= require_tree .

$( document ).on('turbolinks:load', function() {
  $.each( flashMessages, function(key, value){
    $.snackbar({content: value, style: key, timeout: 10000});
  });

})

var loadFile = function(event) {
  var avatar = document.getElementById('avatar');
  avatar.src = URL.createObjectURL(event.target.files[0]);
};

var loadLogo = function(event) {
  var logo = document.getElementById('logo');
  logo.src = URL.createObjectURL(event.target.files[0]);
};
