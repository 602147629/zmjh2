var serverVoClass = require("../model/ServerVo.js");

var servers = [];

function updateFrom(server,config){
    server.name = config.name;
    server.max = config.max;
    server.current = config.current;
    server.ip = config.ip;
    server.port = config.port;
}

//删除一个服务器的信息
function destroyServerInfo(serverid){
    var server = servers[serverid];
    if(server){
        delete servers[serverid];
    }
}

module.exports = {
    //接收到某个服务器发来的信息
    UpdateServerInfo : function(config,client){
        var server = servers[config.id];
        if(server){
            //更新信息
            updateFrom(server,config);
            return;
        }
        //新建信息
        server = new serverVoClass();
        server.id = config.id;
        updateFrom(server,config);
        client.on("destroy",function(){
            destroyServerInfo(server.id);
        });
        servers[server.id] = server;
    },
    //获取所有的服务器信息(string)
    GetServerInfo : function(){
        var serversJson = [];
        servers.forEach(function(server){
            serversJson.push(server.getJsonInfo());
        })
        return serversJson;
    }
}