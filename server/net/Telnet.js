var net = require('net');

var cdc = require("../controllor/ConfigDataControllor.js")

var sockets = [];
var telnetControl;

var execCommand = function(data,socket){
    if(!telnetControl){
        telnetControl = require("../modules/"+cdc.ServerConfig.path+"/necessary/TelnetControllor.js");
        telnetControl.TelnetCommand(data,socket);
    }
}

module.exports = {
    StartWithConfig : function(config){
        this.server = net.createServer();
        this.server.maxConnections = 0;//最大连接数限制
        this.server.listen(config.telnetPort);
        this.server.on('connection',function(socket){
            sockets.push(socket);

            socket.on('data', function(d) {
                data = d.toString('utf8').trim();
                console.log("data:"+data);

                //解析命令
                execCommand(data,socket);
            });

            socket.on('close', function() {
                socket.destroy();
                sockets.splice(sockets.indexOf(socket), 1);
            });
        });
    }
//    ,
//    StartWithPort : function(port){
//        this.server = net.createServer();
//        this.server.maxConnections = 0;//最大连接数限制
//        this.server.listen(port);
//        this.server.on('connection',function(socket){
//            sockets.push(socket);
//
//            socket.on('data', function(d) {
//                data = d.toString('utf8').trim();
//                console.log("data:"+data);
//
//                //解析命令
//                execCommand(data,socket);
//            });
//
//            socket.on('close', function() {
//                socket.destroy();
//                sockets.splice(sockets.indexOf(socket), 1);
//            });
//        });
//    }
}