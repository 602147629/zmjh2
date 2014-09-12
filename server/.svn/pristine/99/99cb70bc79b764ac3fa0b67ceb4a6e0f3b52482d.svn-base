var lineClass = require('../model/Line.js');
var sm = require("../message/handler/sm/SMLogin.js");

var allLines = [];
var allClients = [];
var isInit = false;

module.exports = {
	//按照配置表初始化
	InitWithConfig : function(config){
        if(isInit){
            return;
        }
        isInit = true;

		config.forEach(function(lineConfig){
			var line = new lineClass();
			line.id = lineConfig.id;
			line.name = lineConfig.name;
			line.max = lineConfig.max;

			allLines[line.id] = line;
		});


        //setInterval(step,66);
	},
    //更新配置
    UpdateConfig : function(config){
        var newLineIdArr = [];
        config.forEach(function(lineConfig){
            var line;
            if(allLines[lineConfig.id]){
                //已经有的线,更新配置
                line = allLines[lineConfig.id];
                line.name = lineConfig.name;
                line.max = lineConfig.max;
                line.isHide = false;
            }else{
                //新的配置，新开线
                line = new lineClass();
                line.id = lineConfig.id;
                line.name = lineConfig.name;
                line.max = lineConfig.max;

                allLines[line.id] = line;
            }

            newLineIdArr.push(lineConfig.id);
        });
        //判定隐藏线
        var oldLineIdArr = Object.keys(allLines);
        oldLineIdArr.forEach(function(oldId){
            oldId = parseInt(oldId);
            if(newLineIdArr.indexOf(oldId) == -1){
                //隐藏
                allLines[oldId].isHide = true;
            }
        });
    },
	//获取所有线信息
	GetLinesJsonInfo : function(){
		var lines = [];
		allLines.forEach(function(line){
            if(!line.isHide){
                lines.push(line.getJsonInfo());
            }
		});
		return lines
	},
	//根据gameKey获取玩家client
	GetClientByGameKey : function(gameKey){
		return allClients[gameKey]
	},
	//根据线id获取线
	GetLineById : function(lineId){
		return allLines[lineId];
	},
    //获取总人数
    GetTotalNum : function(){
        var num = 0;
        allLines.forEach(function(line){
            num += line.current;
        });
        return num;
    },
    //广播
    Brocast : function(buffer){
        allLines.forEach(function(line){
            line.brocast(buffer);
        });
//        require("SuperUtils").forEachInArray(allClients,function(client){
//            client.send(buffer);
//        });
    }
}