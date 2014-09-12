var lc = require('../../../controllor/LineControllor.js');


module.exports = {
	//获取线列表返回
	GetLinesReturn : function(){
		var json = {
			"lines" : lc.GetLinesJsonInfo()
		};
		return require('BufferTools').getJsonPathBufferByDict("MyLineReceiveControl","GetLinesReturn",json);
	},
	//选线返回
    ChooseLineReturn : function(line){
        var info = line.getJsonInfo();
        require("Log").trace("选线返回:"+JSON.stringify(info));

        return require('BufferTools').getJsonPathBufferByDict("MyLineReceiveControl","ChooseLineReturn",info);
    },
    //选线返回（该线已满）
    ChooseLineFull : function(){
        return require('BufferTools').getPathBufferByDict("MyLineReceiveControl","ChooseLineFull");
    },
//	//获取所有玩家信息
//	AllPlayers : function(line){
//		var info = line.getAllPlayersJson();
//		var buf = require('BufferTools').getJsonPathBufferByDict("MyLineReceiveControl","AllPlayers",info);
//
//		//封装包头
//		return require('BufferTools').addPackageHead(buf);
//	},
    //登录的时候获取当前所有玩家的简单信息（uid，pid，name）
    AllPlayersInLogin : function(line){
        var info = line.getAllPlayersJsonInLogin();

        return require('BufferTools').getJsonPathBufferByDict("MyLineReceiveControl","AllPlayersInLogin",info);
    },
	AllRooms : function(rooms){
        var obj = {
            "rooms" : rooms
        }
		return require('BufferTools').getJsonPathBufferByDict("MyLineReceiveControl","AllRooms",obj);
	},
	PlayerJoin : function(player){
		var info = {
			"player" : player.getInfoJsonInLogin()
		};

		return require('BufferTools').getJsonPathBufferByDict("MyLineReceiveControl","PlayerJoin",info);
	},
	PlayerLeft : function(player){
		var info = {
			"gameKey" : player.gameKey
		};

		return require('BufferTools').getJsonPathBufferByDict("MyLineReceiveControl","PlayerLeft",info);
	}
}
