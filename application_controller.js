function ApplicationController($rootScope, user) {
  $rootScope.user = user;

  // Attach useful helper methods directly to $rootScope?
  // Not sure if this is a good idea or not. For now, seems OK to me!

  // Add a cache buster to each URL to prevent the browser from caching HTML
  // partials during development. Only do this once per session as we don't
  // want, e.g., 1,000 separate requests for 1,000 cards.
  var cacheBuster = '?' + Date.now();

  $rootScope.partial = function partial(path) {
    return 'components/' + path + '.html' + cacheBuster;
  };
}
