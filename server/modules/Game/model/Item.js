var EventEmitter = require("events").EventEmitter;

function Item(){
	EventEmitter.call(this);

	this.maxNum = 999;
}

require('util').inherits(Item, EventEmitter);


//设置id
Item.prototype.__defineGetter__('itemId',function(){
	return this._itemId;
});
Item.prototype.__defineSetter__('itemId',function(v){
	this._itemId = v;

	//根据配置，设置类型
	this.itemType = 0;
});


Item.prototype.itemType;//道具类型（0：道具，1：装备）
Item.prototype._itemId;//道具id
Item.prototype.num;//道具数量
Item.prototype.maxNum;//道具数量上限
Item.prototype.index;//道具所处背包格子索引

//构造
Item.prototype.buildFromObj = function(itemObj){
    this.itemId = itemObj.id;
    this.num = itemObj.num;
    this.index = itemObj.index;
}

//获取json格式
Item.prototype.getJsonInfo = function(){
	return {
		"id" : this.itemId,
		"num" : this.num,
        "index" : this.index
	};
}


module.exports = Item;