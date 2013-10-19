'use strict';

/* Service for Schedules */
angular.module('ScheduleService',['ngResource'])
  .factory(
    'ScheduleService'
    , function($resource) {
      return $resource('schedules', {}, {
        query: {method:'GET', params:{}, isArray:true}
      });
});
