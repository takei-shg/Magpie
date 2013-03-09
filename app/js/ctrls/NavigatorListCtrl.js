'use strict';

/* controllers */
function NavigatorListCtrl($scope, $dialog, NavigatorService, NaviScheduleService) {
  $scope.navigators = NavigatorService.query();
  $scope.naviSchedules = [];
  $scope.dirty = false;
  $scope.loaded = false;

  $scope.update = function() {
    if ($scope.selectedNavi === undefined) return;
    $scope.naviSchedules = NaviScheduleService.query($scope.selectedNavi.id);
    $scope.dirty = false;
    $scope.loaded = true;
  }

  $scope.reload = function() {
    if ($scope.selectedNavi === undefined) return;
    $scope.naviSchedules = NaviScheduleService.query($scope.selectedNavi.id);
    $scope.dirty = false;
  }
  
  $scope.check = function() {
    console.log($scope.naviSchedules);
  }

  $scope.setDirty= function() {
    console.log('option was changed');
    $scope.dirty = true;
  }

  $scope.clearDirty= function(status) {
      if (status == 200) {
          console.log('Submit done.');
          $scope.dirty = false;
      } else {
          console.log('Submit failed.');
      };
  }

  $scope.save = function() {
    console.log('Start to save');
    NaviScheduleService.post($scope.selectedNavi.id, $scope.naviSchedules, $scope.clearDirty);
  }

  $scope.openDialog = function(naviSchedules) {
    var dialogOpts = {
        backdrop : true
      , keyboard: true
      , backdropClick: true
      , templateUrl: 'views/partials/navischedule-dialog.html'
      , controller: 'NaviScheduleEditCtrl'
      , resolve: {items: angular.copy(naviSchedules)}
      };

    var d = $dialog.dialog(dialogOpts);
    d.open().then(function(result) {
      if (result) {
        $scope.naviSchedules = result;
        alert('dialog closed with result(dialog):' + result)
      } 
    });
  };

	$scope.alternatives= {
    'OK' : '可能'
  , 'NO' : '不可能'
	};
}
/*
 *
        console.log('got navischedules');
        console.log($scope.rawnaviSchedules);
        for (var i = 0; i < $scope.rawnaviSchedules.length; i++) {
            $scope.naviSchedules.push( {
                    body: $scope.rawnaviSchedules[i] ,
                    chosen: $scope.rawnaviSchedules[i].body.available
            });
        }
	$scope.alternatives= [
		{ value: '可能', available: 'true' },
		{ value: '不可能', available: 'false' }
	];
	$scope.alternatives= [
		{ available: 'AVAILABLE' },
		{ available: 'NOT_AVAILABLE' }
	];
        if ($scope.selectedNavi === undefined) return;
        NaviScheduleService.query($scope.naviSchedules, $scope.selectedNavi.id);
        
        console.log('start update');
        console.log('current navischedule(before load): ' + $scope.naviSchedules);

        $scope.naviSchedules = NaviScheduleService.query($scope.selectedNavi.id);
        
        console.log('loaded navischedule: ' + $scope.naviSchedules);
        console.log($scope.naviSchedules);
*/
