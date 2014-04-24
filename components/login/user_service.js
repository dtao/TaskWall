TaskWall.service('user', function($window, $q) {
  var storage = $window.localStorage;

  this.username = storage.username;
  this.password = storage.password;

  var deferredLogin = $q.defer();

  function base64(string) {
    return btoa(unescape(encodeURIComponent(string)));
  }

  this.login = function(username, password) {
    this.username = storage.username = username;
    this.password = storage.password = password;
    deferredLogin.resolve();
  };

  this.logout = function() {
    delete storage.username;
    delete storage.password;
    this.username = null;
    this.password = null;
  };

  Object.defineProperty(this, 'loggedIn', {
    get: function() {
      return !!this.username && !!this.password;
    }
  });

  if (this.loggedIn) {
    deferredLogin.resolve();
  }

  this.whenLoggedIn = function() {
    return deferredLogin.promise;
  };

  this.getEncodedAuthorization = function() {
    return base64(this.username + ':' + this.password);
  };
});
