
module.exports = {
	//返回玩家操作
	SendOperation : function(command){
		return require('BufferTools').getPathBufferByDict("MyRoomReceiveControl","ReceiveOperation",command);
	},
	//游戏开始(附带结果和房间内玩家的所有信息)
	StartGame : function(result,playerDatas){
        var info = {
            "result" : result,
            "random" : Math.ceil(Math.random()*100000),
            "datas" : playerDatas
        };

		return require('BufferTools').getJsonPathBufferByDict("MyRoomReceiveControl","StartGame",info);
	},
	//玩家离开副本
	LeftFb : function(result){
		var info = {
			"result" : (result?1:0)
		};

		return require('BufferTools').getJsonPathBufferByDict("MyGameReceiveControl","LeftFb",info);
	},
    //副本超时
    FbTimeout : function(){
        var info = {

        };

        return require('BufferTools').getJsonPathBufferByDict("MyGameReceiveControl","FbTimeout",info);
    },
    //加载完毕后开始游戏
    StartGameAfterLoading : function(){
        var info = {

        };

        return require('BufferTools').getJsonPathBufferByDict("MyGameReceiveControl","StartGameAfterLoading",info);
    },
    //加载超时
    ByondLoading : function(){
        var info = {

        };

        return require('BufferTools').getJsonPathBufferByDict("MyGameReceiveControl","ByondLoading",info);
    }
}
