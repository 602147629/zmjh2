var CopyToMysqlControllor = {};
var redis = require("redis");
//数据库
var db = require("../../../db/DataBase.js");
var cdc = require("../../../controllor/ConfigDataControllor.js")
var client;//redis端
var todayLoginUser = {};//当天有登陆过的用户集合
var todayLoginPlayer = {};//当天有登陆过的角色集合
var todatLoginBag = {};//当天有登陆过的背包集合

/*离线消息处理流程：入库的时候，先把当天已经清理过的玩家的数据全部清除，再写入当天新增的玩家离线消息*/
var todayLoginOffline = {};//当天有登陆过的离线消息玩家集合
var todayLoginClearOffline = {};//当天已经处理过的登录玩家的离线消息集合


var EXPIRE_TIME = 86400*2;

//初始化
CopyToMysqlControllor.Init = function(){
    client = redis.createClient(cdc.GetConfigByName("ServersUnion.json").redisPort,cdc.GetConfigByName("ServersUnion.json").redisHost);
    client.on("error", function (err) {
        require("Log").error("Handler error!err:" + err);
    });
}

//新建玩家数据
CopyToMysqlControllor.NewUserData = function(uid,serverId){
    var newUser = {
        "uid" : uid,
        "serverId" : serverId,
        "lastLoginTime" : 1,
        "lastLogoutTime" : 1,
        "continueLoginDays" : 1,
        "totalLoginDays" : 1,
        "maxContinueLogindays" : 1,
        "loginTimes" : 0
    }

    var data = JSON.stringify(newUser);
    CopyToMysqlControllor.SetUserData(uid,serverId,data);

    return newUser;
}

//设置玩家数据
CopyToMysqlControllor.SetUserData = function(uid,serverId,data){
    var loginKey = uid+"|"+serverId;
    var jData = data;
    if(typeof(data) == "string"){
        var jData = JSON.parse(data);
    }
    if(jData.uid == undefined
        || jData.serverId == undefined
        || jData.lastLoginTime == undefined
        || jData.lastLogoutTime == undefined
        || jData.continueLoginDays == undefined
        || jData.totalLoginDays == undefined
        || jData.maxContinueLogindays == undefined
        || jData.loginTimes == undefined
        ){
        require("Log").error("SetUserData data error!data:"+JSON.stringify(jData));
        return;
    }
    if(typeof(data) == "object"){
        data = JSON.stringify(data);
    }
    var key = "user_"+loginKey;
    require("Log").trace("SetUserData key:"+key+",data:"+data);
    client.set(key,data,function(err,reply){
        if(err){
            require("Log").error("=====set user data complete!err:"+err+",reply:"+reply);
        }else{
            client.expire(key,EXPIRE_TIME);
            todayLoginUser[key] = 1;
        }
    });
}


//新建玩家数据
CopyToMysqlControllor.NewPlayerData = function(loginKey,name,cb){
    //获取自增ID
    var returnData = {};
    client.incr("playerId_"+loginKey,function(err,data){
        require("Log").trace("NewPlayerData->pid:"+data);
        if(!err){
            if(!data || data == undefined){
                require("Log").error("CopyToMysqlControllor.NewPlayerData get pid error!loginKey:"+loginKey);
            }
            var pid = data;
            var newPlayer = {
                "loginKey" : loginKey,
                "pid" : pid,
                "lastLoginTime" : 1,
                "lastLogoutTime" : 1,
                "loginTimes" : 0,
                "continueLoginTime" : 0,
                "name" : name,
                "level" : 1,
                "exp" : 0
            }
            CopyToMysqlControllor.SetPlayerData(loginKey,pid,newPlayer,cb);
        }else{
            require("Log").error("NewPlayerData->client.incr error!");
        }
    });
}

//设置角色数据
CopyToMysqlControllor.SetPlayerData = function(loginKey,pid,data,cb){
    var jData = data;
    if(typeof(data) == "string"){
        var jData = JSON.parse(data);
    }
    if(jData.loginKey == undefined){
        require("Log").error("SetPlayerData data error!jData.loginKey:"+jData.loginKey);
        return;
    }
    if(jData.lastLoginTime == undefined){
        require("Log").error("SetPlayerData data error!jData.lastLoginTime:"+jData.lastLoginTime);
        return;
    }
    if(jData.lastLogoutTime == undefined){
        require("Log").error("SetPlayerData data error!jData.lastLogoutTime:"+jData.lastLogoutTime);
        return;
    }
    if(jData.loginTimes == undefined){
        require("Log").error("SetPlayerData data error!jData.loginTimes:"+jData.loginTimes);
        return;
    }
    if(jData.continueLoginTime == undefined){
        require("Log").error("SetPlayerData data error!jData.continueLoginTime:"+jData.continueLoginTime);
        return;
    }
    if(jData.name == undefined){
        require("Log").error("SetPlayerData data error!jData.name:"+jData.name);
        return;
    }
    if(jData.level == undefined){
        require("Log").error("SetPlayerData data error!jData.level:"+jData.level);
        return;
    }
    if(jData.exp == undefined){
        require("Log").error("SetPlayerData data error!jData.exp:"+jData.exp);
        return;
    }

    var temp = data;
    if(typeof(data) == "object"){
        temp = JSON.stringify(data);
    }
    require("Log").trace("SetPlayerData data:"+temp);
    var table = "player_"+loginKey;
    require("Log").trace("========================================SetPlayerData->table:"+table+",pid:"+pid+",data:"+temp);
    var key = pid+"";
    client.hset(table,key,temp,function(err,reply){
        if(err){
            require("Log").error("=====hset player data complete!err:"+err+",data:"+temp);
        }else{
            client.expire(table,EXPIRE_TIME);
            todayLoginPlayer[table] = 1;
        }
        if(cb){
            cb(err,data);
        }
    });
}



//新建背包数据
CopyToMysqlControllor.NewBagData = function(gameKey,cb){
    var data = {
        "gameKey" : gameKey,
        "max" : 5,
        "items" : ""
    };
    CopyToMysqlControllor.SetBagData(gameKey,data,cb);
}


//设置角色数据
CopyToMysqlControllor.SetBagData = function(gameKey,data,cb){
    var jData = data;
    if(typeof(data) == "string"){
        var jData = JSON.parse(data);
    }
    if(jData.gameKey == undefined || jData.max == undefined || jData.items == undefined){
        require("Log").error("SetBagData data error!data:"+JSON.stringify(jData));
        return;
    }

    var d = data;
    if(typeof(data) == "object"){
        d = JSON.stringify(data);
    }
    require("Log").trace("SetBagData data:"+d);
    var key = "bag_"+gameKey;
    client.set(key,d,function(err,reply){
        if(err){
            require("Log").error("=====set bag data complete!err:"+err+",reply:"+reply);
        }else{
            client.expire(key,EXPIRE_TIME);
            todatLoginBag[key] = 1;
        }
        cb(err,data);
    });
}


//获取User数据
CopyToMysqlControllor.GetUserData = function(loginKey,cb){
    var key = "user_"+loginKey;
    client.get(key,function(err,reply){
        if(err || !reply){
            //没有取到数据,去数据库取
            require("Log").trace("没有在redis里找到玩家:"+key+" 的user数据");
            //拆解登录key
            var arr = loginKey.split("|");
            var uid = arr[0];
            var serverId = arr[1];
            db.ReadUser(uid,serverId,function(err,data){
                if(err){
                    require("Log").error("GetUserData查询数据库失败！:"+key+" 的user数据,err:"+err);
                    if(cb){
                        cb(err);
                    }
                }else{
                    //成功
                    if(data.length === 0){
                        require("Log").trace("没有在mysql里找到玩家:"+key+" 的user数据");
                        require("Log").trace("新玩家:"+key);
                        //新玩家,初始化数据
                        var returnData = CopyToMysqlControllor.NewUserData(uid,serverId);
                        if(cb){
                            cb(null,returnData);
                        }
                    }else{
                        require("Log").trace("老玩家:"+key);
                        //老玩家
                        CopyToMysqlControllor.SetUserData(uid,serverId,data[0]);
                        if(cb){
                            cb(null,data[0]);
                        }
                    }
                }
            });
        }else{
            //取到数据
            require("Log").trace("在redis里找到玩家:"+key+" 的user数据,data:"+reply.toString());
            if(cb){
                cb(null,JSON.parse(reply));
            }
            client.expire(key,EXPIRE_TIME);
            todayLoginUser[key] = 1;
        }
    });
}

//创建新玩家
CopyToMysqlControllor.CreatePlayerData = function(loginKey,name,cb){
    CopyToMysqlControllor.NewPlayerData(loginKey,name,cb);
}

//获取Player数据
CopyToMysqlControllor.GetPlayerData = function(loginKey,cb){
    var table = "player_"+loginKey;
    client.hkeys(table,function(err,reply){
        if(err || reply.length === 0){
            //没有取到数据,去数据库取
            require("Log").trace("没有在redis里找到玩家:"+table+" 的player数据");
            db.ReadPlayer(loginKey,function(err,data){
                if(err){
                    require("Log").error("GetPlayerData查询数据库失败！loginKey:"+loginKey+" 的player数据,err:"+err);
                    if(cb){
                        cb(err);
                    }
                }else{
                    //成功
                    if(data.length === 0){
                        require("Log").trace("没有在mysql里找到玩家:"+table+" 的player数据");
                        //没有角色
                        //CopyToMysqlControllor.NewPlayerData(uid,serverId,cb);
                        if(cb){
                            cb(null,[]);
                        }
                    }else{
                        //老玩家
                        require("Log").trace("在mysql里找到玩家:"+table+" 的player数据");
                        var players = [];
                        data.forEach(function(player){
                            players.push(player);
                            CopyToMysqlControllor.SetPlayerData(player.loginKey,player.pid,player);
                        });
                        if(cb){
                            cb(null,players);
                        }
                    }
                }
            });
        }else{
            require("Log").trace("在redis里找到玩家:"+table+" 的player数据,data:"+JSON.stringify(reply));
            //取到数据
            var players = [];
            var series = [];

            reply.forEach(function(key,idx){
                series.push(function(cb){
                    client.hget(table,key,function(err,value){
                        players.push(JSON.parse(value));
                        cb();
                    });
                });
            });

            require('async').series(series,function(){
                if(cb){
                    cb(null,players);
                }
            });
            client.expire(table,EXPIRE_TIME);
            todayLoginPlayer[table] = 1;
        }
    });
}


//创建新背包
CopyToMysqlControllor.CreateBagData = function(gameKey,cb){
    CopyToMysqlControllor.NewBagData(gameKey,function(err,data){
        if(cb){
            cb(err,data);
        }
    });
}

//获取Bag数据
CopyToMysqlControllor.GetBagData = function(gameKey,cb){
    var key = "bag_"+gameKey;
    client.get(key,function(err,reply){
        if(err || !reply){
            //没有取到数据,去数据库取
            require("Log").trace("没有在redis里找到玩家:"+key+" 的bag数据");
            db.ReadBag(gameKey,function(err,data){
                if(err){
                    require("Log").error("GetBagData查询数据库失败！:"+key+" 的bag数据,err:"+err);
                    if(cb){
                        cb(err);
                    }
                }else{
                    //成功
                    if(data.length === 0){
                        require("Log").trace("没有在mysql里找到玩家:"+key+" 的bag数据");
                        //新玩家,初始化数据
                        CopyToMysqlControllor.NewBagData(gameKey,function(err,data){
                            if(cb){
                                cb(null,data);
                            }
                        });
                    }else{
                        require("Log").trace("在mysql里找到玩家:"+key+" 的bag数据,data:"+data[0]);
                        //老玩家
                        CopyToMysqlControllor.SetBagData(gameKey,data[0],function(err,data){
                            if(cb){
                                cb(err,data);
                            }
                        });
                    }
                }
            });
        }else{
            //取到数据
            require("Log").trace("在redis里找到玩家:"+key+" 的bag数据,data:"+reply.toString());
            if(cb){
                cb(null,JSON.parse(reply));
            }
            client.expire(key,EXPIRE_TIME);
            todatLoginBag[key] = 1;
        }
    });
}


//获取离线数据
CopyToMysqlControllor.GetOfflineData = function(gameKey,cb){
    var table = "offline_"+gameKey;
    client.hkeys(table,function(err,reply){
        if(err || reply.length === 0){
            //没有取到数据,去数据库取
            require("Log").trace("没有在redis里找到玩家:"+table+" 的offline数据");
            db.ReadOffline(gameKey,function(err,data){
                if(err){
                    require("Log").error("GetOfflineData查询数据库失败！:"+table+" 的offline数据,err:"+err);
                    if(cb){
                        cb(err);
                    }
                }else{
                    //成功
                    if(data.length === 0){
                        require("Log").trace("没有在mysql里找到玩家:"+table+" 的offline数据");
                        if(cb){
                            cb(null,[]);
                        }
                    }else{
                        require("Log").trace("在mysql里找到玩家:"+table+" 的offline数据");
                        var offlines = [];
                        data.forEach(function(offline){
                            offlines.push(offline);
                            CopyToMysqlControllor.AddOfflineDeal(offline.gameKey,offline);
                        });
                        if(cb){
                            cb(null,offlines);
                        }
                    }
                }
            });
        }else{
            require("Log").trace("在redis里找到玩家:"+table+" 的offline数据,data:"+JSON.stringify(reply));
            //取到数据
            var offlines = [];
            var series = [];

            reply.forEach(function(key,idx){
                series.push(function(cb){
                    client.hget(table,key,function(err,value){
                        offlines.push(JSON.parse(value));
                        cb();
                    });
                });
            });

            require('async').series(series,function(){
                if(cb){
                    cb(null,offlines);
                }
            });
        }
    });
}

//增加角色离线处理消息数据
CopyToMysqlControllor.AddOfflineDeal = function(gameKey,data){
    if(typeof(data) == "object"){
        data = JSON.stringify(data);
    }

    require("Log").trace("SetOfflineDeal data:"+data);
    var table = "offline_"+gameKey;
    client.incr("offlineid",function(err,cr){
       if(!err){
           var key = cr+"";
           client.hset(table,key,data,function(err,reply){
               if(err){
                   require("Log").error("=====hset offline data complete!err:"+err+",data:"+data);
               }else{
                   client.expire(table,EXPIRE_TIME);
                   todayLoginOffline[table] = 1;
               }
           });
       }else{
           require("Log").error("获得offlineid错误！gameKey:"+gameKey+",data:"+data);
       }
    });
}


//清除某个玩家的所有离线未处理信息
CopyToMysqlControllor.ClearOfflineDeal = function(gameKey){
    require("Log").trace("ClearOfflineDeal gameKey:"+gameKey);
    var table = "offline_"+gameKey;
    client.del(table,function(err,reply){
        todayLoginClearOffline[table] = 1;
    });
}


//同步给mysql
CopyToMysqlControllor.copyToMysql = function(cb){
    var series = [];

    var count = 0;
    var keys;

    series.push(function(cb){
        count = 0;
        keys = Object.keys(todayLoginUser);
        require("Log").info("==============StartUserToMysql===============count:"+keys.length);
        if(keys.length === 0){
            cb();
        }else{
            todayLoginUser = {};
            keys.forEach(function(key){
                client.get(key,function(err,replay){
                    if(!err && replay){
                        count++;
                        db.WriteUser(JSON.parse(replay),function(err,data){
                            if(err){
                                require("Log").error("WriteUserToMysql error!key:"+key+",err:"+err);
                            }
                            count--;
                            if(count === 0){
                                cb();
                            }
                        });
                    }else{
                        require("Log").error("redis to mysql error!err:"+err+",replay:"+replay);
                    }
                });
            })
        }
    });

    series.push(function(cb){
        count = 0;
        keys = Object.keys(todatLoginBag);
        require("Log").info("==============StartBagToMysql===============count:"+keys.length);
        if(keys.length === 0){
            cb();
        }else{
            todatLoginBag = {};
            keys.forEach(function(key){
                client.get(key,function(err,replay){
                    if(!err && replay){
                        count++;
                        db.WriteBag(JSON.parse(replay),function(err,data){
                            count--;
                            if(err){
                                require("Log").error("WriteBagToMysql error!key:"+key+",err:"+err);
                            }
                            if(count === 0){
                                cb();
                            }
                        });
                    }else{
                        require("Log").error("redis to mysql error!err:"+err+",replay:"+replay+",key:"+key);
                    }
                });
            })
        }
    });

    series.push(function(cb){
        count = 0;
        keys = Object.keys(todayLoginPlayer);
        require("Log").info("==============StartPlayerToMysql===============count:"+keys.length);
        if(keys.length == 0){
            cb();
        }else{
            todayLoginPlayer = {};
            keys.forEach(function(table){
                client.hkeys(table,function(err,reply){
                    if(!err){
                        reply.forEach(function(key,idx){
                            count++;
                            client.hget(table,key,function(err,value){
                                if(!err){
                                    db.WritePlayer(JSON.parse(value),function(err,data){
                                        if(err){
                                            require("Log").error("WritePlayerToMysql error!key:"+key+",err:"+err);
                                        }
                                        count--;
                                        if(count== 0){
                                            //全部结束
                                            cb();
                                        }
                                    });
                                }else{
                                    require("Log").error("WritePlayerToMysql hget error!key:"+key+",err:"+err);
                                }
                            });
                        })
                    }else{
                        require("Log").error("WritePlayerToMysql hkeys error!table:"+table+",err:"+err);
                    }
                });
            });
        }
    });



    series.push(function(cb){
        count = 0;
        keys = Object.keys(todayLoginClearOffline);
        require("Log").info("==============StartClearOfflineToMysql===============count:"+keys.length);
        if(keys.length === 0){
            cb();
        }else{
            todayLoginClearOffline = {};
            keys.forEach(function(table){
                count++;
                var pid = parseInt(table.split("_")[1]);
                db.DeleteOffline(pid,function(err,data){
                    count--;
                    if(count == 0){
                        cb();
                    }
                });
            })
        }
    });


    series.push(function(cb){
        count = 0;
        keys = Object.keys(todayLoginOffline);
        require("Log").info("==============StartOfflineToMysql===============count:"+keys.length);
        if(keys.length == 0){
            cb();
        }else{
            todayLoginOffline = {};
            keys.forEach(function(table){
                client.hkeys(table,function(err,reply){
                    if(!err){
                        reply.forEach(function(key,idx){
                            count++;
                            client.hget(table,key,function(err,value){
                                if(!err){
                                    var gameKey = table.split("_")[1];
                                    db.WriteOffline(gameKey,value,function(err,data){
                                        if(err){
                                            require("Log").error("WriteOfflineToMysql error!table:"+table+",key:"+key+",err:"+err);
                                        }
                                        count--;
                                        if(count== 0){
                                            //全部结束
                                            cb();
                                        }
                                    });
                                }else{
                                    require("Log").error("WriteOfflineToMysql hget error!key:"+key+",err:"+err);
                                }
                            });
                        })
                    }else{
                        require("Log").error("WriteOfflineToMysql hkeys error!table:"+table+",err:"+err);
                    }
                });
            });
        }
    });

    require('async').series(series,function(){
        setTimeout(cb,1000);
    });
}



module.exports = CopyToMysqlControllor;