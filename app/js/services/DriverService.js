'use strict';

/* Services */
angular.module('DriverService',['ngResource'])
	.factory(
		'DriverService'
		, function($resource) {
			return $resource('drivers', {}, {
				query: {method:'GET', params:{}, isArray:true}
			});
});
