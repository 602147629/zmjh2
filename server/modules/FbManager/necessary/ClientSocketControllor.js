
module.exports = {
    //有客户端连接上来
    ClientConnected : function(socket,files,type){

    },
    KillAll : function(cb){
        require("Log").trace("=========FbManager-KillAll========");
        cb();
    }
}