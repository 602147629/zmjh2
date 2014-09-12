//flash 策略验证
var net = require('net'); 

const PORT = 843;
const XML =
'<cross-domain-policy>' +
        '<allow-access-from domain="*" to-ports="*" />' +
'</cross-domain-policy>';

module.exports = {
    Start : function(){
        net.createServer(function(socket) {
            socket.setTimeout(1500, function() {
                socket.destroy();
            });

            socket.on('data', function(data) {
                if(data.toString() == '<policy-file-request/>\0') {
                        socket.end(XML);
                } else {
                        socket.destroy();
                }
            });
        }).listen(PORT);
    }
}
