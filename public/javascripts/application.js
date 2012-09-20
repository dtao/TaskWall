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

  CP.ajaxifyForm = function($form, $container, options) {
    options = options || {};

    $form.submit(function() {
      CP.displayLoading($container);

      $.ajax({
        url: $form.attr("action"),
        type: $form.attr("method"),
        data: $form.serializeArray(),
        dataType: options.dataType || "html",
        success: options.success || function(html) {
          $container.html(html);
        },
        error: options.error || function() {
          CP.displayError("An unexpected error occurred.", $container);
        }
      });

      return false;
    });
  };

  $("#navmenu a").click(function() {
    CP.displayLoading();
  });
});
