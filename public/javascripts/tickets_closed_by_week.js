$(document).ready(function() {
  $(".tickets-search").keyup(function() {
    $(".ticket").removeClass("highlighted");

    var query   = $(this).val();
    if ($.trim(query) === "") {
      return;
    }

    var match   = new RegExp(query, "i");
    var tickets = $(".ticket").filter(function() {
      var summary = $(this).find(".summary").text();
      return match.test(summary);
    });

    tickets.addClass("highlighted");
  });
});
