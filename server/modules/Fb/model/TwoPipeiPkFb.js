var fbClass = require('./Fb.js');
var memberClass = require('./FbMember.js');

var TwoPipeiPkFb = function(){
    fbClass.call(this);


}

require('util').inherits(TwoPipeiPkFb, fbClass);


//加载等待超时
TwoPipeiPkFb.prototype.byondLading = function(){
    require("Log").info("副本:"+this.id+" 加载超时！"+this.chnName);
    if(this.members.length == 2){
        var mem1 = this.members[0];
        var mem2 = this.members[1];

        if(mem1.state == memberClass.prototype.MEM_STATE1 && mem2.state == memberClass.prototype.MEM_STATE1){
            //2个人都没加载完，都算输
            mem1.result = 0;
            mem2.result = 0;
        }else{
            if(mem1.state == memberClass.prototype.MEM_STATE1){
                mem1.result = 0;
            }
            if(mem2.state == memberClass.prototype.MEM_STATE1){
                mem2.result = 0;
            }
        }

        //结算
        this.checkOver();
    }else{
        require("Log").error("加载等待超时出错！chnName:"+this.chnName);
    }
}


//有玩家离开了游戏
TwoPipeiPkFb.prototype.removeMemberWhenState = function(mem){
    fbClass.prototype.removeMemberWhenState.call(this,mem);

    if(this.state < fbClass.prototype.FB_STATE3){
        //对方胜利,己方失败
        this.members.forEach(function(member){
            if(member == mem){
                if(member.result == -1){
                    member.result = 0;
                }
            }else{
                if(member.result == -1){
                    member.result = 1;
                }
            }
        });
    }else{
        require("Log").trace("单人匹配PK，游戏已经结束,有玩家离开!gameKey:"+mem.user.gameKey);
    }
}

//设置玩家阵营
TwoPipeiPkFb.prototype.setCamp = function(mem){
    fbClass.prototype.setCamp.call(this,mem);
    var i = 1;
    this.members.forEach(function(member){
        member.camp = i;
        i++
    });
}


module.exports = TwoPipeiPkFb;