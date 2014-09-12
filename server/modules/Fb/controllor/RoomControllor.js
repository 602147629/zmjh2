var roomClass = require("../model/Room.js");
var rpcConnectorControllor = require("../../../controllor/RpcConnectorControllor.js");
var smRoomRpc = require("../message/remote/sm/SMRoom.js");
var smRoom = require("../message/handler/sm/SMRoom.js");
var sm = require("../message/handler/sm/SMGame.js");
var cdc = require("../../../controllor/ConfigDataControllor.js");
var uic = require("./UserInfoControllor.js");
var fbControllor = require("./FbControllor.js");
var tooBusy = require('toobusy');

var allRooms = [];
var currentNum = 0;//当前房间数
var isInit = false;
var maxRooms;//最多房间数目
var index = 0;//房间id索引

module.exports = {
    //按照配置表初始化
    InitWithConfig : function(config){
        if(isInit){
            return;
        }
        isInit = true;
        maxRooms = config.max;
    },
    //更新配置
    UpdateConfig : function(config){
        maxRooms = config.max;
    },
    //申请创建房间
    CreateRoom : function(data,cb){
        if(tooBusy()){
            if(cb){
                cb('ROOM_TOOBUSY');
            }
            return;
        }
        if(currentNum < maxRooms){
            var room = new roomClass();
            room.id = index;
            room.type = data.type;//房间种类
            if(room.type == 0){
                //双人自动匹配pk
                room.isAutoStartWhenFull = true;
                room.maxChildren = 2;
            }

            require("Log").info("创建了房间,房间ID:"+index+",当前房间总数:"+(currentNum+1));

           allRooms[index] = room;

            //房间id自增
            index++;

            //房间销毁
            room.on("destroy",function(){
                require("Log").info("销毁了房间,房间ID:"+room.id+",当前房间总数:"+(currentNum-1));
                room.destroy();
                delete allRooms[room.id];
                currentNum--;
            });
            //房间信息变化(更新给GAME服，再通知所有玩家)
            room.on("roomChanged",function(r){
                //通知game服务器
                if(room.type == 1){
                    //普通房间,广播给所有人
                    rpcConnectorControllor.BrocastByPath("Game","RMRoom","RoomChanged",smRoomRpc.RoomChanged(room));
                }else if(room.type == 0){
                    //pk匹配房间，房间内广播
                    room.brocast(smRoom.RoomChanged(room));
                }
            });

            //有玩家离开房间
            room.on("UserOutFromRoom",function(client){
                //移除玩家管理器
                uic.RemoveClient(client.user.gameKey);
                //通知Gate，玩家离开房间
                rpcConnectorControllor.BrocastByPath("Gate","RMFromFb","UserOutRoom",{"gameKey":client.user.gameKey});
                //通知玩家所在game服务器
                rpcConnectorControllor.SendByServerId(client.user.gameServerId,"RMRoom","PlayerLeftRoom",smRoomRpc.PlayerLeftRoom(client.user.gameKey));
            });

            //有玩家加入房间
            room.on("UserIntoRoom",function(client){
                //加入玩家管理器内
                uic.AddClient(client.user.gameKey,client);
                //通知Gate，玩家进入房间
                rpcConnectorControllor.BrocastByPath("Gate","RMFromFb","UserIntoRoom",{"gameKey":client.user.gameKey,"roomServerId":cdc.ServerConfig.id});
            });

            //房间自动开始
            room.on("autoStart",function(){
                var result = 0;
                var playerDatas = [];
                fbControllor.CreateFb(room,function(err){
                    if(!err){
                        result = 1;
                        require("Log").trace('roomId:'+room.id+" 游戏开始!,当前副本总数:"+fbControllor.GetFbNums());
                        playerDatas = room.getPlayerDatas();
                    }else{
                        require("Log").error("副本自动开始失败!err:"+err);
                    }
                    room.brocast(sm.StartGame(result,playerDatas));
                });
            })

            room.init();

            currentNum++;

            if(cb){
                cb(null,room);
            }
        }else{
            if(cb){
                cb('ROOM_NUM_MAX');
            }
        }
    },
    //玩家加入房间
    JoinRoom : function(roomId,client,cb){
        if(!client.user){
            if(cb){
                cb('NO_USER');
            }
            return;
        }
        if(client.user.room){
            if(cb){
                cb('ALREADY_IN_ROOM');
            }
            require("Log").error("玩家已经在房间中！gameKey:"+client.user.gameKey);
            return;
        }
        var room = allRooms[roomId];
        if(room){
            if(room.key == client.user.key){
                room.addClient(client,function(err){
                    if(!err){
                        //加入成功
                        if(cb){
                            cb(null);
                        }
                    }else{
                        if(cb){
                            cb(err);
                        }
                    }
                });
            }else{
                require("Log").error("房间key不对！");
                if(cb){
                    cb('KEY_ERROR');
                }
            }
        }else{
            require("Log").error("没找到这个房间！");
            if(cb){
                cb('NOT_THIS_ROOM');
            }
        }
    },
    //获取总人数
    GetTotalNum : function(){
        return currentNum;
    },
    //获取所有的房间信息
    GetAllRoomsInfo : function(){
        var rooms = [];

        require("SuperUtils").forEachInArray(allRooms,function(room){
            if(rooms.canSee()){
                rooms.push(room.getRoomJsonInfo());
            }
        });
        return rooms;
    },
    //是否该房间可以加入玩家
    CanJoinRoom : function(roomId){
        var room = allRooms[roomId];
        if(room){
            if(room){
                if(room.canJoin()){
                    return room;
                }
            }
        }
        return null;
    }
}