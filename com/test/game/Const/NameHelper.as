package com.test.game.Const
{
	public class NameHelper
	{
		public static function getPropertyName(name:String):String{
			var property:String;
			switch(name){
				case "hp":
					property = "体力";
					break;
				case "mp":
					property = "元气";
					break;
				case "atk":
					property = "外功";
					break;
				case "def":
					property = "根骨";
					break;
				case "ats":
					property = "内功";
					break;
				case "adf":
					property = "罡气";
					break;
				case "hp_regain":
					property = "体力回复";
					break;
				case "mp_regain":
					property = "元气回复";
					break;
				case "hurt_deepen":
					property = "伤害加深";
					break;
				case "hurt_reduce":
					property = "伤害减少";
					break;
				case "hit":
					property = "命中";
					break;
				case "evasion":
					property = "闪避";
					break;
				case "crit":
					property = "暴击";
					break;
				case "toughness":
					property = "韧性";
					break;
				case "spd":
					property = "速度";
					break;
			}
			return property;
		}
		
		
		public static function getChargeName(index:int):String{
			var name:String;
			switch(index){
				case 0:
					name = "黑夜";
					break;
				case 1:
					name = "大雨";
					break;
				case 2:
					name = "狂风";
					break;
				case 3:
					name = "雷鸣";
					break;
			}
			return name;
		}
		
		public static function getColorChargeName(str:String):String{
			var result:String;
			switch(str.substr(0,2)){
				case "黑夜":
					result = ColorConst.setBrown(str);
					break;
				case "大雨":
					result = ColorConst.setBlue(str);
					break;
				case "狂风":
					result = ColorConst.setYellow(str);
					break;
				case "雷鸣":
					result = ColorConst.setPurple(str);
					break;
			}
			return result;
		}
	}
}