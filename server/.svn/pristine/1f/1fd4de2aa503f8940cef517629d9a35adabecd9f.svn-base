module.exports = {
	//登录成功
	GetUsersByUid: function(user,players){
		var info = {
			"user" : user.getInfoJson(),
			"players" : players
		};
		return require('BufferTools').getJsonPathBufferByDict("MyLoginReceiveControl","LoginSuccess",info);
	},
	//选择角色返回
	ChoosePlayerReturn : function(result,player){
		var info;
        if(result == 1){
            info = {
                "result" : result,
                "player" : player.getInfoJson()
            };
        }else{
            info = {
                "result" : result
            };
        }
		return require('BufferTools').getJsonPathBufferByDict("MyLoginReceiveControl","ChoosePlayerReturn",info);
	},
	//玩家被踢下线
	PlayerBeKicked : function(){
		return require('BufferTools').getPathBufferByDict("MyLoginReceiveControl","PlayerBeKicked");
	},
    //服务器维护
    ServerStop : function(){
        return require('BufferTools').getPathBufferByDict("MyLoginReceiveControl","ServerStop");
    },
    //登录失败
    LoginFail : function(){
        var info = {

        };
        return require('BufferTools').getJsonPathBufferByDict("MyLoginReceiveControl","LoginFail",info);
    }
}
