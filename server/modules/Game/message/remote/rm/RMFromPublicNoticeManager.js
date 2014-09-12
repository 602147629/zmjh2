/**
 * Created by lijun on 14-6-18.
 */

var lc = require("../../../controllor/LineControllor.js");
var smPublic = require("../../handler/sm/SMPublicNotice.js");

var rmFromPublicNotice = {};

var contentArr = [];

rmFromPublicNotice.timeInterval = -1;


rmFromPublicNotice.AddBroadcastMessage = function(buffer,cb){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var data = jObj.data;

    //放入数组
    require("Log").trace("公告数据放入广播数组");
    if(contentArr.length<10*10000){
        contentArr.push(data);
    }

    if(rmFromPublicNotice.timeInterval == -1){
        rmFromPublicNotice.timeInterval = setInterval(rmFromPublicNotice.sendMsg,2000);
    }
}


rmFromPublicNotice.sendMsg = function(){
    if(contentArr.length>0){
        require("Log").trace("广播公告");
        lc.Brocast(smPublic.PublicNoticeReturn(contentArr[0]));
        contentArr.shift();
    }
}
module.exports = rmFromPublicNotice;