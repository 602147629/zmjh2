package com.test.game.Const
{
	public class JingMaiConst
	{

		public static function getJingMaiName(type:int):String{
			var name:String = "";
			switch(type){
				case 2:
					name = "督脉";
					break;
				case 3:
					name = "带脉";
					break;
				case 4:
					name = "冲脉";
					break;
				case 5:
					name = "手太阴肺经";
					break;
				case 6:
					name = "手厥阴心包经";
					break;
				case 7:
					name = "手少阴心经";
					break;
				case 8:
					name = "手太阳小肠经";
					break;
				case 9:
					name = "手少阳三焦经";
					break;
				case 10:
					name = "手阳明大肠经";
					break;
					
			}
			return name;
		}
	}
}