var EventEmitter = require("events").EventEmitter;
var pVoClass = require('Property.js');

function Equip(){
	EventEmitter.call(this);

	this.init();
}

require('util').inherits(Equip, EventEmitter);

Equip.prototype.propertyVo;//属性vo

//初始化vo
Equip.prototype.init = function(){
	this.propertyVo = new pVoClass();
	//根据配置，赋值数据
	this.propertyVo.hp = 50;
	this.propertyVo.mp = 20;
	this.propertyVo.atk = 15;
	this.propertyVo.def = 5;
}


Equip.prototype.destroy = function(){
    this.propertyVo = null;
}

//获取玩家属性信息-发给客户端使用
Equip.prototype.getJsonInfo = function(){
	return {
		"property" : this.propertyVo.getJsonInfo()
	};
}

module.exports = Equip;