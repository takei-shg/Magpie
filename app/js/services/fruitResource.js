'use strict';

/* Services */
angular.module('fruitResource',['ngResource'])
.factory('fruitResource', function($q, $rootScope) {
        var taskInTheFuture = $q.defer();

        var heavyFunction = function (cb) {
            setTimeout(function () {
                console.log(Date.now());
                cb([{
                    id: 1,
                    choice: 'true'
                    }, {
                    id: 2,
                    choice: 'false'
                    }, {
                    id: 3,
                    choice: 'true'
                    }]);
                }, 2000);
        };

        return {
            get: function() {
                $('.status').html('Getting...').show();                 
                var fruit = {};
                setTimeout(this.get_callback.bind(this, fruit), 2000);
                return fruit;
            },

            get_callback: function(fruit) {
                $('.status').html('Done!').fadeOut(3000);                  
                fruit.type = ['banana','strawberry','watermellon','grape'][Math.floor(Math.random()*4)]
                fruit.count = [1,2,3,4][Math.floor(Math.random()*4)];
                $rootScope.$apply();
            },

            list: function () {
                heavyFunction(function (data) {
                    $rootScope.$apply(function () {
                        taskInTheFuture.resolve(data);
                    });
                });
                return taskInTheFuture.promise;
            }
        };

});

