var twoPipeiPkFbClass = require("../model/TwoPipeiPkFb.js")
var rcc = require("../../../controllor/RpcConnectorControllor.js");
var smRoom = require("../message/handler/sm/SMRoom.js");



var allFbs = [];
var index = 0;
var current = 0;


module.exports = {
    //创建副本
    CreateFb : function(room,cb){
        var clients = room.getAllClients();
        if(clients.length > 0){
            var fb;
            if(room.type == 0){
                fb = new twoPipeiPkFbClass();
                fb.chnName = "0_单人匹配PK";
            }
            if(!fb){
                //副本类型错误
                require("Log").error("创建副本出错!没有这个类型的副本!");
                if(cb){
                    cb('NOT_THIS_TYPE_FB');
                }
                return;
            }
            fb.id = index;
            fb.type = room.type;
            var idx = 0;
            clients.forEach(function(client){
                //相对索引，用于区分副本内玩家
                client.user.index = idx;
                idx++;
                fb.addClient(client);
                client.user.fb = fb;
            });
            allFbs[index] = fb;
            index++;

            //副本销毁
            fb.on('destroy',function(){
                if(allFbs[fb.id]){
                    current--;
                    require("Log").info("销毁了副本,副本ID:"+fb.id+",当前副本总数:"+current);
                    fb.destroy();
                    delete allFbs[fb.id];
                }
            })

            //副本结算,发给网关服帮忙转发
            fb.on('account',function(data,client){
                rcc.BrocastByPath("Gate","RMFromFb","UserFbAccount",data);
                //通知这个玩家游戏结束
                client.send(smRoom.GameAccountReturn(data));
            });

            room.startFb(fb);
            current++;

            require("Log").info("创建了副本,副本ID:"+index+",当前副本总数:"+current);
            if(cb){
                cb(null);
            }
        }else{
            if(cb){
                cb('NO_CLIENT_IN_ROOM');
            }
        }
    },
    //获取副本数目
    GetFbNums : function(){
        return current;
    }

}