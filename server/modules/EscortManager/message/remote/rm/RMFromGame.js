var RMFromGame = {};
var escortC = require("../../../controllor/matchEscortControllor.js");

//玩家离开游戏
RMFromGame.UserLogout = function(buffer,client){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var data = jObj.data;
    var gameKey = data.gameKey;

    //离开自动匹配
    if(escortC.GetPipeiUser(gameKey)){
        escortC.RemoveClient(gameKey);
    }
}

module.exports = RMFromGame;