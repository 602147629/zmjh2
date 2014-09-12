var sm = require("../sm/SMRoom.js");
var smEscort = require("../sm/SMEscort.js");
var smCommon = require("../sm/SMCommon.js");
var cdc = require("../../../../../controllor/ConfigDataControllor.js");
var msgC = require('../../../controllor/MsgControllor.js');
var rpcConnectorControllor = require("../../../../../controllor/RpcConnectorControllor.js");


module.exports = {
    //创建房间
    CreateRoom : function(buffer,client){
        if(!client.user){
            require("Log").error("RMRoom->CreateRoom() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMRoom->CreateRoom() 没找到player对象");
            return;
        }
        if(client.currentPlayer.roomJoinCooldown){
            require("Log").trace("创建房间冷却中");
            msgC.Send(client,'CREATEROOM_COOLDOWN');
            return;
        }
        // var str = buffer.toString();
        // var jObj = JSON.parse(str);

        //过滤重复请求
        if(client.isInCreateRoom){
            require("Log").trace("正在申请创建房间中...屏蔽重复请求");
            return;
        }else{
            client.isInCreateRoom = true;
        }

        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var playerData = jObj.playerData;

        client.currentPlayer.playerData = playerData;

        if(client.currentPlayer.roomId == -1){
                //向Fb服务器申请副本
            var createRoomCb = function(err,data){
                if(!err){
                    var config = data.config;
                    var data = data.data;
                    //成功加入，10秒内不能再申请副本(针对申请成功，但是没有加入副本的玩家)
                    require("Log").trace("玩家："+client.currentPlayer.gameKey+" 在FBID:"+config.id+" 创建了房间ROOMID:"+data.roomId);
                    //进入加入房间冷却状态
                    client.currentPlayer.intoRoomJoinCoolDown();
                    //返回玩家结果
                    client.send(sm.CreateRoomReturn(data.result,data.key,data.roomId,config,0));
                    client.isInCreateRoom = false;
                }else{
                    require("Log").error("申请房间失败！gameKey:"+client.currentPlayer.gameKey);
                    //完全失败失败
                    client.isInCreateRoom = false;
                }
            };

            rpcConnectorControllor.BrocastByPath("FbManager","RMFromGame","CreateRoom",{"type":1},createRoomCb);
        }else{
            //已经在房间中
            client.isInCreateRoom = false;
            require("Log").info("玩家已经在房间中，无法再创建房间！gameKey:"+client.currentPlayer.gameKey);
        }
    },
    //申请加入房间
    ApplyJoinRoom : function(buffer,client){
        if(!client.user){
            require("Log").error("RMRoom->ApplyJoinRoom() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMRoom->ApplyJoinRoom() 没找到player对象");
            return;
        }
        if(client.currentPlayer.roomJoinCooldown){
            require("Log").trace("加入房间冷却中");
            msgC.Send(client,'JOINROOM_COOLDOWN');
            return;
        }
        //过滤重复请求
        if(client.isInApplyJoinRoom){
            return;
        }else{
            client.isInApplyJoinRoom = true;
        }

        require("Log").trace("玩家："+client.currentPlayer.gameKey+" 申请加入房间!");

        if(client.currentPlayer.roomId == -1){
            var str = buffer.toString();
            var jObj = JSON.parse(str);

            var roomId = jObj.roomId;
            var serverId = jObj.serverId;

            var targetConfig;

            var joinCb = function(err,data){
                if(!err){
                    var result = data.result;
                    if(result === 1){
                        require("Log").trace("玩家："+client.currentPlayer.gameKey+" 申请加入房间成功!ROOMID:"+data.roomId);
//                        client.currentPlayer.roomId = data.roomId;
                        client.send(sm.CreateRoomReturn(data.result,data.key,data.roomId,targetConfig,1));
                        //进入冷却状态
                        client.currentPlayer.intoRoomJoinCoolDown();
                    }else{
                        require("Log").trace("玩家："+client.currentPlayer.gameKey+" 申请加入房间失败!");
                        client.send(sm.CreateRoomReturn(data.result,'','','',0));
                    }
                }
                client.isInApplyJoinRoom = false;
            }

            var each = function(config){
                targetConfig = config;
            }

            rpcConnectorControllor.SendByServerId(serverId,"RMRoom","JoinRoom",{"roomId" : roomId},joinCb,each);
        }else{
            client.isInApplyJoinRoom = false;
            require("Log").info("玩家："+client.currentPlayer.gameKey+" 已经在房间中，无法申请加入房间！");
        }
    },
    //自动匹配pk
    AutoPipei : function(buffer,client){
        if(!client.user){
            require("Log").error("RMRoom->AutoPipei() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMRoom->AutoPipei() 没找到player对象");
            return;
        }
        if(client.currentPlayer.roomJoinCooldown){
            require("Log").info("自动匹配冷却中");
            msgC.Send(client,'AUTOPIPEI_COOLDOWN');
            return;
        }
        require("Log").info("玩家："+client.currentPlayer.gameKey+" 申请自动匹配!");

        var inflateCb = function(err,buf){
            if(!err){
                var str = buf.toString();
                var jObj = JSON.parse(str);
                var playerData = jObj.playerData;
                var pipeiData = jObj.pipeiData;//匹配相关数据

                if(client.currentPlayer.roomId == -1){
                    require("Log").trace("playerData："+JSON.stringify(playerData));
                    //记录客户端发上来的数据
                    client.currentPlayer.playerData = playerData;


                    var data = {
                        "gameKey" : client.currentPlayer.gameKey,
                        "gameServerId" : client.user.gameServerId,
                        "pipeiData" : pipeiData
                    };
                    var cb = function(err,cbdata){
                        if(!err){
                            if(!client.isQuit){
                                var err = cbdata.err;

                                if(err == 'SERVER_READY_CLOSE'){
                                    //服务器准备关闭
                                    //通知客户端
                                    client.send(smCommon.GetMsgId('SERVER_READY_CLOSE'));
                                }else if(err == 'ALREADY_IN_PIPEI'){
                                    //已经在匹配列表中
                                    //通知客户端
                                    client.send(smCommon.GetMsgId('ALREADY_IN_PIPEI'));
                                }

                                var result = err?0:1;
                                client.send(sm.AutoPipeiReturn(result));
                            }
                        }else{
                            client.send(sm.AutoPipeiReturn(0));
                            require("Log").error("向副本管理器申请自动匹配出错！err:"+err);
                        }
                    }
                    rpcConnectorControllor.BrocastByPath("FbManager","RMAutoPipei","AutoPipei",data,cb);
                }else{
                    msgC.Send(client,'ALREADY_IN_ROOM');
                    require("Log").info("玩家已经在副本中，无法申请自动匹配!gameKey:"+client.currentPlayer.gameKey);
                }
            }else{
                require('Log').error('RMRoom->AutoPipei() err:'+err);
            }
        }

        //解压
//        require('zlib').inflate(buffer,inflateCb);

        inflateCb(null,buffer);
    },
    //取消自动匹配
    CancelAutoPipei : function(buffer,client){
        if(!client.user){
            require("Log").error("RMRoom->CancelAutoPipei() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMRoom->CancelAutoPipei() 没找到player对象");
            return;
        }
        require("Log").info("玩家："+client.currentPlayer.gameKey+" 申请取消自动匹配!");

        var data = {
            "gameKey" : client.currentPlayer.gameKey
        }
        var cb = function(err,data){
            if(!err){
                var err = data.err;
                var result = err?0:1;
                client.send(sm.CancelAutoPipeiReturn(result));
            }else{
                require("Log").error("取消自动匹配出错！gameKey:"+client.currentPlayer.gameKey);
            }
        }
        rpcConnectorControllor.BrocastByPath("FbManager","RMAutoPipei","CancelAutoPipei",data,cb);
    },


    //匹配护镖
    AutoPipeiEscort : function(buffer,client){
        if(!client.user){
            require("Log").error("RMRoom->AutoPipeiEscort() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMRoom->AutoPipeiEscort() 没找到player对象");
            return;
        }
        require("Log").info("玩家："+client.currentPlayer.gameKey+" 申请匹配护镖!");
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var playerData = jObj.playerData;
        var pipeiData = jObj.pipeiData;//匹配相关数据

        var data = {
            "gameKey" : client.currentPlayer.gameKey,
            "gameServerId" : client.user.gameServerId,
            "pipeiData" : pipeiData,
            "playerData": playerData,
            "escortData":{
                "playerHp":0,
                "carTime":0,
                "carHp":0,
                "carX":0,
                "carY":0
            }
        };
        var cb = function(err,cbdata){
            if(!err){
                if(!client.isQuit){
                    var err = cbdata.err;

                    if(err == 'SERVER_READY_CLOSE'){
                        //服务器准备关闭
                        //通知客户端
                        client.send(smCommon.GetMsgId('SERVER_READY_CLOSE'));
                    }else if(err == 'ALREADY_IN_PIPEI'){
                        //已经在匹配列表中
                        //通知客户端
                        client.send(smCommon.GetMsgId('ALREADY_IN_PIPEI'));
                    }

                    var result = err?0:1;
                    //client.send(smEscort.MatchEscortReturn(result));
                }
            }else{
                //client.send(smEscort.MatchEscortReturn(0));
                require("Log").error("向副本管理器申请自动匹配出错！err:"+err);
            }
        }

        rpcConnectorControllor.BrocastByPath("EscortManager","RMMatchEscort","MatchEscort",data,cb);
    },
    //更新护镖数据
    AutoPipeiEscortUpdate : function(buffer,client){
        if(!client.user){
            require("Log").error("RMRoom->AutoPipeiEscort() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMRoom->AutoPipeiEscort() 没找到player对象");
            return;
        }
        require("Log").trace("玩家："+client.currentPlayer.gameKey+" 更新护镖数据!");
        var str = buffer.toString();
        var jObj = JSON.parse(str);

        var data = {
            "gameKey" : client.currentPlayer.gameKey,
            "gameServerId" : client.user.gameServerId,
            "escortData":{
                "playerHp" : jObj.playerHp,
                "carTime" : jObj.carTime,
                "carHp": jObj.carHp,
                "carX": jObj.carX,
                "carY": jObj.carY
            }
        };

        rpcConnectorControllor.BrocastByPath("EscortManager","RMMatchEscort","MatchEscortUpdate",data);
    },
    //取消护镖自动匹配
    CancelAutoPipeiEscort : function(buffer,client){
        if(!client.user){
            require("Log").error("RMRoom->CancelAutoPipei() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMRoom->CancelAutoPipei() 没找到player对象");
            return;
        }
        require("Log").info("玩家："+client.currentPlayer.gameKey+" 申请取消匹配护镖劫镖!");

//        var str = buffer.toString();
//        var jObj = JSON.parse(str);
        var data = {
            "gameKey" : client.currentPlayer.gameKey
        }
        var cb = function(err,data){
            if(!err){
                var err = data.err;
                var result = err?err:1;
                client.send(smEscort.CancelMatchEscortReturn(result));
            }else{
                require("Log").error("取消匹配护镖劫镖出错！gameKey:"+client.currentPlayer.gameKey);
            }
        }
        rpcConnectorControllor.BrocastByPath("EscortManager","RMMatchEscort","CancelMatchEscort",data,cb);
    }
}
