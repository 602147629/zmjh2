var pVoClass = require('../model/Property.js');
var EventEmitter = require("events").EventEmitter;



function EquipmentControllor(){
	EventEmitter.call(this);

	this.propertyVo = new pVoClass();//所加属性
	this.equips = [];//装备数组
}

require('util').inherits(EquipmentControllor, EventEmitter);

//EquipmentControllor.prototype.propertyVo;//所加属性
//EquipmentControllor.prototype.equips;//装备数组

//穿装备
EquipmentControllor.prototype.equip = function(){

}
//脱装备
EquipmentControllor.prototype.unEquip = function(){

}
//替换装备
EquipmentControllor.prototype.replaceEquip = function(){

}

//销毁
EquipmentControllor.prototype.destroy = function(){
	this.removeAllListeners();
	this.propertyVo = null;
	this.equips.length = 0;
}


module.exports = EquipmentControllor;
