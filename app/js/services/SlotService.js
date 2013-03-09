'use strict';

/* Service for Slot */
angular.module('SlotService',['ngResource'])
    .factory(
        'SlotService'
        , function($http) {
            return {
                getSlots: function() {
                    var items = []; 
                    $http.get('slots')
                    .success( function(data, status, headers, config) {
                        console.log('success/query/slots');
                        for (var i = 0; i < data.length; i++) {
                            items.push(data[i]);
                        }
                    })
                    .error( function(data, status, headers, config) {
                        console.log('error/query/slots' + data);
                    });
                    console.log(items);
                    return items;
                },

                getSlotDetail: function(slotId) {
                    $('.status').html('Getting...').show();
                    if (slotId === undefined) {
                        console.log('Please select Slot.');    
                        return {};
                    }
                    console.log('slotId:' + slotId);
                    return $http.get('slots/' + slotId)
                    .success( function(data, status, headers, config) {
                        console.log('success/query/slots/' + slotId);
                        $('.status').html('Done!!').show();
                        console.log(data);
                    })
                    .error( function(data, status, headers, config) {
                        console.log('error/query/slots/' + slotId);
                        console.log(data);
                    })
                    .then (function(data) {
                        return data.data;
                    });
                },

                getSlotSchedules: function(slotId) {
                    if (slotId === undefined) {
                        console.log('Please select Slot.');    
                        return {};
                    }
                    console.log('slotId:' + slotId);
                    var items = []; 
                    $http.get('slots/' + slotId + '/schedules')
                    .success( function(data, status, headers, config) {
                        console.log('success/query/slots/' + slotId + '/schedules');
                        console.log(data);
                        for (var i = 0; i < data.length; i++) {
                            items.push(data[i]);
                        }
                    })
                    .error( function(data, status, headers, config) {
                        console.log('error/query/slots/' + slotId + '/schedules');
                    });
                        console.log(items);
                    return items;
                }

              , post: function(slotId, schedules, clearDirty) {
                    console.log('start to post');
                    if (slotId === undefined) {
                        alert('slotId is undefined');
                        return {};
                    }
                    if (schedules === undefined) {
                        alert('Schedules is undefined.');
                        return {};
                    }
                    console.log(schedules);
                    $http.post('slots/'+ slotId + '/schedules', schedules )
                    .success( function(data) {
                            console.log('slotschedule/save/success')
                            console.log(data);
                    })
                    .error( function(data) {
                            console.log('slotschedule/save/error:' + slotId);
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
