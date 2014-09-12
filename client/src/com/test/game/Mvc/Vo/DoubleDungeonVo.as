package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Manager.Extra.DoubleDungeonManager;
	
	public class DoubleDungeonVo extends BaseVO{
		
		private var _anti:Antiwear;
		public function get doubleTime() : String{
			return _anti["doubleTime"];
		}
		public function set doubleTime(value:String) : void{
			_anti["doubleTime"] = value;
		}
		public function get dungeonName() : String{
			return _anti["dungeonName"];
		}
		public function set dungeonName(value:String) : void{
			_anti["dungeonName"] = value;;
		}
		
		public function DoubleDungeonVo(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["doubleTime"] = "";
			_anti["dungeonName"] = "";
		}
		
		//判断是否刷新每日任务
		public function judgeDoubleDungeon() : void{
			if(doubleTime != ""){
				var result:Boolean = TimeManager.getIns().checkEveryDayPlay(doubleTime.split("_")[0]);
				if(!result){
					doubleTime = "";
					dungeonName = "";
				}else{
					DoubleDungeonManager.getIns().updateDoubleTime();
				}
			}else{
				DoubleDungeonManager.getIns().updateDoubleTime();
			}
		}
	}
}