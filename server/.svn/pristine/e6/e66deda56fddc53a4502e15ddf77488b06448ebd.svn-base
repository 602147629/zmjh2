var sic = require("../../../controllor/ServerInfoControllor.js");
var sm = require("../sm/SMGate.js");

module.exports = {
    //接收到服务器发来的信息
    GetServerInfoReturn : function(){
        var jObj = {
            "data" : 123
        };

        return require('BufferTools').getJsonPathBufferByDict("RMFromGate","SendServerInfoReturn",jObj,true);
    }
}