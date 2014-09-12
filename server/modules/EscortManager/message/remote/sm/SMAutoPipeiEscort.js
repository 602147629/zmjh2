var SMAutoPipeiEscort = {};


SMAutoPipeiEscort.AutoPipeiEscortReturn = function(result,objSelf,objOther){
    var obj;
    var escortData

    if(objSelf.escortType==1){
        escortData = objSelf.escortData;
    }else{
        escortData = objOther.escortData;
    }

    if(result == 1){
        //成功
        obj = {
            "result" : result,
            "gameKey" : objSelf.gameKey,
            "escortType":objSelf.escortType,
            "otherPlayerData":objOther.playerData,
            "escortData":escortData
        }
    }else{
        //失败
        obj = {
            "result" : result
        }
    }
    return obj;
}


module.exports = SMAutoPipeiEscort;