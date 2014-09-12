var allRooms = [];
var allRoomsJson = [];
var cdc = require("../../../controllor/ConfigDataControllor.js");
var rpcConnectorControllor = require("../../../controllor/RpcConnectorControllor.js");


module.exports = {
    //某个房间发生了变化（新增，修改，销毁）
    UpdateRoomn : function(room){
        if(!allRooms[room.serverId]){
            allRooms[room.serverId] = [];
        }
        allRooms[room.serverId][room.id] = room;

        //更新json
        allRoomsJson.length = 0;
        require("SuperUtils").forEachInArray(allRooms,function(rooms){
            require("SuperUtils").forEachInArray(rooms,function(room){
                //屏蔽空房间（玩家创建房间后没有即时加入的房间）
                if(room.current > 0 && !room.isFight){
                    allRoomsJson.push(room);
                }
            });
        });
    },
    //获取所有的房间
    GetAllRooms : function(){
        return allRoomsJson;
    }
//    ,
//    //向fb服务器申请一个房间(data,type(0:2人自动匹配pk，1：自由房间))
//    ApplyRoom : function(data,cb){
//        var fbs = cdc.GetPathArrayByPath("Fb");
//
//        var createRoomCb = function(config,err,data){
//            if(!err){
//                if(data.result === 1){
//                    //成功
//                    if(cb){
//                        cb(null,config,data);
//                    }
//                }else{
//                    //失败，找下一个fb服务器
//                    fbsFunc(fbs);
//                }
//            }else{
//                if(cb){
//                    cb("apply room fail!");
//                }
//            }
//        };
//
//        var fbsFunc = function(arr){
//            var first = arr.shift();
//            if(first){
//                rpcConnectorControllor.SendByConfig(first,"RMRoom","CreateRoom",data,createRoomCb.bind(null,first));
//            }else{
//                //创建房间失败
//                if(cb){
//                    cb("apply room fail!");
//                }
//            }
//        }
//
//        fbsFunc(fbs);
//    }
}