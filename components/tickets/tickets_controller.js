TaskWall.controller('TicketsController', function($scope, $http, $q, user) {
  $scope.tickets = [];

  function getNextPageUrl(headers) {
    var linkHeader = headers['link'];
    if (!linkHeader) { return; }

    var pages = linkHeader.split(',');
    var nextPage;

    for (var i = 0; i < pages.length; ++i) {
      if (/rel="next"/.test(pages[i])) {
        nextPage = pages[i];
        break;
      }
    }
    if (!nextPage) { return; }

    return nextPage.split(';')[0].replace(/^<|>$/g, '');
  }

  function createRequest(url) {
    return $http({
      method: 'GET',
      url: url,
      headers: {
        'Accept': 'application/vnd.github.v3+json',
        'Authorization': 'Basic ' + user.getEncodedAuthorization()
      }
    });
  }

  var requests = [];

  function fetchRepos(url) {
    url || (url = 'https://api.github.com/users/' + user.username + '/repos');

    var request = createRequest(url);

    request.success(function(repos, status, headers) {
      repos.forEach(function(repo) {
        var issuesRequest = createRequest('https://api.github.com/repos/' + user.username + '/' + repo.name + '/issues?state=all');

        issuesRequest.success(function(issues) {
          issues.forEach(function(issue) {
            $scope.tickets.push({
              id: issue.number,
              number: repo.name + '#' + issue.number,
              status: issue.state,
              summary: issue.title,
              hasComments: issue.comments > 0,
              created_at: issue.created_at,
              updated_at: issue.updated_at
            });
          });
        });

        requests.push(issuesRequest);
      });

      var nextPageUrl = getNextPageUrl(headers());
      if (nextPageUrl) {
        fetchRepos(nextPageUrl);

      } else {
        $q.all(requests).then(function() {
          // TODO: See if this works.
        });
      }
    });
  }

  user.whenLoggedIn().then(function() {
    fetchRepos();
  });
});
