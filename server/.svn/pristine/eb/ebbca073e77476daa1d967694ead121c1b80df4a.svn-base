var ctmc = require("../controllor/CopyToMysqlControllor.js")


module.exports = {
    //有客户端连接上来
    ClientConnected : function(socket,files){

    },
    KillAll : function(cb){
        //同步redis到mysql
        ctmc.copyToMysql(cb);
    }
}