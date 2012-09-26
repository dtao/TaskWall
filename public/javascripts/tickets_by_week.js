$(document).ready(function() {
  $(".tickets-search").keyup(function() {
    $(".ticket-card").removeClass("highlighted");

    var query   = $(this).val();
    if ($.trim(query) === "") {
      return;
    }

    var match   = new RegExp(query, "i");
    var tickets = $(".ticket-card").filter(function() {
      var number  = $(this).find(".number").text();
      var summary = $(this).find(".summary").text();
      return match.test(summary) || match.test(number);
    });

    tickets.addClass("highlighted");
  });

  $(".status-selector").click(function() {
    var $selector = $(this);
    var status = $selector.find(".value").text();
    if ($selector.is(".selected")) {
      $(".ticket-card.status-" + status).addClass("deselected");
      $selector.removeClass("selected");
    } else {
      $(".ticket-card.status-" + status).removeClass("deselected");
      $selector.addClass("selected");
    }
  });

  $(".resolution-filter").click(function() {
    var $filter  = $(this);
    var resolution = $filter.find(".value").text();
    if ($filter.is(".selected")) {
      $(".ticket-card.resolution-" + resolution).removeClass("filtered");
      $filter.removeClass("selected");
    } else {
      $(".ticket-card.resolution-" + resolution).addClass("filtered");
      $filter.addClass("selected");
    }
  });

  $(".hide-non-matching-cards-link").click(function() {
    var $link  = $(this);
    var $table = $("table.tickets-by-week");
    if ($table.is(".hide-non-matching-cards")) {
      $table.removeClass("hide-non-matching-cards");
      $link.text("Hide non-matching cards");
    } else {
      $table.addClass("hide-non-matching-cards");
      $link.text("Show all cards");
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
    var $link         = $(this);
    var $form         = $link.parent().find("form");
    var $ticketWindow = $form.closest(".ticket-window");

    $form.show();
    CP.ajaxifyForm($form, $ticketWindow);

    $link.remove();
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
