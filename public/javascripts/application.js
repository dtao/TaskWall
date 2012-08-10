$(document).ready(function() {
  var $content = $("#content");

  $(".navbar a").click(function() {
    $content.empty();
    var $loading = $("<div id='loading'>").appendTo($content);
    var $message = $("<div class='message'>").text("Loading...").appendTo($loading);
  });
});
