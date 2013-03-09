'use strict';

/* Service for Navigator Schedules */
angular.module('NaviScheduleService',['ngResource'])
    .factory(
        'NaviScheduleService'
        , function($http, $rootScope, $timeout) {
            return {
                query: function(naviId) {
                    $('.status').html('Getting...').show();
                    if (naviId === undefined) {
                        console.log('Please select Navigator.');    
                        return {};
                    }
                    console.log('naviId:' + naviId);
                    var items = []; 
                    setTimeout(this.query_callback.bind(this, items, naviId), 500);
                    return items;
                }

              , query_callback: function(items, naviId) {
                    return $http.get('navigator/'+ naviId + '/schedules')
                    .success( function(data, status, headers, config) {
                        console.log('navischedule/query/success');
                        console.log(data);
                        for (var i = 0; i < data.length; i++) {
                            items.push(data[i]);
                        }
                    })
                    .error( function(data, status, headers, config) {
                            console.log('navischedule/query/error:' + naviId);
                    })
                    .then( function(data) {
                            $('.status').html('Done!!').fadeOut(2000);
                    });
                }

              , post: function(naviId, schedules, clearDirty) {
                    console.log('start to post');
                    if (naviId === undefined) {
                        alert('naviId is undefined');
                        return {};
                    }
                    if (schedules === undefined) {
                        alert('Schedules is undefined.');
                        return {};
                    }
                    console.log(schedules);
                    $http.post('navigator/'+ naviId + '/schedules', schedules )
                    .success( function(data) {
                            console.log('navischedule/save/success')
                            console.log(data);
                            })
                    .error( function(data) {
                            console.log('navischedule/save/error:' + naviId);
                            console.log(data);
                            alert('Failed to submit.' + data);
                            })
                    .then( function(data) {
                            clearDirty(data.status);
                    });
                }
            };
        }
    );
/*
                            var items = [];
                            for (var i = 0; i < data.length; i++) {
                                console.log(data[i]);
                                items.push({
                                    body: data[i] ,
                                    chosen: data[i].body.available 
                                });
                            }
                            return items;
                    this.query_callback(naviSchedules, naviId);
                    setTimeout(this.query_callback.bind(this, naviSchedules, naviId), 1000);
                        $rootScope.$apply();
                        naviSchedules.push({id:10},{id:20});


            return $resource('navigator/:naviId/schedule', {}, {
                query: {method:'GET', params:{naviId:'naviId'}, isArray:true}
            });
*/
