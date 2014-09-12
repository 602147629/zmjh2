package com.test.game.Modules.ChoosePlayer.view{
	import com.superkaka.Tools.CommonEvent;
	import com.test.game.Mvc.Vo.Player;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import fl.controls.Button;
	
	public class SinglePlayer extends Sprite{
		public static const CHOOSE:String = "choose";
		public static const NEW:String = "new";
		
		private var _nameTf:TextField;
		private var _pidTf:TextField;
		public var _confirmBtn:Button;
		
		private var _player:Player;
		
		public function SinglePlayer(){
			super();
			
		}
		
		
		public function initWithPlayer(player:Player):void{
			_player = player;
			
			_nameTf = new TextField();
			_nameTf.border = true;
			_nameTf.height = 20;
			this.addChild(_nameTf);
			
			_pidTf = new TextField();
			_pidTf.height = 20;
			_pidTf.border = true;
			_pidTf.y = 30;
			this.addChild(_pidTf);
			_pidTf.type = TextFieldType.DYNAMIC;
			
			if(!player){
				_nameTf.type = TextFieldType.INPUT;
				_nameTf.text = "test"+Math.ceil((Math.random()*10000));
			}else{
				_nameTf.text = player.name;
				_nameTf.type = TextFieldType.DYNAMIC;
				
				_pidTf.text = "gameKey:"+player.gameKey+"";
			}
			
			_confirmBtn = new Button();
			_confirmBtn.label = "选择";
			_confirmBtn.y = 60;
			this.addChild(_confirmBtn);
			_confirmBtn.addEventListener(MouseEvent.CLICK,__choose);
		}
		
		protected function __choose(evt:MouseEvent):void{
			if(this._player){
				this.dispatchEvent(new CommonEvent(CHOOSE,this._player));
			}else{
				var p:Player = new Player();
				p.name = _nameTf.text;
				this.dispatchEvent(new CommonEvent(NEW,p));
			}
		}
		
		
		public function destroy():void{
			if(_confirmBtn){
				_confirmBtn.removeEventListener(MouseEvent.CLICK,__choose);
			}
			
			this._player = null;
			this._confirmBtn = null;
			this._nameTf = null;
			this._pidTf = null;
		}
		
	}
}