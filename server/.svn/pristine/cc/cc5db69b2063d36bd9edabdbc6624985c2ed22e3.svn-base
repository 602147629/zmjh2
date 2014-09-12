var MsgControllor = {};
var sm = require('../message/handler/sm/SMCommon.js');


MsgControllor.Send = function(client,type){
    client.send(sm.GetMsgId(type));
}

MsgControllor.Brocast = function(clients,type){
    var buf = sm.GetMsgId(type);
    clients.forEach(function(client){
        client.send(buf);
    });
}



module.exports = MsgControllor;