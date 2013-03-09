'use strict';

/* Controller for Group (leader, members) */
function GroupCtrl($scope, GroupLeaderService, GroupMemberService) {
	$scope.leader = GroupLeaderService.query();
	$scope.members = GroupMemberService.query();
}
