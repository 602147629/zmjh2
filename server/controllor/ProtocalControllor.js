var EventEmitter = require("events").EventEmitter;


function ProtocalControllor(encodeArray,decodeArray){
    EventEmitter.call(this);

    this.encodeIndex = 0;
    this.decodeIndex = 0;
    this.encodeKeyPool = encodeArray;
    this.decodeKeyPool = decodeArray;
}


require('util').inherits(ProtocalControllor, EventEmitter);


//获取加密密钥
ProtocalControllor.prototype.GetEncodeProtocolKey = function(){
    this.encodeIndex++;
    if(this.encodeIndex == this.encodeKeyPool.length){
        this.encodeIndex = 0;
    }
    return this.encodeKeyPool[this.encodeIndex];
}
//获取解密密钥
ProtocalControllor.prototype.GetDecodeProtocolKey = function(){
    this.decodeIndex++;
    if(this.decodeIndex == this.decodeKeyPool.length){
        this.decodeIndex = 0;
    }
    return this.decodeKeyPool[this.decodeIndex];
}

ProtocalControllor.prototype.destroy = function(){
    this.decodeKeyPool = null;
    this.encodeKeyPool = null;
}



module.exports = ProtocalControllor;