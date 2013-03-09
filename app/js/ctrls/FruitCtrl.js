'use strict';

function FruitCtrl($scope, fruitResource) {

        $scope.fruit = {type: 'Apple', count: 3};

        $scope.changeFruit = function() {
            $scope.fruit = fruitResource.get();
        };

        $scope.printFruit = function() {
            console.log($scope.fruit);
        };
        
        $scope.list = [];

        $scope.load = function () {
            console.log('start to load');
            $scope.list = fruitResource.list();
        };

        $scope.alts = {
            'true': 'OK',
            'false': 'NO'
        };
}
