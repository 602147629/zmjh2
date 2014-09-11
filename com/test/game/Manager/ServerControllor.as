package com.test.game.Manager{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Manager.Keyboard.CommonKeyboardInput;
	import com.superkaka.mvc.ControlFactory;
	import com.test.game.Const.KeyOperationType;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	import com.test.game.net.sm.Game.OperationSend;
	
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class ServerControllor extends Singleton{
		private var operations:Array = [];
		private var stepInt:uint;
		private var stepIntMuti:uint;
		private var _currentFrame:int;//当前游戏帧数
		private var _mutiCommands:Vector.<ByteArray> = new Vector.<ByteArray>();
		
		private var _frameCount:int = 0;//游戏开始后的帧数
		
		public function ServerControllor(){
			super();
		}
		
		
		public static function getIns():ServerControllor{
			return Singleton.getIns(ServerControllor);
		}
		
		
		public function start():void{
			this._mutiCommands.length = 0;
			this.operations.length = 0;
			
			this._frameCount = 0;
			
			clearInterval(this.stepInt);
			this.stepInt = setInterval(step,33);
		}
		
		public function acceptOperation(index:int,keyCode:int,oper:int):void{
			//单机
			var obj:Object;
			for each(var objTemp:Object in this.operations){
				if(objTemp.index == index){
					obj = objTemp;
					break;
				}
			}
			if(!obj){
				obj = {};
				obj.index = index;
				obj.keyCodes = [];
				obj.opers = [];
				operations.push(obj);
			}
			obj.keyCodes.push(keyCode);
			obj.opers.push(oper);
		}
		
		private function step():void{
			var command:ByteArray = new ByteArray();
			
			for each(var obj:Object in this.operations){
				var keyLen:int = obj.keyCodes.length;
				command.writeInt(4+keyLen*8);
				command.writeInt(obj.index);
				for(var i:int=0;i<keyLen;i++){
					var keyCode:int = obj.keyCodes[i];
					var oper:int = obj.opers[i];
					command.writeInt(keyCode);
					command.writeInt(oper);
				}
			}
			command.position = 0;
			
			SceneManager.getIns().updateByCommand(command);
			
			//清空操作
			operations.length = 0;
		}
		
		public function playerKillingStart() : void{
			this._mutiCommands.length = 0;
			this.operations.length = 0;
			
			this._frameCount = 0;
			
			clearInterval(stepIntMuti);
			this.stepIntMuti = setInterval(stepMuti,33);
		}
		
		private var keyList:Array = [Keyboard.A, Keyboard.W, Keyboard.S, Keyboard.D, Keyboard.Q, Keyboard.SPACE, Keyboard.J, Keyboard.K, Keyboard.H, Keyboard.U, Keyboard.I, Keyboard.O, Keyboard.L, Keyboard.M]
		public function playerKillingAcceptOperation(index:int,keyCode:int,oper:int) : void{
			var result:Boolean = false;
			for(var i:int = 0; i < keyList.length; i++){
				if(keyCode == keyList[i]){
					result = true;
					break;
				}
			}
			if(!result) return;
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			var sm:OperationSend = new OperationSend(keyCode,oper);
			if(oper == KeyOperationType.KEY_DOWN){
				if(CommonKeyboardInput.getIns().keyboard.isJustKeyDown(keyCode)){
					ssc.sendToFb(sm);
				}
			}else if(oper == KeyOperationType.KEY_UP){
				if(CommonKeyboardInput.getIns().keyboard.isJustKeyUp(keyCode)){
					ssc.sendToFb(sm);
				}
			}
		}
		
		//联机，模式下的渲染
		private function stepMuti():void{
			if(this._mutiCommands.length > 0){
				if(this._mutiCommands.length > 1){
					//积累超过2帧，填补之
					while(this._mutiCommands.length > 0){
						this.stepMutiFrame();
					}
				}else{
					this.stepMutiFrame();
				}
			}
		}
		
		private function stepMutiFrame():void{
			var command:ByteArray = this._mutiCommands.shift();	
			if(command){
				SceneManager.getIns().updateByCommand(command);
			}
		}
		
		
		public function clear():void{
			this._mutiCommands.length = 0;
			clearInterval(this.stepInt);
			clearInterval(this.stepIntMuti);
			this._currentFrame = 0;
			this.operations.length = 0;
		}
		
		
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		public function set currentFrame(value:int):void
		{
			_currentFrame = value;
		}
		
		public function get mutiCommands():Vector.<ByteArray>
		{
			return _mutiCommands;
		}
		
		public function set mutiCommands(value:Vector.<ByteArray>):void
		{
			_mutiCommands = value;
		}

		public function get frameCount():int
		{
			return _frameCount;
		}
		
		public function set frameCount(value:int):void
		{
			this._frameCount = value;
		}
		
	}
}


