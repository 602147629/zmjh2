package com.test.game.Modules.MainGame.BaGua
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.MovieClip;
	
	public class SuanGuaIcon extends BaseSprite
	{
		private var _anti:Antiwear
		private var _obj:MovieClip;

		public var previousPosition:Object;
		public var mergedFrom:Object;
		
		private var _position:Object;
		public function get position():Object
		{
			return _position;
		}
		public function set position(value:Object):void
		{
			_position = value;
		}

		
		public function get numValue():int
		{
			return _anti["value"];
		}
		public function set numValue(value:int):void
		{
			_anti["value"] = value;
			_obj.gotoAndStop("BaGua"+value);
			
		}
		
		private var _posX:int;
		public function get posX():int
		{
			return _posX;
		}
		public function set posX(value:int):void
		{
			_posX = value;
		}

		private var _posY:int;
		public function get posY():int
		{
			return _posY;
		}
		public function set posY(value:int):void
		{
			_posY = value;
		}

		
		public function SuanGuaIcon(position:Object, value:int)
		{
			_anti = new Antiwear(new binaryEncrypt());
			_anti["value"] = 0;
			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("SuanGuaIcon") as MovieClip;
				this.addChild(_obj);
			}
			
			this.posX  = position.x;
			this.posY  = position.y;
			this.numValue = value || 2;
			
			this.previousPosition = null;
			this.mergedFrom       = null; // Tracks tiles that merged together

			super();
		}


		public function savePosition() :void{
			previousPosition = { x: this.posX, y: this.posY };
		}
		
		public function updatePosition(position) :void{
			posX = position.x;
			posY = position.y;
		};
		
		public function serialize() :Object{
			return {
				position: {
					x: posX,
					y: posY
				},
				value: numValue
			};
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		override public function destroy():void{
			removeComponent(_obj);
			super.destroy();
		}
		
	}
}