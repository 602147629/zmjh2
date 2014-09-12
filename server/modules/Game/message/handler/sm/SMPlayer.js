
module.exports = {
	//玩家升级到
	UpgradeLevelTo : function(uid,level){
		var jsonObj = {
			"level" : level,
			"uid" : uid
		};
		return require('BufferTools').getJsonPathBufferByDict("MyPlayerReceiveControl","UpgradeLevelTo",jsonObj);
	},
	//玩家当前经验和等级
	PlayerExp : function(exp){
		var jsonObj = {
			"exp" : exp
		};

		return require('BufferTools').getJsonPathBufferByDict("MyPlayerReceiveControl","PlayerExp",jsonObj);
	},
	//玩家当前总属性
	PlayerProperty : function(property){
		var jsonObj = {
			"property" : property.getJsonInfo()
		};

		return require('BufferTools').getJsonPathBufferByDict("MyPlayerReceiveControl","PlayerProperty",jsonObj);
	},
	//玩家装备变化(增加、删除、修改),numn为零，则是删除
	PlayerItemsChange : function(items){
		var itemsJson = [];
		items.forEach(function(item){
			itemsJson.push(item.getJsonInfo())
		});

		var jsonObj = {
			"items" : itemsJson
		};

		return require('BufferTools').getJsonPathBufferByDict("MyPlayerReceiveControl","PlayerEquipmentChange",jsonObj);
	},
	//所有背包道具
	GetBag : function(player){
		var jsonObj = {
			"items" : player.bagControllor.getItemsJsonInfo()
		};

		return require('BufferTools').getJsonPathBufferByDict("MyPlayerReceiveControl","GetBag",jsonObj);
	}
}
