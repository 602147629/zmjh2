package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TimeManager;
	
	public class HeroScriptVo extends BaseVO
	{
		public function HeroScriptVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["addValueArr"] =  [0,0,0,0,0,0];
			_anti["heroFightNum"] = 0;
			_anti["heroSpecialFightNum"] = 0;
			_anti["heroTime"] = "";
		}
		
		private var _anti:Antiwear;	
		
		/**
		 * 伙伴加成数组
		 */
		public function get addValueArr() : Array
		{
			return _anti["addValueArr"];
		}
		public function set addValueArr(value:Array) : void
		{
			_anti["addValueArr"] = value;
		}
		
		/**
		 * 伙伴加成等级数组
		 */
		public function get addLvArr() : Array
		{
			return _anti["addLvArr"];
		}
		public function set addLvArr(value:Array) : void
		{
			_anti["addLvArr"] = value;
		}
		
		
		/**
		 * boss挑战次数
		 */		
		public function get heroFightNum() : int
		{
			return _anti["heroFightNum"];
		}
		public function set heroFightNum(value:int) : void
		{
			_anti["heroFightNum"] = value;
		}
		
		/**
		 * 外传boss挑战次数
		 */		
		public function get heroSpecialFightNum() : int
		{
			return _anti["heroSpecialFightNum"];
		}
		public function set heroSpecialFightNum(value:int) : void
		{
			_anti["heroSpecialFightNum"] = value;
		}
		
		/**
		 * 外传boss挑战总计数
		 */		
		public function get heroSpecialFightCount() : int
		{
			return _anti["heroSpecialFightCount"];
		}
		public function set heroSpecialFightCount(value:int) : void
		{
			_anti["heroSpecialFightCount"] = value;
		}
		
		public function get heroTime() : String{
			return _anti["heroTime"];
		}
		public function set heroTime(value:String) : void{
			_anti["heroTime"] =  value;
		}
		

		private function get player():PlayerVo
		{
			return PlayerManager.getIns().player;
		}
		
		/**
		 * 判断是否需要重置挑战次数
		 * 
		 */		
		public function judgeResetFightNum() : void{
			var result:Boolean = TimeManager.getIns().checkEveryDayPlay(heroTime.split("_")[0]);
			if(!result || heroTime == ""){
				heroFightNum = NumberConst.getIns().zero;
				heroSpecialFightNum = NumberConst.getIns().zero;
				heroTime = TimeManager.getIns().curTimeStr;
			}
		}
		
		//获得平均等级
		public function getAverageLv() : Array{
			var result:Array = [10,10,10,10,10,10];
			var property:Array = ["hp", "mp", "atk", "def", "ats", "adf"];
			var _heroUpInfo:Array = ConfigurationManager.getIns().getAllData(AssetsConst.HEROUP);
			for(var j:int = 2; j < addValueArr.length; j++){
				var exp:int = addValueArr[j];
				for(var i:int = 0; i < _heroUpInfo.length; i++){
					if(exp >= _heroUpInfo[i][property[j]]){
						continue;
					}else{
						result[j] = ((result[j] < i + 1)?result:i + 1);
						break;
					}
				}
			}
			for(var k:int = 0; k < result.length; k++){
				if(result[k] > NumberConst.getIns().five){
					result[k] = NumberConst.getIns().five;
				}
			}
			result.shift();
			result.shift();
			return result;
		}

		
	}
}