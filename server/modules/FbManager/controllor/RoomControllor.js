var cdc = require("../../../controllor/ConfigDataControllor.js");
var rpcConnectorControllor = require("../../../controllor/RpcConnectorControllor.js");


module.exports = {
    //向fb服务器申请一个房间(data,type(0:2人自动匹配pk，1：自由房间))
    ApplyRoom : function(data,cb){
        var fbs = rpcConnectorControllor.GetPathArrayByPath("Fb");

        var createRoomCb = function(config,err,data){
            if(!err){
                if(data.err == null){
                    //成功
                    if(cb){
                        cb(null,config,data);
                    }
                }else{
                    //失败，找下一个fb服务器
                    fbsFunc(fbs);
                }
//                if(data.result === 1){
//                    //成功
//                    if(cb){
//                        cb(null,config,data);
//                    }
//                }else{
//                    //失败，找下一个fb服务器
//                    fbsFunc(fbs);
//                }
            }else{
                if(cb){
                    cb("apply room fail!");
                }
            }
        };

        var fbsFunc = function(arr){
            var first = arr.shift();
            if(first){
                rpcConnectorControllor.SendByConfig(first,"RMRoom","CreateRoom",data,createRoomCb.bind(null,first));
            }else{
                //创建房间失败
                if(cb){
                    cb("apply room fail!");
                }
            }
        }

        fbsFunc(fbs);
    }
}