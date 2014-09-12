//自动匹配

var roomC = require("./RoomControllor.js");
var sm = require("../message/remote/sm/SMAutoPipei.js");
var rcc = require("../../../controllor/RpcConnectorControllor.js");


var waitingArr = [];//正在排队等待的玩家数组

var pipeiIndex = -1;//匹配间隔索引


var startPipei = function(){
    clearInterval(pipeiIndex);
    pipeiIndex = setInterval(checkPk,3000);
}


var pipeiOk = function(obj1,obj2){
    var applyCb = function(err,config,data){
        if(err){
            //创建房间失败
            require("Log").error("玩家1:"+obj1.gameKey+",玩家2:"+obj2.gameKey+",申请PK房间失败！err:"+err);

            //通知玩家，取消自动匹配
            if(obj1.state == STATE2){
                rcc.SendByServerId(obj1.gameServerId,"RMFromFbManager","AutoPipeiReturn",sm.AutoPipeiReturn(0));
            }
            if(obj2.state == STATE2){
                rcc.SendByServerId(obj2.gameServerId,"RMFromFbManager","AutoPipeiReturn",sm.AutoPipeiReturn(0));
            }

            obj1.state = STATE1;
            obj2.state = STATE1;

            //自动离开匹配管理器
            if(module.exports.GetPipeiUser(obj1.gameKey)){
                module.exports.RemoveClient(obj1.gameKey);
            }
            if(module.exports.GetPipeiUser(obj2.gameKey)){
                module.exports.RemoveClient(obj2.gameKey);
            }
        }else{
            //房间申请成功

            //有玩家在申请房间过程中退出了游戏,把剩下的玩家重新加入排队
            var bool = true;
            if(obj1.state == STATE3){
                if(obj2.state == STATE2){
                    //进入等待阶段
                    obj2.state = STATE1;
                    obj2.pipeiCount = 1;
                }
                bool = false;
            }
            if(obj2.state == STATE3){
                if(obj1.state == STATE2){
                    //进入等待阶段
                    obj1.state = STATE1;
                    obj1.pipeiCount = 1;
                }
                bool = false;
            }


            if(bool){
                if(data.err == null){
                    //成功
                    require("Log").info("玩家1:"+obj1.gameKey+",玩家2:"+obj2.gameKey+",申请PK房间成功！通知玩家进入副本！data:"+JSON.stringify(data)+",config:"+JSON.stringify(config));
                    rcc.SendByServerId(obj1.gameServerId,"RMFromFbManager","AutoPipeiReturn",sm.AutoPipeiReturn(1,obj1,data,config));
                    rcc.SendByServerId(obj2.gameServerId,"RMFromFbManager","AutoPipeiReturn",sm.AutoPipeiReturn(1,obj2,data,config));
                }else{
                    //失败
                    require("Log").error("玩家1:"+obj1.gameKey+",玩家2:"+obj2.gameKey+",申请PK房间成功！初始化房间失败！");
                }

                //自动离开匹配管理器
                if(module.exports.GetPipeiUser(obj1.gameKey)){
                    module.exports.RemoveClient(obj1.gameKey);
                }
                if(module.exports.GetPipeiUser(obj2.gameKey)){
                    module.exports.RemoveClient(obj2.gameKey);
                }
            }else{
                //失败，还有一个玩家没离开

            }
        }
    }

    if(obj1 && obj2){
        //进入匹配阶段
        obj1.state = STATE2;
        obj2.state = STATE2;

        //申请房间
        roomC.ApplyRoom({type:0},applyCb);
    }
}

//判定是否匹配
var checkResult = function(obj1,obj2){
    //匹配次数（取双方较大的值）
    var pipeiCount = Math.max(obj1.pipeiCount,obj2.pipeiCount);

    //装备数量判定
    var equipCheck = false;
    if(obj1.pipeiData.equipmentCount > 6 && obj2.pipeiData.equipmentCount > 6){
        equipCheck = true;
    }
    if(obj1.pipeiData.equipmentCount <= 6 && obj2.pipeiData.equipmentCount <= 6){
        equipCheck = true;
    }
    if(!equipCheck){
        require("Log").trace("第 "+pipeiCount+" 次匹配,装备数量判定未通过！obj1:"+obj1.gameKey+",pipeiData:"+JSON.stringify(obj1.pipeiData)+",obj2:"+obj2.gameKey+",pipeiData:"+JSON.stringify(obj2.pipeiData));
        return false;
    }
    //判定武斗家等级
    var wudou = false;
    var wudouDiff = Math.abs(obj1.pipeiData.playerFightLv - obj2.pipeiData.playerFightLv);
    if(pipeiCount < 5){
        //前四次判定，武斗等级要一致
        if(wudouDiff == 0){
            wudou = true;
        }
    }else if(pipeiCount >= 5){
        //第五次判定，武斗等级相差2级之内
        if(wudouDiff <= 2){
            wudou = true;
        }
    }else{
//        var wudouDiff = Math.abs(obj1.pipeiData.playerFightLv - obj2.pipeiData.playerFightLv);
        if(wudouDiff <= 1){
            wudou = true;
        }
    }
    if(!wudou){
        require("Log").trace("第 "+pipeiCount+" 次匹配,武斗等级判定未通过！obj1:"+obj1.gameKey+",pipeiData:"+JSON.stringify(obj1.pipeiData)+",obj2:"+obj2.gameKey+",pipeiData:"+JSON.stringify(obj2.pipeiData));
        return false;
    }
    //判定主角等级
    var level = false;
    var levelDiff = Math.abs(obj1.pipeiData.playerLv - obj2.pipeiData.playerLv);
    if(pipeiCount == 1){
        //相差一级
        if(levelDiff <= 1){
            level = true;
        }
    }else if(pipeiCount >= 5){
        //第五次，等级上下相差3之内的玩家匹配在一起
        if(levelDiff <= 3){
            level = true;
        }
    }else{
        //相差两级
        if(levelDiff <= 2){
            level = true;
        }
    }
    if(!level){
        require("Log").trace("第 "+pipeiCount+" 次匹配,玩家等级判定未通过！obj1:"+obj1.gameKey+",pipeiData:"+JSON.stringify(obj1.pipeiData)+",obj2:"+obj2.gameKey+",pipeiData:"+JSON.stringify(obj2.pipeiData));
        return false;
    }
    //判定上一场胜负关系
    var last = false;
    if(pipeiCount == 1){
        //胜负相同的匹配
        if(obj1.pipeiData.fightResult == obj2.pipeiData.fightResult){
            last = true;
        }
    }else{
        last = true;
    }
    if(!last){
        require("Log").trace("第 "+pipeiCount+" 次匹配,胜负关系判定未通过！obj1:"+obj1.gameKey+",pipeiData:"+JSON.stringify(obj1.pipeiData)+",obj2:"+obj2.gameKey+",pipeiData:"+JSON.stringify(obj2.pipeiData));
        return false;
    }
    return true;
}


var checkPk = function(){
    var keys = Object.keys(waitingArr);
    var len = keys.length;
    require("Log").trace("----checkPk----len:"+len);
    if(len > 1){
        //进行匹配
        var arrTemp = [];

        keys.forEach(function(key){
            arrTemp.push(waitingArr[key]);
        });

        for(var i=0;i<len-1;i++){
            var obj1 = arrTemp[i];
            if(obj1.state != STATE1){
                continue;
            }
            for(var j=i+1;j<len;j++){
                if(obj1.state != STATE1){
                    continue;
                }
                var obj2 = arrTemp[j];
                if(obj2.state != STATE1){
                    continue;
                }

                if(checkResult(obj1,obj2)){
                    pipeiOk(obj1,obj2);
                }else{
                    obj1.pipeiCount ++;
                    obj2.pipeiCount ++;
                }
            }
        }
    }



    if(Object.keys(waitingArr).length >= 2){
        //大于2个玩家，才能开始
        var obj1;
        var obj2;

        require("SuperUtils").forEachInArray(waitingArr,function(obj){
            //只有在等待阶段的玩家才可以进行匹配
            if(obj.state == STATE1){
                if(!obj1){
                    obj1 = obj;
                }else if(!obj2){
                    obj2 = obj;
                    return true;
                }
            }
        })
    }
}


const STATE1 = 0;//刚刚加入匹配队伍
const STATE2 = 1;//开始申请房间
const STATE3 = 2;//离开了匹配


var AutoPipeiControllor = {};

AutoPipeiControllor.IsReadyToKill = false;

//有玩家加入
AutoPipeiControllor.AddClient = function(obj,cb){
    if(AutoPipeiControllor.IsReadyToKill){
        //准备关闭了，不让加入
        require("Log").info("玩家:"+obj.gameKey+" 加入申请自动匹配!服务器准备关闭！无法加入");
        if(cb){
            cb('SERVER_READY_CLOSE');
        }
        return;
    }
    if(!waitingArr[obj.gameKey]){
        obj.state = STATE1;
        waitingArr[obj.gameKey] = obj;

        require("Log").info("玩家:"+obj.gameKey+" 加入申请自动匹配!当前匹配中人数:"+Object.keys(waitingArr).length);

        //判定是否开始pk
        if(pipeiIndex == -1){
            startPipei();
        }
        if(cb){
            cb(null);
        }
    }else{
        if(cb){
            cb('ALREADY_IN_PIPEI');
        }
    }
}
//有玩家离开自动匹配
AutoPipeiControllor.RemoveClient = function(gameKey,cb){
    var obj = waitingArr[gameKey];
    if(obj){
        //记录为离开状态
        obj.state = STATE3;

        delete waitingArr[gameKey];
        require("Log").info("玩家:"+obj.gameKey+" 离开自动匹配!当前匹配中人数:"+Object.keys(waitingArr).length);

        if(cb){
            cb(null);
        }
    }else{
        if(cb){
            cb('NOT_IN_PIPEI');
        }
        require("Log").error("该玩家不在自动匹配队伍当中！gameKey:"+gameKey);
    }
}
//根据uid获取玩家是否正在匹配
AutoPipeiControllor.GetPipeiUser = function(gameKey){
    return waitingArr[gameKey];
}


module.exports = AutoPipeiControllor;