'use strict';

/* Controllers */
function DriverListCtrl($scope, SlotService) {
	$scope.slots = SlotService.getSlots();
	$scope.slotDetail = {};
	$scope.slotSchedules = [];
  $scope.dirty = false;
  $scope.loaded = false;

  $scope.update = function() {
    if ($scope.selectedSlot === undefined) alert('Please Select Slot');
    $scope.slotDetail = SlotService.getSlotDetail($scope.selectedSlot.id);
    $scope.slotSchedules = SlotService.getSlotSchedules($scope.selectedSlot.id);
    $scope.dirty = false;
    $scope.loaded = true;
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
    var result = SlotService.post($scope.selectedSlot.id, $scope.slotSchedules, $scope.clearDirty);
  }

	$scope.alternatives= {
    'NOTYET' : '未入力'
  , 'NODRIVER' : '該当者無し'
  , 'ASSIGNINED' : '確定'
  , 'CANCELLED' : 'キャンセル'
  , 'DONE' : '実施完了'
  , 'CLOSED' : 'ペアプロ実施なし'
	};
}
