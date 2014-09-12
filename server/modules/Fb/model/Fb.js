var keyClass = require('./Key.js');
var memberClass = require('./FbMember.js');
var sm = require('../message/handler/sm/SMGame.js');
var comm = require('../const/common.js');
var EventEmitter = require("events").EventEmitter;


function Fb(){
	EventEmitter.call(this);

	this.keys = [];
	this.members = [];
    this.si = -1;
    this.maxLoadingTimeIndex = -1;
    this.maxTimeoutTime = comm.FB_TIMEOUT;
    this.maxLoadingTime = comm.FB_LOADING_TIMEOUT;
    this.state = this.FB_STATE1;
    this.chnName = "";
    this.bufferLen = 0;

    //开始加载倒计时
    this.maxLoadingTimeIndex = setTimeout(this.byondLading.bind(this),this.maxLoadingTime);
}

require('util').inherits(Fb, EventEmitter);

//副本id
Fb.prototype.id;
//当前操作数组
Fb.prototype.keys;
//当前副本种类,与房间种类相同
Fb.prototype.type;
//当前玩家数组
Fb.prototype.members;
//副本超时时间(帧)
Fb.prototype.maxTimeoutTime;
//加载等待超时(秒)
Fb.prototype.maxLoadingTime;
//加载等待超时计时器索引
Fb.prototype.maxLoadingTimeIndex;
//当前副本状态
Fb.prototype.state;//(0:loading,1:fighting,2:over)
//当前副本中文名
Fb.prototype.chnName;
//当前帧总字节长度
Fb.prototype.bufferLen;


Fb.prototype.FB_STATE1 = 0;//加载
Fb.prototype.FB_STATE2 = 1;//战斗
Fb.prototype.FB_STATE3 = 2;//结束


//接受玩家操作，keyCode：按键code，如果为-1，则是特殊操作,oper,keyCode为-1的时候，2代表玩家离开
Fb.prototype.acceptOperation = function(index,keyCode,oper){
	if(this.state != this.FB_STATE2){
		return;
	}
    this.acceptOperationForSelf(index,keyCode,oper);
}


//接受操作，程序内部调用，非对外接口
Fb.prototype.acceptOperationForSelf = function(index,keyCode,oper){
    var keylen = this.keys.length;
    var keyTemp;
    for(var i=0;i<keylen;i++){
        if(this.keys[i].index == index){
            keyTemp = this.keys[i];
            break;
        }
    }
    if(!keyTemp){
        keyTemp = new keyClass();
        keyTemp.index = index;
        keyTemp.keyCodes = [];
        keyTemp.opers = [];
        keyTemp.toomanystep = 1;
        this.keys.push(keyTemp);

        this.bufferLen += 6;
    }

    //屏蔽重复按键
    if(keyTemp.keyCodes.indexOf(keyCode) == -1){
        keyTemp.keyCodes.push(keyCode);
        keyTemp.opers.push(oper);
        this.bufferLen += 4;
    }
    //判定是否按键过多
    if(keyTemp.toomanystep == 1){
        if(keyTemp.keyCodes.length >= 5){
            require('Log').error('1--too many key down!length:'+keyTemp.keyCodes.length);
            keyTemp.toomanystep = 2;
        }
    }else if(keyTemp.toomanystep == 2){
        if(keyTemp.keyCodes.length >= 10){
            require('Log').error('2--too many key down!length:'+keyTemp.keyCodes.length);
            keyTemp.toomanystep = 3;
        }
    }else if(keyTemp.toomanystep == 3){
        if(keyTemp.keyCodes.length >= 15){
            require('Log').error('3--too many key down!length:'+keyTemp.keyCodes.length);
            keyTemp.toomanystep = 4;
        }
    }else if(keyTemp.toomanystep == 4){
        if(keyTemp.keyCodes.length >= 20){
            require('Log').error('4--too many key down!length:'+keyTemp.keyCodes.length);
            keyTemp.toomanystep = 5;
        }
    }
}

//某位玩家离开了副本(通过命令方式通知玩家,整合在操作集中)
Fb.prototype.playersLeft = function(index){
	this.acceptOperationForSelf(index,-1,comm.KeyOperationType.PLAYER_LEFT);
}
//增加玩家
Fb.prototype.addClient = function(client,cb){
    if(this.state > 0){
        require("Log").error("Fb->addClient() error!this Fb has started fighting!gameKey:"+client.user.gameKey);
        //游戏已经开始，或者结束，禁止加入
        if(cb){
            cb('GAME_HAS_START');
        }
        return;
    }
    var memOld = this.getMemberByClient(client);
    if(!memOld){
        var mem = new memberClass();
        mem.client = client;
        mem.user = client.user;
        this.members.push(mem);

        //设置阵营
        this.setCamp(mem);

        if(cb){
            cb(null);
        }
    }else{
        if(cb){
            cb('NOT_IN_THIS_FB');
        }
    }
}

//移除某个玩家
Fb.prototype.removeClient = function(client,cb){
    var mem = this.getMemberByClient(client);
    if(mem){
        this.removeMember(mem);
        if(cb){
            cb(null);
        }
    }else{
        if(cb){
            cb('NOT_IN_THIS_FB');
        }
    }
}

Fb.prototype.removeMember = function(member){
    member.state = memberClass.prototype.MEM_STATE4;

    //判定
    this.removeMemberWhenState(member);
    //判定结束
    this.checkOver();
}

//有玩家离开了游戏
Fb.prototype.removeMemberWhenState = function(mem){
    if(this.state < this.FB_STATE3){
        if(mem.state == memberClass.prototype.MEM_STATE5){
            //这个玩家已经结算了,就不通知其他玩家这个玩家离开（通常是在一方作弊的情况下，不影响别的玩家继续打）

        }else{
            //通知别的玩家这个玩家离开了游戏
            this.playersLeft(mem.user.index);
        }
    }
}

//设置玩家阵营
Fb.prototype.setCamp = function(mem){

}

//判定游戏结束
Fb.prototype.checkOver = function(){
    if(this.state == this.FB_STATE3){
        return;
    }
    var isOver = true;
    this.members.forEach(function(member){
        if(member.result == -1){
            isOver = false;
        }
    });
    if(isOver){
        require("Log").trace("游戏进入结算!");
        //结束,结算
        var self = this;
        this.members.forEach(function(member){
            self.Account(member);
        });

        if(this.state == this.FB_STATE1){
            //结算的时候，还没有正式开始战斗,直接销毁
            this.state = this.FB_STATE3;
            this.emit('destroy');
        }else if(this.state == this.FB_STATE2){
            //结算的时候，已经开始战斗，等这一帧发送后再结束副本
            this.state = this.FB_STATE3;
        }
    }
}


//某个玩家加载完毕
Fb.prototype.loadingComplete = function(client){
	var mem = this.getMemberByClient(client);
    if(mem){
        mem.state = memberClass.prototype.MEM_STATE2;
        this.checkStart();
    }else{
        require("Log").error("Fb->loadingComplete error!not this member exist!gameKey:"+client.user.gameKey);
    }
}

//加载等待超时
Fb.prototype.byondLading = function(){
    require("Log").info("副本:"+this.id+" 加载超时！"+this.chnName);
    var self = this;
    this.members.forEach(function(member){
        if(member.state == memberClass.prototype.MEM_STATE1){
            //还没加载完成的，踢掉,算输
            self.removeClient(member.client);

        }
    });
}


//检查玩家是否都加载完毕（1：有玩家发送加载完毕上来，2：有玩家退出）
Fb.prototype.checkStart = function(){
    if(this.state == this.FB_STATE2){
        return;
    }
    var isStart = true;
    this.members.forEach(function(member){
        if(member.state == memberClass.prototype.MEM_STATE1){
            //还有人未加载完毕
            isStart = false;
        }
    });
    if(isStart){
        this.start();
    }
}

//真正开始游戏
Fb.prototype.start = function(){
    if(this.state == this.FB_STATE2){
        return;
    }
    require("Log").info("副本 "+this.id+" 玩家全部加载完毕,游戏开始!");
    this.state = this.FB_STATE2;
    this.members.forEach(function(member){
        if(member.state < memberClass.prototype.MEM_STATE3){
            member.state = memberClass.prototype.MEM_STATE3;
        }
    });
    //清除加载超时倒计时
    clearTimeout(this.maxLoadingTimeIndex);
    if(this.si == -1){
        //发送游戏开始
        this.brocast(sm.StartGameAfterLoading());
        var enterframe = this.step.bind(this);
        this.si = setInterval(enterframe,33);
    }
}

//返回当前副本内玩家数量
Fb.prototype.currentPlayersLen = function(){
	return this.members.length;
}


//副本时间到
Fb.prototype.timeUp = function(){
    //超时，都算输
    this.members.forEach(function(member){
        if(member.result == -1){
            member.result = 0;
        }
    });
}

Fb.prototype.step = function(){
	if(this.state < this.FB_STATE2){
		return;
	}
    if(this.maxTimeoutTime > 0){
        this.maxTimeoutTime--;
        if(this.maxTimeoutTime === 0){
            //广播
            this.brocast(sm.FbTimeout());
            //超时处理
            this.timeUp();
            //判断结果
            this.checkOver();
            return;
        }
    }else if(this.maxTimeoutTime === 0){
        //理论上不该出现
        require("Log").error("Fb->step() error!maxTimeoutTime is 0!");
        this.emit('destroy');
        return;
    }
	//计算总操作命令长度
    var comLen = this.keys.length;
    var keyTemp;
    var keyLen;
	var command = new Buffer(this.bufferLen);
	var offfset = 0;
	for(var j=0;j<comLen;j++){
		keyTemp = this.keys[j];
		keyLen = keyTemp.keyCodes.length;
		command.writeInt16LE(4+keyLen*8,offfset);//数据长度
		offfset += 2;
		command.writeInt32LE(keyTemp.index,offfset);//角色索引
		offfset += 4;

		for(var i=0;i<keyLen;i++){
			var keyCode = keyTemp.keyCodes[i];
			var oper = keyTemp.opers[i];
			command.writeInt16LE(keyCode,offfset);//操作keycode
			offfset += 2;
			command.writeInt16LE(oper,offfset);//操作类型
			offfset += 2;
		}
	}
	this.brocast(sm.SendOperation(command));

    this.destroyKeys();

    //结束了，发送最后一帧数据之后，销毁副本
    if(this.state == this.FB_STATE3){
        this.emit('destroy');
    }

    this.bufferLen = 0;
}

//某个玩家发上来他游戏结束了
Fb.prototype.PlayerSendGameOver = function(data,client){
    var result = parseInt(data.result);//结果
    var totalFrames = parseInt(data.totalFrames);//游戏结束时的帧数

    var self = this;
    this.members.forEach(function(member){
        if(member.client == client){
            if(member.result == -1){
                member.result = result;

                //结算
                self.Account(member);
            }
        }
    });

    this.checkOver();
}

//对某个玩家结算
Fb.prototype.Account = function(member){
    if(member.state == memberClass.prototype.MEM_STATE5){
        return;
    }
    member.state = memberClass.prototype.MEM_STATE5;

    if(member.result == -1){
        require("Log").error("Fb->Account() error!this member result remain -1!");
        return;
    }

    if(member.result == 1){
        require("Log").info("副本 "+this.id+" 结算!玩家gameKey:"+member.user.gameKey+" 胜利！副本类型:"+this.chnName+"职业:"+member.user.data.occupation);
    }else{
        require("Log").info("副本 "+this.id+" 结算!玩家gameKey:"+member.user.gameKey+" 失败！副本类型:"+this.chnName+"职业:"+member.user.data.occupation);
    }


    var data = {
        "gameKey" : member.user.gameKey,
        "type" : this.type,
        "result" : member.result
    }

    //玩家结算后自动离开副本
    member.user.fb = null;
    //提交结算
    this.emit('account',data,member.client);
}


//根据client获取member对象
Fb.prototype.getMemberByClient = function(client){
    var mem;
    require("SuperUtils").forEachInArray(this.members,function(member){
        if(member.client == client){
            mem = member;
            return true;
        }
    });

    return mem;
}

//副本内广播
Fb.prototype.brocast = function(buffer){
	this.members.forEach(function(member){
        if(member.client){
            member.client.send(buffer);
        }
	});
}


Fb.prototype.destroyKeys = function(){
    this.keys.forEach(function(key){
        key.destroy();
    });
    this.keys.length = 0;
}


Fb.prototype.destroy = function(){
    if(this.si != -1){
        clearInterval(this.si);
    }
    if(this.maxLoadingTimeIndex != -1){
        clearTimeout(this.maxLoadingTimeIndex);
    }
    if(this.members){
        this.members.forEach(function(member){
            member.destroy();
        })
        this.members.length = 0;
        this.members = null;
    }
	if(this.keys){
        this.destroyKeys();
        this.keys = null;
    }

	this.removeAllListeners();
}


module.exports = Fb;