$(document).ready(function() {
  function addListToColumn($column) {
    return $("<ul class='tickets thumbnails'>").appendTo($column);
  }

  function addTicketToList(ticket, $list) {
    var $ticket = $("<li class='ticket span3'>");
    var $container = $("<div class='thumbnail'>").appendTo($ticket);
    $("<h5>").addClass("summary").text(ticket.summary).appendTo($container);
    $("<p>").addClass("status").text(ticket.status).appendTo($container);
    return $ticket.appendTo($list);
  }

  function displayTickets(tickets) {
    var $content = $("#content").addClass("row-fluid");
    var $newColumn = $("<div class='new-tickets span4'>").appendTo($content);
    var $newList = addListToColumn($newColumn);
    var $acceptedColumn = $("<div class='accepted-tickets span4'>").appendTo($content);
    var $acceptedList = addListToColumn($acceptedColumn);
    var $resolvedColumn = $("<div class='resolved-tickets span4'>").appendTo($content);
    var $resolvedList = addListToColumn($resolvedColumn);

    _(tickets).each(function(ticket) {
      if (ticket.status === "accepted") {
        addTicketToList(ticket, $acceptedList);
      } else if (ticket.status === "resolved" || ticket.status === "closed") {
        addTicketToList(ticket, $resolvedList);
      } else {
        addTicketToList(ticket, $newList);
      }
    });
  }

  $(".tickets-link").click(function() {
    $.ajax({
      url: "/tickets",
      type: "GET",
      dataType: "json",
      success: function(data) {
        resetContent();
        displayTickets(data);
      },
      error: function() {
        displayError("An unexpected error occurred.");
      }
    });
  });
});
