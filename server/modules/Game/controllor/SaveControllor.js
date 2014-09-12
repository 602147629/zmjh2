var EventEmitter = require("events").EventEmitter;


const TIMEOUT_OBJ = {
    "BAG" : 10000,//背包自动存档间隔（毫秒）
    "SKILL" : 10000,//技能自动存档间隔（毫秒）
    "PLAYER" : 10000//玩家角色
};

function SaveControllor(){
    EventEmitter.call(this);

    this.timeoutIndex = {
        "BAG" : -1,
        "SKILL" : -1,
        "PLAYER" : -1
    };
}

require('util').inherits(SaveControllor, EventEmitter);

//外部调用，执行存档
SaveControllor.prototype.doSave = function(save){
    var self = this;
    var idx = this.timeoutIndex[save];
    var timeout = TIMEOUT_OBJ[save];

    if(timeout != undefined && idx != undefined){
        clearTimeout(idx);
        this.timeoutIndex[save] = setTimeout(function(){
            self.emit(save);
        },timeout)
    }else{
        require("Log").error("SaveControllor->doSave error!save:"+save);
    }
}

//销毁
SaveControllor.prototype.destroy = function(){
    this.clearAllTimeouts();
    this.removeAllListeners();
    this.timeoutIndex = null;
}

//立即将需要存档的模块进行存档
SaveControllor.prototype.saveImmediately = function(){
    var self = this;
    //立即进行存档
    Object.keys(this.timeoutIndex).forEach(function(key){
        if(self.timeoutIndex[key] != -1){
            self.emit(key);
        }
    });
    this.clearAllTimeouts();
}

//取消所有的存档计时器
SaveControllor.prototype.clearAllTimeouts = function(){
    var self = this;
    Object.keys(this.timeoutIndex).forEach(function(key){
        clearTimeout(self.timeoutIndex[key]);
        self.timeoutIndex[key] = -1;
    });
}


module.exports = SaveControllor;