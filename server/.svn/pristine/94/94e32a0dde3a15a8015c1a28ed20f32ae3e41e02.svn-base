var loginc = require("../../../controllor/LoginControllor.js");
var cdc = require("../../../../../controllor/ConfigDataControllor.js");
var rcc = require("../../../../../controllor/RpcConnectorControllor.js");
var dailyC = require("../../../controllor/DailyControllor.js");
var offlineC = require("../../../controllor/OfflineControllor.js");
var msgC = require('../../../controllor/MsgControllor.js');
var sm = require("../sm/SMLogin.js");
var smGate = require("../../remote/sm/SMToGate.js")
//用户
var userClass = require("../../../model/User.js");
//角色
var playerClass = require("../../../model/Player.js");

//角色信息读取完毕
function readPlayerFromMysqlCallBack(client,loginKey,err,results){
	if(client.isQuit){
		return;
	}
	if(!err){
		//角色对象
        require("Log").trace("读取player表回调results:"+JSON.stringify(results));
		var players = [];
		for(var i=0;i<results.length;i++){
			var player = new playerClass();
			player.loginTime = new Date().getTime();
			player.loginKey = loginKey;
//            player.platformUid = uid;
            player.initWithData(results[i]);
			//位置索引，用于与客户端交互
			player.index = i;
			players.push(player.getInfoJson());

            //player读档完毕
            player.isReadComplete = true;

			client.players.push(player);
		}

        //返回给玩家，告诉玩家所有的角色信息
        client.send(sm.GetUsersByUid(client.user,players));

//        var fileLen = 0;
//
//        var loginCb = function(){
//            fileLen--;
//            if(fileLen == 0){
//                //返回登录成功
//                client.send(sm.GetUsersByUid(client.user,players));
//            }
//        }
//
//
//        var each = function(){
//            fileLen++;
//        }
//
//        //通知Gate，登录成功
//        rcc.BrocastByPath("Gate","RMGate","UserLogin",{"loginKey":loginKey},loginCb,each);
	}else{
		//获取用户信息失败
        require("Log").error("读取角色数据失败！loginKey:"+client.user.loginKey);
	}
}

//从数据库读取玩家数据
function ReadPlayer(loginKey,client){
    if(client.isQuit){
        return;
    }
    //添加到所有玩家管理器
    client.isStartLogin = true;
    loginc.AddClient(client);

    //读取用户表回调
    var userCb = function(user,err,data){
        if(!err){
            if(data.loginTimes > 0){
                require("Log").trace("玩家："+loginKey+" 读取玩家数据完毕，老用户");
                //老用户
                user.loginTimes = data.loginTimes+1;


                //登录的时候处理是否新的一天的登录、登出的时候处理登录时间大于1天的情况(GameClient.js)
                var lastLogoutTime = data.lastLogoutTime;
                var continueLoginDays = data.continueLoginDays;
                var maxContinueLogindays = data.maxContinueLogindays;
                var totalLoginDays = data.totalLoginDays;

                user.continueLoginDays = continueLoginDays;
                user.maxContinueLogindays = maxContinueLogindays;
                user.totalLoginDays = totalLoginDays;

                if(lastLogoutTime > 0){
                    var dotayDate = new Date();
                    var toTime = dotayDate.getTime();
                    var dayDiff = require("SuperUtils").daysBetween(lastLogoutTime,toTime);
                    if(dayDiff == 1){
                        //同一天登录
                        dailyC.UserSameDayLogin(user);
                    }else{
                        //新的一天登录
                        if(dayDiff == 2){
                            //连续登录
                            //连续登录天数
                            user.continueLoginDays += 1;
                            //判定最大连续登录天数
                            if(maxContinueLogindays < user.continueLoginDays){
                                maxContinueLogindays = user.continueLoginDays;
                            }
                            user.maxContinueLogindays = maxContinueLogindays;
                        }else{
                            //非连续登录
                            user.continueLoginDays = 1;
                        }
                        //总登录天数
                        user.totalLoginDays += 1;

                        dailyC.UserNewDayLogin(user);
                    }
                }
            }else if(data.loginTimes === 0){
                //新用户
                require("Log").trace("玩家："+loginKey+" 读取玩家数据完毕，新用户");
                user.loginTimes = 1;
                user.continueLoginDays = 1;
                user.totalLoginDays = 1;
                user.maxContinueLogindays = 1;

                dailyC.UserNewDayLogin(user);
            }
        }
    }


    //读取用户表回调函数
    userCb = userCb.bind(null,client.user);

    var series = [];
    series.push(function(cb){
        //读取user表
        if(!client.isQuit){
            var data = {
                "loginKey" : loginKey
            };
            rcc.BrocastByPath("Rediss","RMRedis","GetUserData",data,function(err,data){
                if(!err){
                    userCb(null,data);
                    cb();
                }else{
                    require("Log").error("RMRedis->GetUserData callback error!");
                }
            });
        }else{
            cb();
        }
    });
    var playerCb = readPlayerFromMysqlCallBack.bind(null,client,loginKey);
    series.push(function(cb){
        //读取player表
        if(!client.isQuit){
            var data = {
                "loginKey" : loginKey
            };
            rcc.BrocastByPath("Rediss","RMRedis","GetPlayerData",data,function(err,data){
                if(!err){
                    playerCb(null,data);
                    cb();
                }else{
                    require("Log").error("RMRedis->GetPlayerData callback error!");
                }
            });
        }else{
            cb();
        }
    });
    require('async').series(series,null);
}

module.exports = {
	//登录游戏
	GetUsersByUid : function(buffer,client){
        if(client.user){
            require("Log").error("玩家："+client.user.loginKey+" 初始化帐号失败！本次已经初始化帐号");
            return;
        }
		var str = buffer.toString();
		var jObj = JSON.parse(str);
		var uid = parseInt(jObj.uid);
        var key = jObj.key;//登录key
        var serverId = parseInt(jObj.serverId);//玩家所选的服务器id
        var gateServerId = parseInt(jObj.gateServerId);//网关服务器进程id

        if(!serverId){
            serverId = 1;
        }


        //校验uid合法性
        if(isNaN(uid) || isNaN(serverId) || isNaN(gateServerId)){
            require("Log").error("玩家登录时uid/serverid/gateServerId格式错误!uid:"+uid+",serverId:"+serverId+",gateServerId:"+gateServerId);
            client.destroy();
            return;
        }

//        require("Log").trace("玩家："+uid+" 登录！serverId:"+serverId);
//        var serverId = cdc.ServerConfig.id;
//        var servers = cdc.GetConfigByName("ServersUnion.json").servers;
//        if(servers.indexOf(serverId) == -1){
//            //玩家发上来的服务器id不属于本服管理的服务器id，直接断掉
//            require("Log").error("玩家发上来的登录服务器id不属于我管理！我管理的id:"+JSON.stringify(servers)+",玩家发的id:"+serverId+",uid:"+uid);
//            client.destroy();
//            return;
//        }

        //用户对象
        var user = new userClass();
        user.uid = uid;
        user.serverId = serverId;
//        user.platformUid = uid;
        user.lastLoginTime = (new Date()).getTime();
        user.loginKey = uid + "|" + serverId;//帐号的唯一登录key
        user.key = key;//向gate验证登录的key
        user.gameServerId = cdc.ServerConfig.id;
        //添加用户
        client.user = user;

        //通知，执行登录了
        client.doLogin();

        require("Log").trace("玩家:"+user.loginKey+" 请求登录GAME");

        //登录key验证成功后执行
        var afterCheckKeyOk = function(){
            if(client.isQuit){
                return;
            }

            //判断玩家是否已经在线
            var oldClient = loginc.GetClientByLoginKey(user.loginKey);
            if(!oldClient){
                require("Log").trace("玩家："+user.loginKey+" 登录成功，读取玩家数据,client.user："+client.user);
                ReadPlayer(user.loginKey,client);
            }else{
                require("Log").trace("玩家："+user.loginKey+" 已经在线，踢之！");
                //踢掉之前玩家
                var writeUserCb = function(loginKey,newClient){
                    if(!newClient.isQuit){
                        ReadPlayer(loginKey,newClient);
                    }
                }
                var newCb = writeUserCb.bind(null,user.loginKey,client);
                //监听之前玩家的数据库存储事件，存储完毕后开始读档继续
                oldClient.on('writeAllComplete',newCb);
                oldClient.beKicked(sm.PlayerBeKicked());
            }
        }

        //登录key验证回调
        var checkKeyCb = function(err,data){
            if(client.isQuit){
                return;
            }

            if(!err){
                var result = data.result;
                if(result === 1){
                    //成功，查询数据库，之后将结果返回客户端
                    afterCheckKeyOk();
                }else{
                    require("Log").info("玩家："+client.user.loginKey+" 登录失败，key验证失败！");
                    //失败，通知客户端登录失败
                    client.send(sm.LoginFail());
                    client.destroy();
                }
            }else{
                require("Log").error("玩家："+client.user.loginKey+" 登录失败，RPC回调错误！");
                //失败，通知客户端登录失败
                client.send(sm.LoginFail());
                client.destroy();
            }
        }
        rcc.SendByServerId(gateServerId,"RMGate","CheckKey",{"key":key,"loginKey":client.user.loginKey,"serverId":serverId},checkKeyCb);
	},
	//选择角色
	ChoosePlayer : function(buffer,client){
        if(!client.user){
            require("Log").error("玩家选择角色失败！还没有User对象");
            return;
        }
        if(client.currentPlayer){
            require("Log").error("玩家："+client.user.loginKey+" 选择角色失败！本次已经选择了角色");
            return;
        }
		var str = buffer.toString();
		var jObj = JSON.parse(str);
		var chooseIndex = jObj.index;

        var offlineData;//离线消息，读取完后不马上处理，等待登录完成后再处理

		if(client.players.length > 0 && chooseIndex < client.players.length){
			client.currentPlayer = client.players[chooseIndex];
            client.currentPlayer.loginState = 2;

            //更新玩家的gameKey
            loginc.UpdateGameKey(client);

            require("Log").trace("玩家："+client.user.loginKey+" 选角色成功，角色ID:"+client.currentPlayer.pid);
//			//读档（背包、技能、装备等）
            var data = {
                "gameKey" : client.currentPlayer.gameKey
            }

            if(!client.currentPlayer.gameKey || client.currentPlayer.gameKey == undefined){
                require("Log").error("gameKey is null in ChoosePlayer!loginKey:"+client.user.loginKey);
            }


            var completeCb = function(){
                if(!client.isQuit){
                    //通知gate
                    rcc.BrocastByPath("Gate","RMGate","CheckKeyAfterLogin",{"key":client.user.key,"loginKey":client.user.loginKey,"gameKey":client.currentPlayer.gameKey},function(err,data){
                        if(!err){
                            var result = data.result;
                            if(!client.isQuit){
                                if(result == 1){
                                    //验证成功
                                    require("Log").trace("角色登录后key验证成功！");
                                    client.currentPlayer.isLoginComplete = true;
                                    //处理离线消息
                                    offlineC.deal(client.currentPlayer,offlineData);
                                    //返回给客户端
                                    client.send(sm.ChoosePlayerReturn(result,client.currentPlayer));

                                    var data = {
                                        "gameKey" : client.currentPlayer.gameKey,
                                        "gameServerId" : client.user.gameServerId
                                    };

//                                    rcc.BrocastByPath("PublicNoticeManager","RMFromGame","UserLogin",data);
                                }else{
                                    //验证失败
                                    require("Log").trace("角色登录后key验证失败！在登录期间，该帐号异地登录！");
                                    msgC.Send(client,"OTHER_LOGIN");
                                    client.send(sm.ChoosePlayerReturn(result,client.currentPlayer));
                                    client.destroy();
                                }
                            }else{
                                if(result == 1){
                                    //玩家已经离线，通知gate玩家离线
                                    rcc.BrocastByPath("Gate","RMGate","UserLogout",smGate.UserLogout(client.user.loginKey));
                                }
                            }
                        }else{
                            require("Log").error("RMLogin->NewPlayer() error!CheckKeyAfterLogin callback error!");
                        }
                    });
                }
            }

            var series = [];
            //读取背包表
            series.push(function(cb){
                rcc.BrocastByPath("Rediss","RMRedis","GetBagData",data,function(err,data){
                    if(!err){
                        if(!client.isQuit){
                            client.currentPlayer.bagControllor.initWithData(data);
                            client.currentPlayer.loginState = 3;
                        }
                    }else{
                        require("Log").error("RMRedis->GetBagData callback error!");
                        client.destroy();
                    }
                    cb();
                });
            });
            //读取离线表
            series.push(function(cb){
                rcc.BrocastByPath("Rediss","RMRedis","GetOfflineData",data,function(err,data){
                    if(!err){
                        if(!client.isQuit){
                            offlineData = data;
                            client.currentPlayer.loginState = 4;
                        }
                    }else{
                        require("Log").error("RMRedis->GetOfflineData callback error!");
                        client.destroy();
                    }
                    cb();
                });
            });
            require('async').series(series,completeCb);
		}else{
            require("Log").error('ChoosePlayer error!length:'+client.players.length+",chooseIndex:"+chooseIndex);
		}
	},
	//创建角色
	NewPlayer : function(buffer,client){
        if(!client.user){
            require("Log").error("玩家创建角色失败！还没有User对象");
            return;
        }
        if(client.currentPlayer){
            require("Log").error("玩家："+client.user.loginKey+" 创建角色失败！本次已经创建了角色");
            return;
        }
		var str = buffer.toString();
		var jObj = JSON.parse(str);
		var name = jObj.name;

        if(name == "" || !name){
            require("Log").error("NewPlayer name error!玩家发来的名字是空的！loginKey:"+client.user.loginKey+",name:"+jObj.name);
            name = "unname";
        }else{
            //过滤特殊字符(只保留中文、英文、数字)
            var reg = /[\u4E00-\u9FA50-9a-zA-Z]/g;
            name = name.match(reg);
            if(!name){
                name = "unname";
            }else{
                name = name.join("");
                if(name.length > 20){
                    name = name.substring(0,20);
                }
            }
            if(name == ""){
                require("Log").error("NewPlayer name error!玩家发来的名字过滤后是空的！loginKey:"+client.user.loginKey+",name:"+jObj.name);
                name = "unname";
            }
        }

		var player = new playerClass();
		player.name = name;
        player.loginKey = client.user.loginKey;
//		player.uid = client.user.uid;
        player.platformUid = client.user.platformUid;
        player.isReadComplete = true;
        client.currentPlayer = player;

        client.currentPlayer.loginState = 1;

        require("Log").trace("玩家："+client.user.loginKey+" 申请创建新角色");

		var completeCb = function(){
			//去选线,判定是否被销毁
			if(!client.isQuit){
                require("Log").trace("玩家："+client.user.loginKey+" 创建角色成功");
                //通知gate
                rcc.BrocastByPath("Gate","RMGate","CheckKeyAfterLogin",{"key":client.user.key,"loginKey":client.user.loginKey,"gameKey":client.currentPlayer.gameKey},function(err,data){
                    if(!err){
                        var result = data.result;
                        if(!client.isQuit){
                            if(result == 1){
                                //验证成功
                                require("Log").trace("角色登录后key验证成功！");
                                client.currentPlayer.isLoginComplete = true;
                                client.send(sm.ChoosePlayerReturn(result,player));

                                var data = {
                                    "gameKey" : client.currentPlayer.gameKey,
                                    "gameServerId" : client.user.gameServerId
                                };
//                                rcc.BrocastByPath("PublicNoticeManager","RMFromGame","UserLogin",data);
                            }else{
                                //验证失败
                                require("Log").trace("角色登录后key验证失败！在登录期间，该帐号异地登录！");
                                msgC.Send(client,"OTHER_LOGIN");
                                client.send(sm.ChoosePlayerReturn(result,player));
                                client.destroy();
                            }
                        }else{
                            if(result == 1){
                                //玩家已经离线，通知gate玩家离线
                                rcc.BrocastByPath("Gate","RMGate","UserLogout",smGate.UserLogout(client.user.loginKey));
                            }
                        }
                    }else{
                        require("Log").error("RMLogin->NewPlayer() error!CheckKeyAfterLogin callback error!");
                    }
                });
			}
		}

        var parallelCompleteCb = function(){
            //创建背包等，串行
            var series = [];
            if(!client.isQuit){
                series.push(function(cb){
                    var sendData = {
                        "gameKey" : client.currentPlayer.gameKey
                    }
                    client.currentPlayer.loginState = 2;
                    rcc.BrocastByPath("Rediss","RMRedis","CreateBagData",sendData,function(err,data){
                        require("Log").trace("===========CreateBagData-data:"+JSON.stringify(data));
                        if(!err){
                            if(!client.isQuit){
                                client.currentPlayer.bagControllor.initWithData(data);

                                //跳过离线消息处理这个步骤
                                client.currentPlayer.loginState = 4;
                            }
                        }else{
                            require("Log").error("RMRedis->CreatePlayerData callback error!");
                        }
                        cb();
                    });
                });
            }
            require('async').series(series,completeCb);
        }


        //创建player
        var data = {
            "loginKey" : client.user.loginKey,
            "name" : name
        }
        rcc.BrocastByPath("Rediss","RMRedis","CreatePlayerData",data,function(err,data){
            require("Log").trace("===========CreatePlayerData-data:"+JSON.stringify(data));
            if(!err){
                if(!client.isQuit){
                    client.currentPlayer.initWithData(data);
                    client.currentPlayer.loginTime = new Date().getTime();
                    client.currentPlayer.logoutTime = data.lastLogoutTime;

                    loginc.UpdateGameKey(client);
                    parallelCompleteCb();
                }
            }else{
                require("Log").error("RMRedis->CreatePlayerData callback error!");
            }
        });
	}
}
