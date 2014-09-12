var logc = require("../../../controllor/LogControllor.js");


module.exports = {
    Log : function(buffer,client){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;
        var data = jObj.data;

        require("Log").trace(JSON.stringify(data.msg));
    },
    UpdateTotalPlayers : function(buffer,client){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;
        var data = jObj.data;

        logc.UpdateTotalPlayers(rpcData.serverId,data.totalPlayers);
    }
}