package {
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Const.ProtocolDict;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Control.net.SMessage;
	import com.test.game.Const.KeyOperationType;
	import com.test.game.Manager.JsonObjectToInstanceManager;
	import com.test.game.Mvc.Proxy.FbSocketProxy;
	import com.test.game.Mvc.Proxy.GameSocketProxy;
	import com.test.game.Mvc.Proxy.GateSocketProxy;
	import com.test.game.Mvc.Vo.Line;
	import com.test.game.Mvc.Vo.Player;
	import com.test.game.Mvc.control.data.ProtocalControl;
	import com.test.game.Mvc.control.data.ServersControllor;
	import com.test.game.net.sm.Connector.LoginConnector;
	import com.test.game.net.sm.Game.LoadingComplete;
	import com.test.game.net.sm.Game.OperationSend;
	import com.test.game.net.sm.Gate.LoginGate;
	import com.test.game.net.sm.Line.ChooseLine;
	import com.test.game.net.sm.Login.ChoosePlayer;
	import com.test.game.net.sm.Login.NewPlayer;
	import com.test.game.net.sm.Room.AutoPipei;
	import com.test.game.net.sm.Room.JoinRoom;
	
	import flash.events.EventDispatcher;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.setInterval;
	
	public class SocketConnectManagerTest extends EventDispatcher{
		private var playerdata:Object = {"skill":{"skill_O":7,"skillArr":[6,6,6,6,6,6,6,6,6,6],"kungfu2":5,"kungfu1":5,"skill_H":1,"skill_I":2,"skill_U":6,"skill_L":5},"skillUp":{"skillBooks5":["5","0","0","0","0"],"skillBooks7":["4","0","0","0","0"],"skillBooks8":["4","0","0","0","0"],"skillBooks9":["4","0","0","0","0"],"skillBooks10":["4","0","0","0","0"],"skillLevels":["0","1","0","0","0","0","1","0","0","0"],"skillBooks6":["4","0","0","0","0"],"skillBooks1":["4","0","0","0","0"],"skillBooks2":["4","0","0","0","0"],"skillBooks3":["4","0","0","0","0"],"skillBooks4":["4","0","0","0","0"]},"occupation":2,"BaGuaProperty":{"evasion":0,"atk_spd":0,"crit":0,"toughness":0,"mp":0,"spd":0,"hp":600,"atk":28,"def":0,"adf":0,"hp_regain":20,"ats":0,"mp_regain":0,"hurt_deepen":0,"hurt_reduce":0,"hit":0},"assistInfo":10021,"assetsArray":["XiaoYaoBackHand","XiaoYaoBackHair","XiaoYaoClothes","XiaoYaoHead","XiaoYaoWeapon","XiaoYaoFrontHand","XiaoYaoShoulder03","XiaoYaoFrontHair"],"lv":37,"ConjureLv":1,"pkInfo":{"preExp":1600,"nowExp":5600,"isReachMaxLevel":false,"pkExp":3300,"pkLose":0,"pkWin":0,"pkCanStart":1,"pkTime":"","pkLv":3,"pkCount":0,"preResult":0,"pkStatus":1},"EquipProperty":{"evasion":0,"atk_spd":0,"crit":0,"toughness":0,"mp":0,"spd":0,"hp":0,"atk":0,"def":0,"adf":165,"hp_regain":0,"ats":0,"mp_regain":0,"hurt_deepen":0,"hurt_reduce":0,"hit":0},"LevelUpProperty":{"evasion":0,"atk_spd":0,"crit":0,"toughness":0,"mp":540,"spd":0,"hp":5400,"atk":180,"def":72,"adf":108,"hp_regain":0,"ats":252,"mp_regain":0,"hurt_deepen":0,"hurt_reduce":0,"hit":0},"ConfigProperty":{"evasion":0,"atk_spd":0,"crit":0,"toughness":0,"mp":600,"spd":9,"hp":3000,"atk":200,"def":125,"adf":150,"hp_regain":0,"ats":250,"mp_regain":6,"hurt_deepen":0,"hurt_reduce":0,"hit":0},"AttachProperty":{"evasion":0,"atk_spd":0,"crit":0,"toughness":0,"mp":0,"spd":0,"hp":2100,"atk":0,"def":0,"adf":0,"hp_regain":0,"ats":0,"mp_regain":0,"hurt_deepen":0,"hurt_reduce":0,"hit":0},"fightNum":14905,"name":"打酱油"}
		
		public function SocketConnectManagerTest(uid){
			super();
			
			this.uid = uid;
			
			var pc:ProtocalControl = ControlFactory.getIns().getControl(ProtocalControl) as ProtocalControl;
			var json:Object = pc.getProtocolJson();
			
			//协议
			ProtocolDict.getIns().initToServerFileDict(json.protocolToServerFile);
			ProtocolDict.getIns().initToServerFuncDict(json.protocolToServerFunc);
			
			ProtocolDict.getIns().initToClientFileDict(json.protocolToClientFile);
			ProtocolDict.getIns().initToClientFuncDict(json.protocolToClientFunc);
			
			this.connectToGate();
		}
		
		public static function getIns():SocketConnectManagerTest{
			return Singleton.getIns(SocketConnectManagerTest);
		}
		
		
		public function connectToGate():void{
			//gate服务器
			gateSp = new GateSocketProxy();
			gateSp.connectTo(GameConst.GATE_IP,GameConst.GATE_PORT,onGateConnect,onData);
		}
		
		
		public function connectToGame(ip:String,port:int):void{
			//game服务器
			gameSp = new GameSocketProxy();
			gameSp.connectTo(ip,port,onGameConnect,onData);
		}
		
		public function connectToFb(ip:String,port:int):void{
			//fb服务器
			fbSp = new FbSocketProxy();
			fbSp.connectTo(ip,port,onFbConnect,onData);
		}
		
		private function onData(data:ByteArray,codeName:String):void{
			//加密类型
			var encodeType:int = data.readByte();
			//是否验证数据完整性
			var crypt:int = data.readByte();
			
			if(encodeType == 1){
				//解密
				var key:int = ProtocolDict.getIns().getDecodeKey(codeName);
				var len:int = data.length;
				for(var i:uint=0;i<len;i++){
					data[i] = data[i]^key;
				}
			}
			
			if(crypt == 1){
				//验证数据完整（S->C默认不验证）
			}
			
			var path:String = data.readUTF();
//			trace("onData--path:"+path);
			
			var body:ByteArray = new ByteArray();
			body.endian = Endian.LITTLE_ENDIAN;
			body.writeBytes(data,data.position);
			body.position = 0;
			
			var pathArr:Array = path.split(".");
			var funcIndex:String = pathArr.pop();
			var fileIndex:String = pathArr.pop();
			
			//解析字典
			var fileName:String = ProtocolDict.getIns().protocolToClientFile[fileIndex];
			if(!fileName){
				throw new Error("protocolToClientFile fileName not found!fileName:"+fileName);
			}
			var funcName:String = ProtocolDict.getIns().protocolToClientFunc[fileName][funcIndex];
			if(!funcName){
				throw new Error("protocolToClientFunc funcName not found!funcName:"+funcName);
			}
			
			trace("fileName:"+fileName);
			trace("funcName:"+funcName);
			
			if(fileName == "MyGateReceiveControl"){
				if(funcName == "GetServerInfoReturn"){
					var str:String = body.readUTFBytes(body.bytesAvailable);
					//DebugArea.getIns().showInfo("str:"+str)
					trace("str:"+str);
					var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
					var serverArr:Array = jObj.servers;
					var connector:Object = jObj.connector;
					ServersControllor.getIns().curConnector = JsonObjectToInstanceManager.getIns().getConnector(connector)
					this.loginKey = jObj.key;//登录密钥
					this.gateServerId = jObj.serverId;
					
					var server:Object = serverArr[0];
					
					ServersControllor.getIns().curServer = JsonObjectToInstanceManager.getIns().getServer(server);
					
					//连接game服务器
					this.connectToGame(connector.ip,connector.port);
				}
			}else if(fileName == "MyLoginReceiveControl"){
				if(funcName == "LoginSuccess"){
					var str:String = body.readUTFBytes(body.bytesAvailable);
					trace("str:"+str)
					var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
					
					//角色信息
					var players:Vector.<Player> = new Vector.<Player>();
					for(var i:uint=0;i<jObj.players.length;i++){
						var p:Object = jObj.players[i];
						
						var player:Player = new Player();
						player.buildFromObject(p);
						players.push(player);
					}
					
					var sm:SMessage;
					if(players.length == 0){
						//创建角色
						var choosePlayer:Player = new Player();
						if(GameConst.LOG_DATA){
							choosePlayer.name = GameConst.LOG_DATA.nickName; 
						}else{
							choosePlayer.name = "undefined"; 
						}
						sm = new NewPlayer(choosePlayer);
						gameSp.send(sm);
					}else{
						//选择角色
						sm = new ChoosePlayer(players[0]);
						gameSp.send(sm);
					}
				}else if(funcName == "ChoosePlayerReturn"){
					var str:String = body.readUTFBytes(body.bytesAvailable);
					trace("str:"+str)
					var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
					var p:Object = jObj.player;
					this.gameKey = p.gameKey;
					
					var chooseLine:Line = new Line();
					chooseLine.id = 1;
					var sm:SMessage = new ChooseLine(chooseLine);
					gameSp.send(sm);
				}
			}else if(fileName == "MyLineReceiveControl"){
				if(funcName == "ChooseLineReturn"){
					//自动匹配
					var auto:AutoPipei = new AutoPipei(playerdata,1,30,2,1,6);
					gameSp.send(auto);
				}
			}else if(fileName == "MyRoomReceiveControl"){
				if(funcName == "StartGame"){
					//发送加载完毕
					var loadC:LoadingComplete = new LoadingComplete();
					fbSp.send(loadC);
				}else if(funcName == "CreateRoomReturn"){
					//加入房间
					var str:String = body.readUTFBytes(body.bytesAvailable);
					trace("str:"+str);
					//DebugArea.getIns().showInfo("str:"+str)
					var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
					var err:String = jObj.err;
					var type:int = jObj.type;
					this.roomKey = jObj.key;
					this.roomId = jObj.roomId;
					var ip:String = jObj.ip;
					var port:int = jObj.port;	
					
					
					this.connectToFb(ip,port);
				}
			}else if(fileName == "MyGameReceiveControl"){
				if(funcName == "StartGameAfterLoading"){
					//自动发送按键操作
					setInterval(autoSendOperation,100);
				}
			}
			
			
			data.clear();
			body.clear();
		}
		
		private var arr:Array = [Keyboard.A,Keyboard.S,Keyboard.W,Keyboard.D];
		private var arr2:Array = [Keyboard.J,Keyboard.K,Keyboard.U,Keyboard.I];
		private function autoSendOperation():void{
			var keyCode:int = Keyboard.A;
			var oper:OperationSend = new OperationSend(keyCode,KeyOperationType.KEY_DOWN);
			fbSp.send(oper);
			
			keyCode = Keyboard.S;
			oper = new OperationSend(keyCode,KeyOperationType.KEY_DOWN);
			fbSp.send(oper);
			
			
			keyCode = Keyboard.J;
			oper = new OperationSend(keyCode,KeyOperationType.KEY_DOWN);
			fbSp.send(oper);
			
			keyCode = Keyboard.K;
			oper = new OperationSend(keyCode,KeyOperationType.KEY_DOWN);
			fbSp.send(oper);
		}
		
		public var uid:int;
		public var loginKey:String;
		public var gateServerId:int;
		
		public var gameKey:String;
		public var roomKey:String;
		public var roomId:int;

		private var fbSp:FbSocketProxy;

		private var gateSp:GateSocketProxy;

		private var gameSp:GameSocketProxy;
		
		/**
		 * 连接上gate服务器 
		 * 
		 */	
		private function onGateConnect():void{
			//登录gate
			var sm:LoginGate = new LoginGate(this.uid);
			gateSp.send(sm);
			
//			if(!GameConst.isPressureTest){
//				var initLoadingComplete:InitLoadingCompleteControl = ControlFactory.getIns().getControl(InitLoadingCompleteControl) as InitLoadingCompleteControl;
//				initLoadingComplete.execute();
//			}
		}
		
		/**
		 * 连接上game服务器 
		 * 
		 */	
		private function onGameConnect():void{
			//登录game
			var sm:LoginConnector = new LoginConnector(this.uid,this.loginKey,this.gateServerId,ServersControllor.getIns().curServer.id);
			gameSp.send(sm);
			
			
			
		}
		
		/**
		 * 连接上fb服务器 
		 * 
		 */	
		private function onFbConnect():void{
			//加入房间
			var sm:JoinRoom = new JoinRoom(this.roomKey,this.roomId,this.gameKey);
			fbSp.send(sm);
			
		}
		
	}
}