var EventEmitter = require("events").EventEmitter;

function Property(){
	EventEmitter.call(this);

	this.init();
}

require('util').inherits(Property, EventEmitter);


Property.prototype.hp;
Property.prototype.mp;
Property.prototype.atk;
Property.prototype.def;

//初始化vo
Property.prototype.init = function(){
	this.hp = 0;
	this.mp = 0;
	this.atk = 0;
	this.def = 0;
}

//重新计算vo
Property.prototype.updateFrom = function(voArr){
    this.init();
	var self = this;
	voArr.forEach(function(property){
		self.hp += property.hp;
		self.mp += property.mp;
		self.atk += property.atk;
		self.def += property.def;
	});

    self = null;
}


//获取玩家属性信息-发给客户端使用
Property.prototype.getJsonInfo = function(){
	return {
		"hp" : this.hp,
		"mp" : this.mp,
		"atk" : this.atk,
		"def" : this.def
	};
}

module.exports = Property;