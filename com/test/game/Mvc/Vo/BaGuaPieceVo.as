package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Mvc.Configuration.EightDiagrams;
	
	public class BaGuaPieceVo extends BaseVO
	{
		
		private var _anti:Antiwear;
		
		public var eightDiagram:EightDiagrams;
		
		public function BaGuaPieceVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			eightDiagram = new EightDiagrams();
			type = ItemTypeConst.BAGUA;
		}
		
		
		public function get id():int
		{
			return _anti["id"];
		}
		public function set id(value:int):void
		{
			_anti["id"] = value;
		}
		
		public function get cid():int
		{
			return _anti["cid"];
		}
		public function set cid(value:int):void
		{
			_anti["cid"] = value;
		}
		
		public function get name():String
		{
			return _anti["name"];
		}
		public function set name(value:String):void
		{
			_anti["name"] = value;
		}
		
		public function get lv():int
		{
			return _anti["lv"];
		}
		public function set lv(value:int):void
		{
			_anti["lv"] = value;
		}
		
		
		public function get exp():int
		{
			return _anti["exp"];
		}
		public function set exp(value:int):void
		{
			_anti["exp"] = value;
		}
		
		public function get maxExp():int
		{
			var max:int;
			if(lv>=NumberConst.getIns().baguaMaxLv){
				max = eightDiagram.exp*Math.pow(2,NumberConst.getIns().baguaMaxLv-2)
			}else{
				max = eightDiagram.exp*Math.pow(2,lv-1)
			}
			return max;
		}

		
		public function get type():String
		{
			return _anti["type"];
		}
		public function set type(value:String):void
		{
			_anti["type"] = value;
		}
		
		//锁定保护
		public function get protect():int
		{
			return _anti["protect"];
		}
		public function set protect(value:int):void
		{
			_anti["protect"] = value;
		}
		
		
		/**
		 * 
		 * 八卦牌方向 0乾 顺时针以此类推 
		 * 
		 */		
		public function get index():int
		{
			return int(id.toString().substr(3,1))-1;
		}
		
		/**
		 * 
		 * 八卦牌颜色 0绿色 1蓝色 2紫色
		 * 
		 */		
		public function get color():int{
			return int(id.toString().substr(1,1));
		}
		
		/**
		 * 
		 * 是否是灵气牌
		 * 
		 */		
		public function get isLingqi():Boolean{
			var result:Boolean = false;
			if(eightDiagram.add_type[0]=="0"){
				result = true;
			}
			return result;
		}
		
		/**
		 * 
		 * 八卦牌套装ID
		 * 
		 */		
		public function get suitId():int{
			return int(id.toString().substr(1,2));
		}
		
		public function get baseExp():int
		{
			var result:int;
			if(suitId == 90){
				result = 0;
			}else{
				switch(eightDiagram.color){
					case "绿":
						result = NumberConst.getIns().baguaGreen;
						break;
					case "蓝":
						result = NumberConst.getIns().baguaBlue;
						break;
					case "紫":
						result = NumberConst.getIns().baguaPurple;
						break;
				}
			}

			return result;
		}
		
		public function copy():BaGuaPieceVo{
			var bagua:BaGuaPieceVo = new BaGuaPieceVo();
			
			bagua.eightDiagram = this.eightDiagram;
			bagua.id = this.id;
			bagua.cid = this.cid;
			bagua.name = this.name;
			bagua.lv = this.lv;
			bagua.exp = this.exp;
			
			return bagua;
		}


	}
}