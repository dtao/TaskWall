function TicketsController($scope, user, tickets) {
  this.$scope = $scope;

  $scope.tickets = [];
  $scope.selectedTicket = null;

  user.whenLoggedIn()
    .then(function() {
      $scope.loading = true;
      return tickets.getTickets();
    })
    .then(function(tickets) {
      $scope.tickets = tickets;
      $scope.loading = false;
    });
}

TicketsController.prototype.selectTicket = function(ticket) {
  this.$scope.selectedTicket = ticket;
};

TicketsController.prototype.deselectTicket = function() {
  this.$scope.selectedTicket = null;
};
