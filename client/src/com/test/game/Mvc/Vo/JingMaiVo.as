package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Configuration.JingMai;
	
	public class JingMaiVo extends BaseVO
	{
		public function JingMaiVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["jingMaiArr"] =  [0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
			_anti["bookPoint"] = 0;
		}
		
		private var _anti:Antiwear;	
		
		/**
		 * 经脉修炼数组
		 */
		public function get jingMaiArr() : Array
		{
			return _anti["jingMaiArr"];
		}
		public function set jingMaiArr(value:Array) : void
		{
			_anti["jingMaiArr"] = value;
		}
		
		
		/**
		 * 重修之书获得的潜能点
		 */		
		public function get bookPoint() : int
		{
			return _anti["bookPoint"];
		}
		public function set bookPoint(value:int) : void
		{
			_anti["bookPoint"] = value;
		}
		
		public function get curPoint():int{
			var num:int = 0;

			num = PlayerManager.getIns().player.character.lv+bookPoint-costPoint;
			if(num>PlayerManager.getIns().player.character.lv+bookPoint){
				num = PlayerManager.getIns().player.character.lv;
			}
			return num;
		}
		
		public function get costPoint():int{
			var cost:int = 0;
			for(var i:int=0;i<jingMaiArr.length;i++){
				if(jingMaiArr[i]>0){
					cost+=jingMaiArr[i];
				}
			}
			return cost;
		}
		
		public function get jingMaiPower():int{
			var power:int = 0;
			for(var i:int =0;i<player.jingMai.jingMaiArr.length;i++){
				if(player.jingMai.jingMaiArr[i]>0){
					var jingMaiData:JingMai = ConfigurationManager.getIns().getObjectByID(
						AssetsConst.JINGMAI,i+1) as JingMai;
					for(var j:int =0;j<player.jingMai.jingMaiArr[i];j++){
						power += int(jingMaiData.add_value[j]);
					}
				}
			}
			return power;
		}
		
		private function get player():PlayerVo
		{
			return PlayerManager.getIns().player;
		}
		
	}
}