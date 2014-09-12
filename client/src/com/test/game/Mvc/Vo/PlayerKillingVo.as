package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.ConfigurationManager;
	
	public class PlayerKillingVo extends BaseVO
	{
		private var _anti:Antiwear;
		public var isReachMaxLevel:Boolean = false;
		public var preExp:int;
		public var nowExp:int;
		public function PlayerKillingVo()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["pkExp"] = 0;
			_anti["pkWin"] = 0;
			_anti["pkLose"] = 0;
			_anti["pkTime"] = "";
			_anti["pkCount"] = 0;
			_anti["pkCanStart"] = 0;
			_anti["preResult"] = 0;
			_anti["pkStatus"] = 1;
			_anti["pkLv"] = 0;
		}
		
		public function updatePKLv() : void{
			var arr:Array = getLevelInfo(pkExp);
			preExp = arr[0];
			nowExp = arr[1];
			pkLv = arr[2];
			
			if(pkStatus == 0){
				pkLose++;
				pkStatus = 1;
			}
		}
		
		/**
		 * 获得输入的经验值对应等级的数据
		 * @param exp
		 * @return 
		 * 
		 */		
		public function getLevelInfo(exp:int) : Array{
			var result:Array = new Array;
			var _levelInfo:Array = ConfigurationManager.getIns().getAllData(AssetsConst.PK_EXP);
			for(var i:int = 0; i < _levelInfo.length; i++){
				if(exp >= _levelInfo[i].exp){
					continue;
				}else{
					if(i - 1 < 0){
						result.push(0);
					}else{
						result.push(_levelInfo[i - 1].exp);
					}
					result.push(_levelInfo[i].exp);
					result.push(i + 1);
					break;
				}
			}
			
			if(result[2] == NumberConst.getIns().pkMaxLv){
				result = [0, 0, NumberConst.getIns().pkMaxLv];
			}
			return result;
		}
		
		public function addPKExp(value:int) : void{
			addExp(value);
			updatePKLv();
		}
		
		private function addExp(value:int) : Boolean{
			var arr:Array = ConfigurationManager.getIns().getAllData(AssetsConst.PK_EXP);
			var isLevelUp:Boolean = false;
			if(isReachMaxLevel || pkExp == arr[NumberConst.getIns().pkMaxLv - 2].exp){
				return isLevelUp;
			}
			pkExp += value;
			var indexLv:int = (pkLv-1<0?0:pkLv-1);
			for(var i:int = indexLv; i < NumberConst.getIns().pkMaxLv - 1; i++){
				if(pkExp >= arr[i].exp){
					if(pkExp >= arr[NumberConst.getIns().pkMaxLv - 2].exp){
						pkLv = arr[NumberConst.getIns().pkMaxLv - 1].lv;
						pkExp = arr[NumberConst.getIns().pkMaxLv - 2].exp;
						if(!isReachMaxLevel){
							isLevelUp = true;
						}
						isReachMaxLevel = true;
						break;
					}else{
						isLevelUp = true;
					}
					continue;
				}else{
					pkLv = arr[i].lv;
					break;
				}
			}
			return isLevelUp;
		}
		
		public function get pkLv() : int{
			return _anti["pkLv"];
		}
		public function set pkLv(value:int) : void{
			_anti["pkLv"] = value;
		}
		
		public function get pkExp() : int{
			return _anti["pkExp"];
		}
		public function set pkExp(value:int) : void{
			_anti["pkExp"] = value;
		}
		
		public function get pkWin() : int{
			return _anti["pkWin"];
		}
		public function set pkWin(value:int) : void{
			_anti["pkWin"] = value;
		}
		
		public function get pkLose() : int{
			return _anti["pkLose"];
		}
		public function set pkLose(value:int) : void{
			_anti["pkLose"] = value;
		}
		
		public function get pkTime() : String{
			return _anti["pkTime"];
		}
		public function set pkTime(value:String) : void{
			_anti["pkTime"] = value;
		}
		
		public function get pkCount() : int{
			return _anti["pkCount"];
		}
		public function set pkCount(value:int) : void{
			_anti["pkCount"] = value;
		}
		
		public function get pkCanStart() : int{
			return _anti["pkCanStart"];
		}
		public function set pkCanStart(value:int) : void{
			_anti["pkCanStart"] = value;
		}
		
		public function get preResult() : int{
			return _anti["preResult"];
		}
		public function set preResult(value:int) : void{
			_anti["preResult"] = value;
		}
		
		public function get pkStatus() : int{
			return _anti["pkStatus"];
		}
		public function set pkStatus(value:int) : void{
			_anti["pkStatus"] = value;
		}
	}
}