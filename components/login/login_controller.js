TaskWall.controller('LoginController', function($scope, user) {
  this.login = function() {
    if (!$scope.username) {
      alert('You forgot your username!');
      return;
    }

    if (!$scope.password) {
      alert('You forgot your password!');
      return;
    }

    user.login($scope.username, $scope.password);
  };
});
