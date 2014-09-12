var lc = require("../../../controllor/LineControllor.js");
var sm = require("../sm/SMLine.js");
var cdc = require("../../../../../controllor/ConfigDataControllor.js");
//var rpcConnectorControllor = require("../../../../../controllor/RpcConnectorControllor.js")
var roomControllor = require("../../../controllor/RoomControllor.js");


module.exports = {
	//选线
	ChooseLine : function(buffer,client){
        if(!client.user){
            require("Log").error("RMLine->ChooseLine() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMLine->ChooseLine() 没找到player对象");
            return;
        }
		var str = buffer.toString();
		var jObj = JSON.parse(str);
		var chooseId = jObj.id;

		var chooseLine = lc.GetLineById(chooseId);
		if(!chooseLine){
			require("Log").error('选线错误!无效选线ID!id:'+chooseId);
            client.destroy();
			return;
		}
		//将玩家添加到具体的线中
        chooseLine.addClient(client,function(err){
            if(!err){
                //加入成功
                client.currentPlayer.line = chooseLine;
                client.send(sm.ChooseLineReturn(chooseLine));
                require("Log").trace("玩家："+client.user.loginKey+" 加入了 "+chooseLine.id + "线");
            }else{
                //加入失败

            }
        });
	},
	//获取所有线信息
	GetLines : function(buffer,client){
        if(!client.user){
            require("Log").error("RMLine->GetLines() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMLine->GetLines() 没找到player对象");
            return;
        }
		client.send(sm.GetLinesReturn());
	},
	//获取所有房间信息
	GetAllRooms : function(buffer,client){
        if(!client.user){
            require("Log").error("RMLine->GetAllRooms() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMLine->GetAllRooms() 没找到player对象");
            return;
        }
        client.send(sm.AllRooms(roomControllor.GetAllRooms()));
	}
}
