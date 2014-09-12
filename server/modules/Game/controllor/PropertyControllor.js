var pVoClass = require('../model/Property.js');
var EventEmitter = require("events").EventEmitter;



function PropertyControllor(){
	EventEmitter.call(this);

	this.propertyVo = new pVoClass();//总属性
	this.equipPropertyVo = new pVoClass();//装备所加属性
	this.basePropertyVo = new pVoClass();//基础属性
}

require('util').inherits(PropertyControllor, EventEmitter);

PropertyControllor.prototype.propertyVo;//总属性
PropertyControllor.prototype.equipPropertyVo;//装备所加属性
PropertyControllor.prototype.basePropertyVo;//基础属性

//更新装备总属性
PropertyControllor.prototype.updateEquip = function(ePropertyVo){
	this.equipPropertyVo = ePropertyVo;
}

//更基础属性
PropertyControllor.prototype.updateBase = function(level){
	this.basePropertyVo.init();
	//根据配置、等级，重新计算属性
	this.basePropertyVo.hp = level*50;
	this.basePropertyVo.mp = level*30;
	this.basePropertyVo.atk = level*20;
	this.basePropertyVo.def = level*15;

	//重新计算总属性
	this.updateProperty();
}

//更新总属性
PropertyControllor.prototype.updateProperty = function(){
	this.propertyVo.updateFrom([
        this.equipPropertyVo,
        this.basePropertyVo
    ]);
}

//销毁
PropertyControllor.prototype.destroy = function(){
	this.removeAllListeners();
	this.propertyVo = null;
	this.equipPropertyVo = null;
	this.basePropertyVo = null;
}


module.exports = PropertyControllor;
