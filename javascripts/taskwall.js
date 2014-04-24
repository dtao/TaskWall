var TaskWall = angular.module('TaskWall', []);

TaskWall.controller('TicketsController', function($scope) {
  function maybe() {
    return Math.random() >= 0.5;
  }

  function createTicket(id, summary) {
    return {
      id: id,
      number: id,
      status: 'new',
      summary: summary,
      hasUpdates: maybe(),
      hasComments: maybe()
    };
  }

  $scope.tickets = [
    createTicket(1, 'Drop Padrino'),
    createTicket(2, 'Migrate to Angular'),
    createTicket(3, 'Move existing jQuery stuff into directives'),
    createTicket(4, 'Integrate w/ GitHub issues')
  ];
});
