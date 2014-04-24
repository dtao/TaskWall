function TicketsService($http, $q, user) {
  this.$http = $http;
  this.$q = $q;
  this.user = user;
  this.tickets = [];
}

TicketsService.prototype.getTickets = function(opt_url) {
  var service  = this,
      $q       = this.$q,
      user     = this.user,
      url      = opt_url || 'https://api.github.com/users/' + user.username + '/repos',
      request  = this.createRequest_(url),
      promises = [],
      tickets  = this.tickets,
      deferred = this.deferred || (this.deferred = $q.defer());

  request.success(function(repos, status, headers) {
    repos.forEach(function(repo) {
      var issuesUrl = [
        'https://api.github.com/repos',
        user.username,
        repo.name,
        'issues?state=all'
      ].join('/');

      var issuesRequest = service.createRequest_(issuesUrl),
          issuesDeferred = $q.defer();

      issuesRequest.success(function(issues) {
        issues.forEach(function(issue) {
          tickets.push({
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

      issuesRequest['finally'](function() {
        issuesDeferred.resolve();
      });

      promises.push(issuesDeferred.promise);
    });

    var nextPageUrl = service.getNextPageUrl_(headers());
    if (nextPageUrl) {
      service.getTickets(nextPageUrl);

    } else {
      $q.all(promises).then(function() {
        deferred.resolve(tickets);
      });
    }
  });

  return deferred.promise;
};

TicketsService.prototype.createRequest_ = function(url) {
  return this.$http({
    method: 'GET',
    url: url,
    headers: {
      'Accept': 'application/vnd.github.v3+json',
      'Authorization': 'Basic ' + this.user.getEncodedAuthorization()
    }
  });
};

TicketsService.prototype.getNextPageUrl_ = function(headers) {
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
};
