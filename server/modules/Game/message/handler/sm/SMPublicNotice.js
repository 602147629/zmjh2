
module.exports = {
    PublicNoticeReturn : function(result){
        var jObj = {
            "result" : result
        }
        //封装包头
        return require('BufferTools').getJsonPathBufferByDict("MyPublicNoticeReceiveControl","PublicNoticeReturn",jObj);

    }
}
