window.CP = {};

$(document).ready(function() {
  CP.contentPane = $("#content");

  CP.displayLoading = function($container) {
    $container   = ($container || CP.contentPane).empty();
    var $loading = $("<div id='loading'>").appendTo($container);
    $("<div class='message'>").text("Loading...").appendTo($loading);
  };

  CP.displayError = function(message, $container) {
    $container = ($container || CP.contentPane).empty();
    $("<p class='error'>").text(message).appendTo($container);
  };

  $("#navmenu a").click(function() {
    CP.displayLoading();
  });
});
