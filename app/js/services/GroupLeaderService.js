'use strict';

/* Service for leader of Group */
angular.module('GroupLeaderService',['ngResource'])
  .factory(
    'GroupLeaderService'
    , function($resource) {
      return $resource('group/:groupname/leader', {}, {
        query: {method:'GET', params:{groupname:}, isArray:true}
      });
});
