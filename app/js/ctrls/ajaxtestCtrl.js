'use strict';

/* Controllers */
function ajaxtestCtrl($scope, SlotService) {
  $scope.slots = SlotService.query();
}
