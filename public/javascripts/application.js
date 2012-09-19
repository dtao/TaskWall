$(document).ready(function() {
  var $content = $("#content");

  function displayHtml(html) {
    $content.html(html);
  }

  function displayError(message) {
    $("#loading").hide();
    $("<div id='error'>").text(message).appendTo("#container");
  }

  function resetContent() {
    $content.empty();
    $content.removeAttr("class");
  }

  $("#navmenu a").click(function() {
    $content.empty();
    var $loading = $("<div id='loading'>").appendTo($content);
    var $message = $("<div class='message'>").text("Loading...").appendTo($loading);
  });

  // Expose global functions
  window.displayHtml = displayHtml;
  window.displayError = displayError;
  window.resetContent = resetContent;
});
