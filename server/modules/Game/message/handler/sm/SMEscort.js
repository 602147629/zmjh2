
module.exports = {
    MatchEscortReturn : function(result){
        var jObj = {
            "result" : result
        }
        //封装包头
        return require('BufferTools').getJsonPathBufferByDict("MyEscortReceiveControl","MatchEscortReturn",jObj);

    },
    CancelMatchEscortReturn : function(result){
        var jObj = {
            "result" : result
        }
        //封装包头
        return require('BufferTools').getJsonPathBufferByDict("MyEscortReceiveControl","CancelMatchEscortReturn",jObj);
    }
}
