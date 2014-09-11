package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.TimeManager;
	
	public class EliteDungeonVo extends BaseVO
	{
		private var _anti:Antiwear;
		public function EliteDungeonVo()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["eliteTime"] = "";
		}
		
		//精英副本通关等级
		private var _eliteDungeonPass:Vector.<EliteDungeonPassVo> = new Vector.<EliteDungeonPassVo>();
		public function get eliteDungeonPass():Vector.<EliteDungeonPassVo>{
			return _eliteDungeonPass;
		}
		
		public function set eliteDungeonPass(value:Vector.<EliteDungeonPassVo>):void{
			_eliteDungeonPass = value;
		}
		
		public function get eliteTime() : String{
			return _anti["eliteTime"];
		}
		public function set eliteTime(value:String) : void{
			_anti["eliteTime"] =  value;
		}
		
		public function getEliteDungeonPass() : Object{
			var eliteDungeons:Object = new Object(); 
			for(var i:int=0;i<this.eliteDungeonPass.length;i++){
				var eliteDungeon:Object = new Object();
				eliteDungeon.name = this.eliteDungeonPass[i].name;
				eliteDungeon.lv = this.eliteDungeonPass[i].lv;
				eliteDungeon.hit = this.eliteDungeonPass[i].hit;
				eliteDungeon.hurt = this.eliteDungeonPass[i].hurt;
				eliteDungeon.add = this.eliteDungeonPass[i].add;
				eliteDungeon.num = this.eliteDungeonPass[i].num;
				eliteDungeon.time = this.eliteDungeonPass[i].time;
				eliteDungeons[eliteDungeon.name] = eliteDungeon;
			}
			
			var time:Object = new Object();
			time.name = "time";
			time.time = eliteTime;
			eliteDungeons["time"] = time;
			
			return eliteDungeons;
		}
		
		/**
		 * 判断是否需要重置挑战次数
		 * 
		 */		
		public function judgeResetFightNum() : void{
			var result:Boolean = TimeManager.getIns().checkEveryDayPlay(eliteTime.split("_")[0]);
			if(!result || eliteTime == ""){
				for(var i:int=0;i<this.eliteDungeonPass.length;i++){
					eliteDungeonPass[i].num = NumberConst.getIns().zero;
				}
				eliteTime = TimeManager.getIns().curTimeStr;
			}
		}
	}
}