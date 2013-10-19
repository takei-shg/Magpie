'use strict';

/* Controllers */

  /* $scope.orderProp = 'name'; */
function DriverListCtrl($scope, Driver) {
  $scope.drivers = Driver.query();
}

function NavigatorListCtrl($scope, Navigator) {
  $scope.navigators = Navigator.query();
}

magpie.controller(
    'DriverListCtrl'
    , function DriverListCtrl($scope, DriverService) {
      $scope.drivers = DriverService.query();

