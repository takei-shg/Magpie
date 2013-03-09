'use strict';

/* Services */
angular.module('NavigatorService',['ngResource'])
	.factory(
		'NavigatorService'
		, function($resource) {
			return $resource('navigators', {}, {
				query: {method:'GET', params:{}, isArray:true}
			});
});
