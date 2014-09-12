var fs = require('fs');

var path = require('path');

var file;
var allFiles = {};


//const PROTOCAL_URL = "http://192.168.54.107/test/data/protocal.json?"+(new Date()).getTime();


module.exports = {
    //本服服务器ID
    ServerId : 0,
    //本服务端配置文件
    ServerConfig : {},
    //整个server.json配置文件
    AllServersConfig : {},
	LoadByPath : function(filesPath,cb){
		//加载配置文件
		var files = fs.readdirSync(filesPath);
        require('Log').trace("filesPath:"+filesPath);
		files.forEach(function(fileName){
			var extName = path.extname(fileName);
			//确认格式
			if(extName == ".json"){
				file = fs.readFileSync(filesPath+fileName,'utf8');
                require("Log").trace("config->fileName:"+fileName);
                var jObj = JSON.parse(file);
				allFiles[fileName] = jObj;
			}else{
				//非json文件，不处理
                //require("Log").error('LoadConfigs error!File type is not JSON!fileName:'+fileName);
			}
		});

		//远程加载协议
//        require("Log").trace('loading protocol file-start!');
//		var protocol = get({uri:PROTOCAL_URL});
//		protocol.asString(function(err, str) {
//			if(err){
//                require("Log").error('loading protocol file-error!err:'+err);
//				return;
//			}
//			var jObj = JSON.parse(str);
//			protocal.InitWithConfig(jObj);
//		});
//        require("Log").trace('loading protocol file-complete!');

		if(cb){
			cb(null);
		}
	},
	GetConfigByName : function(fileName){
		if(allFiles[fileName]){
			return allFiles[fileName];
		}else{
            require("Log").error('Not this JSON found!fileName:'+fileName);
		}
	},
    //otherName,别名
    LoadFile : function(filesPath,fileName,otherName){
        var file = fs.readFileSync(filesPath+fileName,'utf8');
        otherName = otherName?otherName:fileName;
        allFiles[otherName] = JSON.parse(file);
    },
    //otherName,别名,异步
    LoadFileWithCB : function(filesPath,fileName,otherName,cb){
        fs.readFile(filesPath+fileName,'utf8',function(err,data){
            if(!err){
                otherName = otherName?otherName:fileName;
                allFiles[otherName] = JSON.parse(data);
                if(cb){
                    cb();
                }
            }else{
                if(cb){
                    cb(err);
                }
            }
        });
    }
}