var generic_pool = require('generic-pool');

var pool;

function initPool(){
	pool = generic_pool.Pool({  
	    name: 'mysql',  
	    max: 10,  
	    create: function(callback) {  
	        var Client = require('mysql').createConnection({  
	            host:'192.168.51.157',  
	            user:'admin',  
	            password:'001629',  
	            database: "GameDB3"
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
}

var uid = 1;

function query(sql,cb){
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


var writeUser = function(uid,lastLoginTime,lastLogoutTime,loginTimes,cb){
	var sql = "REPLACE INTO User "+
	"(uid,lastLoginTime,lastLogoutTime,loginTimes) "+
	"values("+
		uid+","+lastLoginTime+","+lastLogoutTime+","+loginTimes+")";

	query(sql,cb);
}

var ReadUser = function(uid,cb){
	var sql = "select * from User where uid = "+uid;
	
	query(sql,cb);
}

initPool();

var completeCount = 0;

var insert = function(){
	for (var i=0;i<1000;i++){
		var date = new Date();
		var temp = uid;
		writeUser(uid,date.getTime(),date.getTime(),1,function(){
			completeCount++;
			console.log("completeCount:"+completeCount);
		});
		uid++;
	}
}

var read = function(){
	for (var i=0;i<3000;i++){
		// var date = new Date();
		ReadUser(100,function(){
			completeCount++;
			console.log("completeCount:"+completeCount);
		});
	}
}


setInterval(function(){
	// insert();
	read();
}, 500);