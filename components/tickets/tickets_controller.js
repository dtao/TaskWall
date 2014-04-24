function TicketsController($scope, user, tickets) {
  $scope.tickets = [];

  user.whenLoggedIn()
    .then(function() {
      return tickets.getTickets();
    })
    .then(function(tickets) {
      $scope.tickets = tickets;
    });
}
