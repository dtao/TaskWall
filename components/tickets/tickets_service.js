function TicketsService($http, $q, user) {
  this.$http = $http;
  this.$q = $q;
  this.user = user;
}

TicketsService.prototype.getTickets = function() {
  var tickets = [],
      deferred = this.$q.defer(),
      reposUrl = this.createUrl_('users', this.user.username, 'repos');

  this.fetchTickets_(reposUrl, tickets, deferred);

  return deferred.promise;
};

TicketsService.prototype.fetchTickets_ = function(url, tickets, deferred) {
  var service  = this,
      $q       = this.$q,
      user     = this.user,
      request  = this.createRequest_(url),
      promises = [];

  request.success(function(repos, status, headers) {
    repos.forEach(function(repo) {
      var issuesUrl = service.createUrl_(
        'repos', user.username, repo.name, 'issues?state=all');

      var issuesRequest = service.createRequest_(issuesUrl),
          issuesDeferred = $q.defer();

      issuesRequest.success(function(issues) {
        issues.forEach(function(issue) {
          tickets.push({
            id: issue.number,
            number: repo.name + '#' + issue.number,
            status: issue.state,
            summary: issue.title,
            body: issue.body,
            comments: issue.comments,
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
      service.fetchTickets_(nextPageUrl, tickets, deferred);

    } else {
      $q.all(promises).then(function() {
        deferred.resolve(tickets);
      });
    }
  });
};

TicketsService.prototype.createUrl_ = function() {
  var args = Array.prototype.slice.call(arguments);
    return ['https://api.github.com'].concat(args).join('/');
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
