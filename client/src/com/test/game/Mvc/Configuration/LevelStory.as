package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class LevelStory extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function LevelStory()
		{
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["level_id"] = "";
			_anti["Dialogue_1"] = "";
			_anti["Dialogue_2"] = "";
			_anti["Dialogue_3"] = "";
		}
		
		override public function assign(data:Object):void{
			level_id = data.level_id;
			Dialogue_1 = data.Dialogue_1;
			Dialogue_2 = data.Dialogue_2;
			Dialogue_3 = data.Dialogue_3;
		}
		
		public function get level_id() : String{
			return _anti["level_id"];
		}
		public function set level_id(value:String) : void{
			_anti["level_id"] = value;
		}
		
		public function get Dialogue_1() : String{
			return _anti["Dialogue_1"];
		}
		public function set Dialogue_1(value:String) : void{
			_anti["Dialogue_1"] = value;
		}
		
		public function get Dialogue_2() : String{
			return _anti["Dialogue_2"];
		}
		public function set Dialogue_2(value:String) : void{
			_anti["Dialogue_2"] = value;
		}
		
		public function get Dialogue_3() : String{
			return _anti["Dialogue_3"];
		}
		public function set Dialogue_3(value:String) : void{
			_anti["Dialogue_3"] = value;
		}
	}
}