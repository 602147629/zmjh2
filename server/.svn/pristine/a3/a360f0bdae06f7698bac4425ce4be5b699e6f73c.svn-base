var lc = require("../../../controllor/LineControllor.js");
var sm = require("../sm/SMPlayer.js");



module.exports = {
	//增加经验、测试用
	AddExp : function(buffer,client){
        if(!client.user){
            require("Log").error("RMPlayer->AddExp() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMPlayer->AddExp() 没找到player对象");
            return;
        }
		client.currentPlayer.addExp(40);
		client.send(sm.PlayerExp(client.currentPlayer.exp));
	},
	//增加道具
	AddItem : function(buffer,client){
        if(!client.user){
            require("Log").error("RMPlayer->AddItem() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMPlayer->AddItem() 没找到player对象");
            return;
        }
		var str = buffer.toString();
		console.log('str:'+str);
		var jObj = JSON.parse(str);
		var id = jObj.itemId;
		var num = jObj.num;

		var items = client.currentPlayer.bagControllor.addItems(id,num);
		if(items){
			client.send(sm.PlayerItemsChange(items));
		}else{
			console.log('RMPlayer->AddItem error!');
		}
	},
	//删除道具
	RemoveItem : function(buffer,client){
        if(!client.user){
            require("Log").error("RMPlayer->RemoveItem() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMPlayer->RemoveItem() 没找到player对象");
            return;
        }
		var str = buffer.toString();
		console.log('str:'+str);
		var jObj = JSON.parse(str);
		var id = jObj.itemId;
		var num = jObj.num;

		var items = client.currentPlayer.bagControllor.removeItem(id,num);
		if(items){
			client.send(sm.PlayerItemsChange(items));
		}else{
			console.log('RMPlayer->RemoveItem error!');
		}
	},
	//获取背包数据
	GetBag : function(buffer,client){
        if(!client.user){
            require("Log").error("RMPlayer->GetBag() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMPlayer->GetBag() 没找到player对象");
            return;
        }
		client.send(sm.GetBag(client.currentPlayer));
	}
}
