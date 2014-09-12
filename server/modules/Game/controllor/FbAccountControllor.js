var FbAccountControllor = {};


//处理副本结算
FbAccountControllor.fbAccount = function(player,data){
    require("Log").trace("收到副本结算:pid:"+player.pid+",data:"+JSON.stringify(data));


}



module.exports = FbAccountControllor;