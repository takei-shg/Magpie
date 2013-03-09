'use strict';

/* Service for Navigators */
angular.module('NavigatorService',['ngResource'])
    .factory(
        'NavigatorService'
        , function($http) {
            return {
                query: function() {
                    return $http.get('navigators')
                    .success( function(data, status, headers, config) {
                        console.log('successnavigators:');
                    })
                    .error( function(data, status, headers, config) {
                        console.log('errornavigators:' + data);
                    })
                    .then( function(data) {
                        console.log(data.data);
                        return data.data
                    });
                },

            };
});
