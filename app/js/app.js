/* App Module */

angular.module(
		'magpie'
		,[
			  'DriverService'
			, 'NavigatorService'
			, 'NaviScheduleService'
			, 'ScheduleService'
			, 'SlotService'
			, 'fruitResource'
			, 'ui.bootstrap.dialog'
		]
).config(function($routeProvider) {
	$routeProvider.
		when('/drivers', {
		    templateUrl: 'views/partials/driver-list.html'
		  , controller: DriverListCtrl
		}).
		when('/fruits', {
		    templateUrl: 'views/partials/fruit-list.html'
		  , controller: FruitCtrl
		}).
		when('/navigators', {
		    templateUrl: 'views/partials/navigator-list.html'
		  , controller: NavigatorListCtrl
		}).
		when('/schedules', {
		    templateUrl: 'views/partials/schedule-list.html'
		  , controller: ScheduleListCtrl
		}).
		when('/admin', {
		    templateUrl: 'views/partials/admin.html'
		  , controller: UserRegistCtrl
		}).
		otherwise({
			redirectTo: '/'
		});
});
      /*
			, '$strap.directives'
	   * when('/navigators', {templateUrl: 'views/partials/navigator-list.html', controller: NavigatorListCtrl}).
angular.module('magpie', ['magpieFilters', 'magpieServices']).
  config(['$routeProvider', function($routeProvider) {
*/
