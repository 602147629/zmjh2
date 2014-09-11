package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class EnemyVo extends CharacterVo
	{
		private var _anti:Antiwear;
		
		public function EnemyVo(data:Object)
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["ID"] = data.ID;
			_anti["fodder"] = data.fodder;
			_anti["name"] = data.name;
			_anti["type"] = data.type;
			_anti["sid"] = data.sid;
			_anti["ai"] = data.ai;
			_anti["gender"] = data.gender;
			_anti["common_distance"] = data.common_distance;
			_anti["skill_distance"] = data.skill_distance;
			_anti["hue"] = data.hue;
			
			sequenceId = data.sid;
			assetsArray = data.fodder.split("|");
			isDouble = true;
		}
		
		public function get ID():int{
			return _anti["ID"];
		}
		public function set ID(value:int):void{
			_anti["ID"] = value;
		}
		
		public function get fodder() : String{
			return _anti["fodder"];
		}
		public function set fodder(value:String) : void{
			_anti["fodder"] = value;
		}
		
		override public function get name() : String{
			return _anti["name"];
		}
		override public function set name(value:String) : void{
			_anti["name"] = value;
		}
		
		public function get type():int{
			return _anti["type"];
		}
		public function set type(value:int):void{
			_anti["type"] = value;
		}
		
		public function get sid():int{
			return _anti["sid"];
		}
		public function set sid(value:int):void{
			_anti["sid"] = value;
		}
		
		public function get ai() : String{
			return _anti["ai"];
		}
		public function set ai(value:String) : void{
			_anti["ai"] = value;
		}
		
		public function get gender():String{
			return _anti["gender"];
		}
		public function set gender(value:String):void{
			_anti["gender"] = value;
		}
		
		public function get common_distance() : int{
			return _anti["common_distance"];
		}
		public function set common_distance(value:int) : void{
			_anti["common_distance"] = value;
		}
		
		public function get skill_distance() : String{
			return _anti["skill_distance"];
		}
		public function set skill_distance(value:String) : void{
			_anti["skill_distance"] = value;
		}
		
		public function get hue():int{
			return _anti["hue"];
		}
		public function set hue(value:int):void{
			_anti["hue"] = value;
		}
	}
}