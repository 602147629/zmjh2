package com.test.game.Manager
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.Singleton;
	
	public class DoubleManager extends Singleton{
		private var _anti:Antiwear;
		public function get doubleTime() : String{
			return _anti["doubleTime"];
		}
		public function set doubleTime(value:String) : void{
			_anti["doubleTime"] = value;
		}
		public function DoubleManager(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["doubleTime"] = "";
		}
		
		public static function getIns():DoubleManager{
			return Singleton.getIns(DoubleManager);
		}
		
		public function get doubleStatus() : int{
			var result:int = 1;
			
			return result;
		}
	}
}