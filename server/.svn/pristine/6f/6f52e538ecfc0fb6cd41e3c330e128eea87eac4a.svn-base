var EventEmitter = require("events").EventEmitter;

var net = require('net');
var WebSocketServer = require('websocket').server;
var http = require('http');



var ConnectionServer = function(type){
    EventEmitter.call(this);

    this.type = type;
    if(this.type == "socket"){
        this.server = net.createServer();
    }else if(this.type == "websocket"){
        this.httpServer = http.createServer(function(request, response) {
            console.log((new Date()) + ' Received request for ' + request.url);
            response.writeHead(404);
            response.end();
        });
    }else{
        require("Log").error("ConnectionServer type error!");
    }
    this.webSocketConnectionCount = 0;
}

require('util').inherits(ConnectionServer, EventEmitter);


ConnectionServer.prototype.type;//连接类型（"socket","websocket"）
ConnectionServer.prototype._maxConnections;//最大连接数
ConnectionServer.prototype.server;//server对象
ConnectionServer.prototype.httpServer;//http服务器
ConnectionServer.prototype.webSocketConnectionCount;//websocket的连接数目


//经验
ConnectionServer.prototype.__defineGetter__('maxConnections',function(){
    return this._maxConnections;
});
ConnectionServer.prototype.__defineSetter__('maxConnections',function(v){
    this._maxConnections = v;

    if(this.type == "socket"){
        if(this.server){
            this.server.maxConnections = this._maxConnections;
        }
    }else if(this.type == "websocket"){
        this.webSocketConnectionCount = this._maxConnections;
    }
});

ConnectionServer.prototype.listen = function(port){
    var self = this;
    if(this.type == "socket"){
        if(this.server){
            this.server.listen(port)
            this.server.on('connection',function(socket){
                self.emit('connection',socket);
            });
        }
    }else  if(this.type == "websocket"){
//        this.httpServer = http.createServer(function(request, response) {
//            console.log((new Date()) + ' Received request for ' + request.url);
//            response.writeHead(404);
//            response.end();
//        });
        this.httpServer.listen(port, function() {
            console.log((new Date()) + ' Server is listening on port 4000');
        });

        this.server = new WebSocketServer({
            httpServer: this.httpServer,

            autoAcceptConnections: false
        });

        this.server.on('request', function(request) {
//    if (!originIsAllowed(request.origin)) {
//        request.reject();
//        console.log((new Date()) + ' Connection from origin ' + request.origin + ' rejected.');
//        return;
//    }
            var connection = request.accept('', request.origin);
            self.emit('connection',connection);
        });


    }
}


ConnectionServer.prototype.close = function(cb){
    if(this.type == "socket"){
        if(this.server){
            this.server.close(cb)
        }
    }else if(this.type == "websocket"){
        if(this.server){
            this.server.shutDown();
        }
        if(cb){
            cb();
        }
    }
}



ConnectionServer.prototype.destroy = function(){
   if(this.server){
       this.server.close();
       this.server.removeAllListeners();
       this.server = null;
   }
}






module.exports = ConnectionServer;