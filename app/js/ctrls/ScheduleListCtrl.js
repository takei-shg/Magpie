'use strict';

/* Controllers */
function ScheduleListCtrl($scope, ScheduleService, SlotService) {
	$scope.drivers = ScheduleService.query();
	$scope.slots = SlotService.query();
	
}
