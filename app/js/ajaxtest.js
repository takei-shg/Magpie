function postDriverJson() {
    alert("postDriverJson called");
    alert($('#driver [name=f1]').val());
    alert($('#driver [name=f2]').val());
    alert($('#driver [name=f3]').val());

    var data = JSON.stringify({
            name:         $('#driver [name=f1]').val() ,
            email:        $('#driver [name=f2]').val() ,
            dept:        $('#driver [name=f3]').val()
        });
    alert(data);
    $.ajax({
        url: '/driver/regist',
        type: 'POST',
        datatype: 'json',
        data: JSON.stringify({
            name:         $('#driver [name=f1]').val() ,
            email:        $('#driver [name=f2]').val() ,
            dept:        $('#driver [name=f3]').val()
        }),
        contentType: "application/json; charset=utf-8",
        success: function(o) {
            console.log(o);
        },
        error: function() {
            alert("error in post");
        }
    });
}

function postUserJson() {
    alert("postUserJson called");
    alert($('#user [name=f1]').val());
    alert($('#user [name=f2]').val());
    alert($('#user [name=f3]').val());
    alert($('#user [name=f4]').val());
    alert($('#user [name=f5]').val());

    var data = JSON.stringify({
            name:         $('#user [name=f1]').val() ,
            email:        $('#user [name=f2]').val() ,
            dept:        $('#user [name=f3]').val() ,
            group:        $('#user [name=f4]').val() ,
            role:        $('#user [name=f5]').val()
        });
    alert(data);
    $.ajax({
        url: '/user/regist',
        type: 'POST',
        datatype: 'json',
        data: JSON.stringify({
            name:         $('#user [name=f1]').val() ,
            email:        $('#user [name=f2]').val() ,
            dept:        $('#user [name=f3]').val() ,
            group:        $('#user [name=f4]').val() ,
            role:        $('#user [name=f5]').val()
        }),
        contentType: "application/json; charset=utf-8",
        success: function(o) {
            console.log(o);
        },
        error: function() {
            alert("error in post");
        }
    });
}
function putDriver() {
    alert("putDriver called");
    alert($('#driverUpdate [name=id]').val());
    alert($('#driverUpdate [name=f1]').val());
    alert($('#driverUpdate [name=f2]').val());
    alert($('#driverUpdate [name=f3]').val());

    var data = {
        id:           $('#driverUpdate [name=id]').val() ,
        name:         $('#driverUpdate [name=f1]').val() ,
        email:        $('#driverUpdate [name=f2]').val() ,
        dept:         $('#driverUpdate [name=f3]').val()
    };
    alert(data);
    $.ajax({
        url: '/driver/' + data.id,
        type: 'PUT',
        datatype: 'json',
        data: JSON.stringify(data),
        contentType: "application/json; charset=utf-8",
        success: function(o) {
            console.log(o);
        },
        error: function() {
            alert("error in post");
        }
    });
}

function getDrivers() {
    alert("getDrivers called");

    $.ajax({
        url: '/drivers',
        type: 'GET',
        datatype: 'json',
        contentType: "application/json; charset=utf-8",
        success: function(o) {
            console.log(o);
        },
        error: function() {
            alert("error in post");
        }
    });
}

function getNavigators() {
    alert("getNavigators called");

    $.ajax({
        url: '/navigators',
        type: 'GET',
        datatype: 'json',
        contentType: "application/json; charset=utf-8",
        success: function(o) {
            console.log(o);
        },
        error: function() {
            alert("error in getNavigators");
        }
    });
}

function getNaviSchedules(naviId) {
    alert("getNaviSchedules called");

    $.ajax({
        url: '/navigator/' + naviId + '/schedules',
        type: 'GET',
        datatype: 'json',
        contentType: "application/json; charset=utf-8",
        success: function(o) {
            console.log(o);
        },
        error: function() {
            alert("error in getNaviSchedules");
        }
    });
}
function getDriverById() {
    alert("getDriverById called");
    alert($('#driverQuery [name=driverId]').val());

    var data = JSON.stringify({
            id:         $('#driverQuery [name=driverId]').val()
        });
    alert(data);
    $.ajax({
        url: '/driver/id',
        type: 'GET',
        datatype: 'json',
        data: JSON.stringify({
            id:         $('#driverQuery [name=driverId]').val()
        }),
        contentType: "application/json; charset=utf-8",
        success: function(o) {
            console.log(o);
        },
        error: function() {
            alert("error in post");
        }
    });
}
