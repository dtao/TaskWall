var TaskWall = angular.module('TaskWall', []);

TaskWall.service('user', UserService);
TaskWall.service('tickets', TicketsService);
TaskWall.controller('ApplicationController', ApplicationController);
TaskWall.controller('LoginController', LoginController);
TaskWall.controller('TicketsController', TicketsController);
