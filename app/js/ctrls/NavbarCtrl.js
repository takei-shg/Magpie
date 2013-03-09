'use strict';

function NavbarCtrl($scope, $location) {
	$scope.routeIs = function(routeName) {
		return $location.path() === routeName;
	}
}
