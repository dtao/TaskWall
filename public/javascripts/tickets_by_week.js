$(document).ready(function() {
  $(".tickets-search").keyup(function() {
    $(".ticket-card").removeClass("highlighted");

    var query   = $(this).val();
    if ($.trim(query) === "") {
      return;
    }

    var match   = new RegExp(query, "i");
    var tickets = $(".ticket-card").filter(function() {
      var id      = $(this).find(".id").text();
      var summary = $(this).find(".summary").text();
      return match.test(summary) || match.test(id);
    });

    tickets.addClass("highlighted");
  });

  $(".status-selector").click(function() {
    var $selector = $(this);
    var status = $selector.find(".value").text();
    if ($selector.is(".selected")) {
      $(".ticket-card." + status).hide();
      $selector.removeClass("selected");
    } else {
      $(".ticket-card." + status).show();
      $selector.addClass("selected");
    }
  });

  $(".ticket-card").click(function() {
    $(".ticket-window").remove();

    var ticketId      = $(this).find(".id").text();
    var $ticketWindow = $("<div>").addClass("ticket-window").appendTo(CP.contentPane);

    CP.displayLoading($ticketWindow);

    $.ajax({
      url: "/tickets/" + ticketId,
      type: "GET",
      dataType: "html",
      success: function(html) {
        $ticketWindow.html(html);
      },
      error: function() {
        CP.displayError("Unable to view ticket details.", $ticketWindow);
      }
    });
  });

  $(".ticket-window .section-selector").live("click", function() {
    var $selector     = $(this);
    var $ticketWindow = $selector.closest(".ticket-window");
    var section       = $selector.text().toLowerCase();
    $ticketWindow.find(".section").hide();
    $ticketWindow.find(".section." + section).show();
    $(".section-selector").removeClass("selected");
    $selector.addClass("selected");
  });

  $(".ticket-window a.add-comment").live("click", function() {
    var $link = $(this);
    var $form = $link.parent().find("form");
    $form.show();
    $link.remove();
  });

  $(".ticket-window form").live("submit", function() {
    var $ticketWindow = $(this).closest(".ticket-window");
    CP.displayLoading($ticketWindow);
  });

  $(".ticket-window .close a").live("click", function() {
    $(".ticket-window").remove();
  });

  $(document).bind("keydown", function(e) {
    if (e.keyCode === 27) {
      $(".ticket-window").remove();
    }
  });
});
