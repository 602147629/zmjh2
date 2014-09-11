package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class ConjureVo extends CharacterVo
	{
		private var _anti:Antiwear;
		public function ConjureVo(data:Object)
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["ID"] = 0;
			_anti["id"] = data.id;
			_anti["atk"] = data.atk;
			_anti["ats"] = data.ats;
		}
		
		public function get ID():int{
			return _anti["ID"];
		}
		public function set ID(value:int):void{
			_anti["ID"] = value;
		}
		
		override public function get id():int{
			return _anti["id"];
		}
		override public function set id(value:int):void{
			_anti["id"] = value;
		}
		
		public function get atk():int{
			return _anti["atk"];
		}
		public function set atk(value:int):void{
			_anti["atk"] = value;
		}
		
		public function get ats():int{
			return _anti["ats"];
		}
		public function set ats(value:int):void{
			_anti["ats"] = value;
		}
	}
}