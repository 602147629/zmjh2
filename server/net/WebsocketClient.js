var EventEmitter = require("events").EventEmitter;


var WebsocketClient = function(connection,msgFiles){
    EventEmitter.call(this);

    this.msgFiles = msgFiles;

    this.connection = connection;

    var self = this;
    this.connection.on('message', function(message) {
        self.onReceivePackData.bind(self)(message);
    });
    this.connection.on('close', function(reasonCode, description) {
        console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.');
    });

}

require('util').inherits(WebsocketClient, EventEmitter);


WebsocketClient.prototype.connection;
WebsocketClient.prototype.msgFiles;


WebsocketClient.prototype.onReceivePackData = function(message){
    if (message.type === 'utf8') {
        console.log('Received Message: ' + message.utf8Data);

        var arr = message.utf8Data.split("|");
        var protocol = arr[0];//协议
        var data = arr[1];//数据

        var protocolArr = protocol.split(".");
        if(protocolArr.length == 2){
            var fileName = protocolArr[0];
            var funcName = protocolArr[1];

            if(this.msgFiles[fileName]){
                if(this.msgFiles[fileName][funcName]){
                    this.msgFiles[fileName][funcName](data,this);
                }else{
                    require("Log").error("函数没找到:"+path);
                    this.destroy();
                }
            }else{
                require("Log").error("文件名没找到:"+path);
                this.destroy();
            }
        }
    }
    else if (message.type === 'binary') {
        console.log('Received Binary Message of ' + message.binaryData.length + ' bytes');
//        this.connection.sendBytes(message.binaryData);
    }
}

WebsocketClient.prototype.sendUtf = function(data){
    this.connection.sendUTF(data);
}

WebsocketClient.prototype.sendBytes = function(data){
    this.connection.sendBytes(data);
}

WebsocketClient.prototype.destroy = function(){
    if(this.connection){
        this.connection.removeAllListeners();
        this.connection.close();
        this.connection = null;
    }
    this.emit('destroy');
}




module.exports = WebsocketClient;



