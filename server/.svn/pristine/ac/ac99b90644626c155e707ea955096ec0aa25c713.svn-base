var roomControllor = require("../../../controllor/RoomControllor.js");
var userClass = require("../../../model/User.js");
var smRoom = require("../sm/SMRoom.js");
var cdc = require("../../../../../controllor/ConfigDataControllor.js")
var rpcConnectorControllor = require("../../../../../controllor/RpcConnectorControllor.js")


module.exports = {
    //加入房间
    JoinRoom : function(buffer,client){
        if(client.user){
            require('Log').error('RMRoom->JoinRoom() 错误！已经正在加入房间了！');
            return;
        }
        var str = buffer.toString();
        var jObj = JSON.parse(str);

        var key = jObj.key;
        var roomId = jObj.roomId;
        var gameKey = jObj.gameKey;

        var user = new userClass();
        user.gameKey = gameKey;
        user.key = key;
        client.user = user;

        //通知，玩家发送登录（加入房间）消息
        client.doLogin();

        var joinResult = 1;//最终结果

        var gameCb = function(err,data){
            if(client.isDestroyed){
                require("Log").error("玩家正在 加入房间 中，但是断开了连接1！gameKey:"+gameKey);
                return;
            }
            if(!err){
                var result = data.result;
                if(result === 1){
                    var playerData = data.playerData;
                    var pid = data.pid;
                    client.user.pid = pid;
                    client.user.data = playerData;
                    //加入房间
                    var bool = roomControllor.JoinRoom(roomId,client);
                    if(!bool){
                        joinResult = 0;
                    }else{
                        //成功加入，通知game服务器
                        //rpcConnectorControllor.SendByServerId(client.user.gameServerId,"RMRoom","PlayerJoinRoom",{"gameKey":gameKey,"roomId" : roomId,"roomServerId" : cdc.ServerConfig.id});
                    }
                    //返回客户端结果
                    //client.send(smRoom.JoinRoomReturn(joinResult));
                }else{
                    require("Log").error("没从Game查到该玩家数据！gameKey:"+gameKey);
                    joinResult = 0;
                    //client.send(smRoom.JoinRoomReturn(joinResult));
                }
            }else{
                require("Log").error("RPC错误！uid:"+uid);
            }
        }

        var gateCb = function(err,data){
            if(client.isDestroyed){
                require("Log").error("玩家正在 加入房间 中，但是断开了连接2！gameKey:"+gameKey);
                return;
            }
            if(!err){
                var result = data.result;
                if(result === 1){
                    //查找到玩家数据
                    var userGameServerId = data.user.gameServerId;
                    client.user.gameServerId = userGameServerId;
                    rpcConnectorControllor.SendByServerId(userGameServerId,"RMRoom","GetUserDataByUid",{"gameKey":gameKey},gameCb);
                }else{
                    joinResult = 0;
                    require("Log").error("没从Gate查到该玩家数据！gameKey:"+gameKey);
                    client.send(smRoom.JoinRoomReturn(joinResult));
                }
            }else{
                require("Log").error("RPC错误！gameKey:"+gameKey);
                joinResult = 0;
                client.send(smRoom.JoinRoomReturn(joinResult));
            }
        }

        rpcConnectorControllor.BrocastByPath("Gate","RMGate","GetUserInfoByUid",{"gameKey":gameKey},gateCb);

    },
    //离开房间
    LeftRoom : function(buffer,client){
//        var str = buffer.toString();
//        var jObj = JSON.parse(str);

        if(!client.user){
            require('Log').error('RMRoom->LeftRoom() 错误！没有User数据对象！');
            return;
        }

        if(client.user.room){
            client.user.room.removeClient(client,function(err){
                if(!err){
                    //成功
                    client.send(smRoom.LeftRoomReturn(1));
                }else{
                    //失败
                    client.send(smRoom.LeftRoomReturn(0));
                }
                client.user.room = null;
            });
        }else{
            //不在房间内
            require('Log').error('RMRoom->LeftRoom() 错误！玩家不在房间内！gameKey:'+client.user.gameKey);
            client.send(smRoom.LeftRoomReturn(0));
        }
    },
    //副本结束（客户端通知服务端结果）
    GameOver : function(buffer,client){
        if(!client.user){
            require('Log').error('RMRoom->GameOver() 错误！没有User数据对象！');
            return;
        }
        var str = buffer.toString();
        var jObj = JSON.parse(str);

        if(client.user.fb){
            //副本来处理玩家发上来的游戏结束的通知
            client.user.fb.PlayerSendGameOver(jObj,client);
        }else{
            require('Log').error('RMRoom->GameOver() 错误！玩家不在副本中！gameKey:'+client.user.gameKey);
        }
    }
}