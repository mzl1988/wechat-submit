//
// 運行服務
//

var time = process.hrtime();

require('./init');

var moment = require('moment');
var numeral = require('numeral');

worker = require('./lib/worker');
worker();

var diff = process.hrtime(time);
var second = (diff[0] * 1e9 + diff[1]) / 1e9;
console.log("%s worker is running in %s mode used %s seconds",
  moment().format('YYYY-MM-DD HH:mm:ss'), process.env.NODE_ENV, numeral(second).format('0.00'));
