package com.test.game.Manager
{
	import com.gameServer.RankFor4399;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	
	public class RankManager extends Singleton
	{
		public function RankManager()
		{
			super();
		}
		
		public static function getIns():RankManager{
			return Singleton.getIns(RankManager);
		}
		
		public function submitScoreToRankList() : void{
			if(!GameConst.localLogin){
				var arr:Array = new Array();
				arr.push(onGetMoneyData);
				arr.push(onGetSoulData);
				arr.push(onEquipmentData);
				arr.push(onBagNumData);
				arr.push(onGetFightData);
				RankFor4399.getIns().submitScoreToRankLists(PlayerManager.getIns().saveIndex, arr);
				
				/*var arr1:Array = new Array();
				arr1.push(onLiftData);
				arr1.push(onWanNengData);
				arr1.push(onChongXiuData);
				RankFor4399.getIns().submitScoreToRankLists(PlayerManager.getIns().saveIndex, arr1);*/
			}
		}
		
		private function get onGetMoneyData() : Object{
			var obj:Object = new Object();
			obj.rId = 905;
			obj.score = PlayerManager.getIns().player.money;
			return obj;
		}
		
		private function get onGetSoulData() : Object{
			var obj:Object = new Object();
			obj.rId = 906;
			obj.score = PlayerManager.getIns().player.soul;
			return obj;
		}
		
		private function get onGetFightData() : Object{
			var num:int = PlayerManager.getIns().battlePower;
			var obj:Object = new Object();
			obj.rId = 907;
			obj.score = num;
			return obj;
		}
		
		private function get onEquipmentData() : Object{
			var obj:Object = new Object();
			obj.rId = 908;
			obj.score = int(PlayerManager.getIns().player.pack.equip.length);
			return obj;
		}
		
		private function get onLevelGiftData() : Object{
			var num:int = 0;
			for(var i:int = 6001; i <= 6020; i++){
				num += PackManager.getIns().searchItemNum(i);
			}
			var obj:Object = new Object();
			obj.rId = 909;
			obj.score = num;
			return obj;
		}
		
		private function get onBagNumData() : Object{
			var obj:Object = new Object();
			obj.rId = 910;
			obj.score = PlayerManager.getIns().player.pack.packMaxRoom;
			return obj;
		}
		
		private function get onLiftData() : Object{
			var obj:Object = new Object();
			obj.rId = 918;
			obj.score = PackManager.getIns().searchItemNum(6201);
			return obj;
		}
		
		private function get onWanNengData() : Object{
			var obj:Object = new Object();
			obj.rId = 919;
			obj.score = PackManager.getIns().searchItemNum(9000);
			return obj;
		}
		
		private function get onChongXiuData() : Object{
			var obj:Object = new Object();
			obj.rId = 920;
			obj.score = PackManager.getIns().searchItemNum(6203);
			return obj;
		}
	}
}