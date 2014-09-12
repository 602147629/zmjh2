var EventEmitter = require("events").EventEmitter;


function FbMember(){
    EventEmitter.call(this);

    this.state = this.MEM_STATE1;
    this.result = -1;
    this.camp = -1;
}

require('util').inherits(FbMember, EventEmitter);


FbMember.prototype.MEM_STATE1 = 1;//加载
FbMember.prototype.MEM_STATE2 = 2;//加载完毕
FbMember.prototype.MEM_STATE3 = 3;//战斗
FbMember.prototype.MEM_STATE4 = 4;//结束（离开或者结算）
FbMember.prototype.MEM_STATE5 = 5;//结算(已经通知对应的场景结算)



FbMember.prototype.client;
FbMember.prototype.user;
FbMember.prototype.state;//当前状态(0:loading,1:loadingconplete,2:fighting,3:over,4:account)
FbMember.prototype.camp;//阵营(-1:初始值)
FbMember.prototype.result;//pk结果(-1:初始值，还没有结果,0:失败,1:胜利)(1.由客户端发来，只改变玩家自己。2:中途有人跑了，双方一起结算)


FbMember.prototype.destroy = function(){
    this.client = null;
    this.user = null;
}


module.exports = FbMember;