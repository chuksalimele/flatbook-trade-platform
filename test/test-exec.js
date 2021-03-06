var executor = require('../task/task-executor')();
var moment = require('moment');

console.log("-----start-------");

var _24_hours = 24 * 3600 * 1000;
var nextLongTime = new Date(moment().utc().format("YYYY-MM-DD")).getTime() + _24_hours;
var nextDate = moment(new Date(nextLongTime)).format("YYYY-MM-DD");

console.log(nextDate);
console.log(new Date(nextDate).getTime());
console.log(new Date(nextLongTime).getTime());
console.log(new Date(nextLongTime).getTime() === new Date(nextDate).getTime());

var fn = function (args) {

    console.log("this is timer ", args);
    console.log("this is timer day", args.day);
    args.day++;
    if (args.day > 6) {
        args.day = 0;
    }
};

var d = 1;

executor.schedule({
    fn: fn,
    args: {schedule: "the schedule", day: d},
    value: 5,
    unit: executor.SECONDS,
    begin_time: "2017-02-02 09:58:12"
});

executor.queue({
    fn: fn,
    args: {queue: "the queue", day: d},
    //value:5,
    //unit:executor.SECONDS,
    begin_time: "2017-02-02 09:58:12"
});

/*executor.schedule(
 fn,
 "args",
 5,
 executor.SECONDS,
 "2017-01-06 01:16:00"
 );*/

