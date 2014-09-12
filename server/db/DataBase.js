var generic_pool = require('generic-pool');
var cdc = require("../controllor/ConfigDataControllor.js")

var pool;
var isInit = false;

function initPool(cb){
	pool = generic_pool.Pool({  
	    name: 'mysql',  
	    max: 10,  
	    create: function(callback) {  
	        var Client = require('mysql').createConnection({  
	            host:cdc.GetConfigByName("ServersUnion.json").dbhost,
	            user:cdc.GetConfigByName("ServersUnion.json").dbuser,
	            password:cdc.GetConfigByName("ServersUnion.json").dbpwd,
	            database: cdc.GetConfigByName("ServersUnion.json").dbname
	        });
	        callback(null,Client);  
	    },  
	    destroy: function(db) {  
	        db.end();  
	    },
        max:20,
        min:5,
	    idleTimeoutMillis : 3000,
    	log : false
	});  

	initTable(cb);
}


function query(sql,cb){
    require("Log").trace("query-sql:"+sql);
	pool.acquire(function(err, client) {  
        if (err) {
            require('Log').error('acquire error!->err:'+err+",\nsql:"+sql);
            if(cb){
                cb(err);
            }
        }else {
            client.query(sql, [], function(err,data) {
                if(err){
                    require('Log').error('query error!->err:'+err+",\nsql:"+sql);
                }
                pool.release(client);
                if(cb){
                    cb(err,data);
                }
            });
        }
    });
}

function initTable(cb){
    var series = [];

    series.push(function(cb){
        initUser(cb);
    });
    series.push(function(cb){
        initPlayer(cb);
    });
    series.push(function(cb){
        initBag(cb);
    });
    series.push(function(cb){
        initOffline(cb);
    });

    require('async').series(series,cb);
}


function initUser(cb){
    //IF NOT EXISTS (SELECT * FROM sysobjects WHERE object_id = OBJECT_ID(N'表名') AND type in (N'U'))
	var sql = "CREATE TABLE IF NOT EXISTS User "+
	    "(uid int(8) not null,"+
        "serverId int(4) not null,"+
        "PRIMARY KEY (uid,serverId), " +
        "lastLoginTime long,"+
        "lastLogoutTime long,"+
        "continueLoginDays int(4), "+//当前连续登录天数
        "totalLoginDays int(4), "+//总登录天数
        "maxContinueLogindays int(4), "+//历史最大连续登录天数
        "loginTimes int(4))";

	query(sql,cb);
}

function initPlayer(cb){
	var sql = "CREATE TABLE IF NOT EXISTS Player "+
	"(loginKey char(20) not null primary key,"+
        "pid int(4),"+
		"lastLoginTime long,"+
		"lastLogoutTime long,"+
        "continueLoginTime long,"+
		"loginTimes int(4),"+
		"name char(20),"+
		"level int(4),"+
		"exp int(4))";//根据服务器Id来设定playerid的最小值

	query(sql,cb);
}

function initBag(cb){
    var sql = "CREATE TABLE IF NOT EXISTS Bag"+
        "(gameKey char(20) primary key not null,"+
        "items long,"+//道具json
        "max int(4))";//最大格子数量

    query(sql,cb);
}


function initOffline(cb){
    var sql = "CREATE TABLE IF NOT EXISTS Offline"+
        "(id bigint(20) primary key not null AUTO_INCREMENT,"+
        "gameKey char(20),"+
        "data long)";//离线数据

    query(sql,cb);
}


module.exports = {
    InitPool : function(cb){
        if(isInit){
            return;
        }else{
            isInit = true;
        }
        initPool(cb);
    },
	//入库玩家数据
	WriteUser : function(user,cb){
        require("Log").trace('---WriteUser---');
		var sql = "REPLACE INTO User "+
		"(uid,serverId,lastLoginTime,lastLogoutTime,loginTimes,continueLoginDays,totalLoginDays,maxContinueLogindays) "+
		"values("+
			user.uid+","+user.serverId+","+user.lastLoginTime+","+user.lastLogoutTime+","+user.loginTimes+","+user.continueLoginDays+","+user.totalLoginDays+","+user.maxContinueLogindays+")";

		query(sql,cb);
	},
	//根据uid获取玩家数据
	ReadUser : function(uid,serverId,cb){
		var sql = "select * from User where uid = "+uid +" and serverId = "+serverId;

		query(sql,cb);
	},
	//根据uid获取玩家角色数据
	ReadPlayer : function(loginKey,cb){
		var sql = "select * from Player where loginKey = '"+loginKey+"'";

        query(sql,cb);
	},
    //根据pid获取玩家离线数据
    ReadOffline : function(gameKey,cb){
        var sql = "select * from Offline where gameKey = '"+gameKey+"'";

        query(sql,cb);
    },
    //写入离线消息
    WriteOffline : function(gameKey,offline,cb){
//        require("Log").trace('---WriteBag---');
        var sql = "INSERT INTO Offline ("+
            "gameKey,data) values ('"+
            gameKey+"','"+offline+"')";

        query(sql,cb);
    },
    //删除离线消息
    DeleteOffline : function(gameKey,cb){
//        require("Log").trace('---WriteBag---');
        var sql = "DELETE FROM Offline WHERE gameKey = '"+gameKey+"'";

        query(sql,cb);
    },
	//角色
	WritePlayer : function(player,cb){
//        require("Log").trace('---WritePlayer---');
        var sql = "REPLACE INTO Player ("+
            "loginKey,pid,lastLoginTime,lastLogoutTime,loginTimes,continueLoginTime,name,level,exp) values ('"+
            player.loginKey+"',"+player.pid+","+player.lastLoginTime+","+player.lastLogoutTime+","+player.loginTimes+","+player.continueLoginTime+",'"+player.name+"',"+player.level+","+player.exp+")";

		query(sql,cb);
	},
	//背包
	WriteBag : function(bag,cb){
//        require("Log").trace('---WriteBag---');
		var sql = "REPLACE INTO Bag ("+
            "gameKey,items,max) values ('"+
            bag.gameKey+"','"+bag.items+"',"+bag.max+")";

		query(sql,cb);
	},
	//读取背包
	ReadBag : function(gameKey,cb){
		var sql = "select * from Bag where gameKey = '"+gameKey+"'";

		query(sql,cb);
	},
    //线程销毁时调用
    Drain : function(){
        pool.drain(function() {
            pool.destroyAllNow();
        });
    }
}