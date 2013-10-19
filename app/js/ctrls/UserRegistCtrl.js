'use strict';

/* Controllers */
function UserRegistCtrl($scope, $http) {
  $scope.addNew = function() {
    alert("start submit");
      var submitData = JSON.stringify({
            name:         $scope.name ,
            email:        $scope.email ,
            dept:        $scope.department ,
            group:        $scope.group ,
            role:        $scope.role
        });
    console.log(submitData);
    $http.post('/user/regist', submitData).
      success(function(o) {
        alert(o);
      }).
      error(function(o) {
        alert(o);
        console.log(o);
        console.log(submitData);
      });
  }
}
