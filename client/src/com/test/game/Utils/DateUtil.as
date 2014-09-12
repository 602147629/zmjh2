/**
 *@title as3指定的两个公历日期相差天数类库
 *@author xuechong
 *@version 0.1
 *@date 2010.08.17
 *@environment as3.0 FlashPlayer9
 *@调用方式 trace(SelfDateUtil.manyDayNum("20081230", "20110317"));
 * */

package com.test.game.Utils{
	public class DateUtil{
		public function DateUtil(){}
		
		/**
		 * 虽然名字为fromFormatDayStr和toFormatDayStr， 单两个参数所代表的开始和结束年份没有先后顺序；如：
		 * SelfDateUtil.manyDayNum("20081230", "20110317")与SelfDateUtil.manyDayNum("20110317", "20081230")等效。
		 * */
		public static function manyDayNum(fromFormatDayStr:String, toFormatDayStr:String):Number{
			var manyAllDayNum:Number = 0;    //间隔的天数
			var _fromYear:int = int(fromFormatDayStr.substr(0, 4));
			var _toYear:int = int(toFormatDayStr.substr(0, 4));
			if(_toYear == _fromYear){    //同一年
				manyAllDayNum = Number(alreadyOverDay(toFormatDayStr)[0]) - Number(alreadyOverDay(fromFormatDayStr)[0]);
			}else if(Math.abs(_toYear - _fromYear) == 1){    //相差一年
				if(_toYear > _fromYear){
					manyAllDayNum = Number(alreadyOverDay(fromFormatDayStr)[1]) + Number(alreadyOverDay(toFormatDayStr)[0]);
				}else{
					manyAllDayNum = Number(alreadyOverDay(toFormatDayStr)[1]) + Number(alreadyOverDay(fromFormatDayStr)[0]);
				}
			}else{    //相差两年或者两年以上
				var mangYearNum:Number = Math.abs(Number(_toYear - _fromYear));    //中间间隔的年份
				if(_toYear > _fromYear){
					manyAllDayNum = Number(alreadyOverDay(fromFormatDayStr)[1]) + Number(alreadyOverDay(toFormatDayStr)[0]);
					for(var i:int = 1; i < mangYearNum; i++){
						if(isRunYear(String(_fromYear + i))){    //是闰年
							manyAllDayNum += 366;
						}else{    //不是闰年
							manyAllDayNum += 365;
						}
					}
				}else{
					manyAllDayNum = Number(alreadyOverDay(toFormatDayStr)[1]) + Number(alreadyOverDay(fromFormatDayStr)[0]);
					for(var j:int = 1; j < mangYearNum; j++){
						if(isRunYear(String(_toYear + j))){    //是闰年
							manyAllDayNum += 366;
						}else{    //不是闰年
							manyAllDayNum += 365;
						}
					}
				}
			}
			return manyAllDayNum;
		}
		
		/**指定的一年之内已经过了多少天了(算上当天)，
		 *dayStr标准格式为YYYYMMDD，例如：20100816
		 *要保证dayStr参数的格式和实际含义正确，如不能出现20100229
		 *[0]表示已经过了多少天，[1]表示还剩下多少天 */
		public static function alreadyOverDay(dayFormatStr:String):Array{
			var _tempArr:Array = new Array();
			var alreadyDayNum:int = 0;
			var _year:int = int(dayFormatStr.substr(0, 4));
			var _month:int = int(dayFormatStr.substr(4, 2));
			var _day:int = int(dayFormatStr.substr(6, 2));
			if(_month == 1){
				alreadyDayNum = _day;
			}else if(_month == 3){
				alreadyDayNum = 31 + _day;
			}else if(_month == 4){
				alreadyDayNum = 62 + _day;
			}else if(_month == 5){
				alreadyDayNum = 92 + _day;
			}else if(_month == 6){
				alreadyDayNum = 123 + _day;
			}else if(_month == 7){
				alreadyDayNum = 153 + _day;
			}else if(_month == 8){
				alreadyDayNum = 184 + _day;
			}else if(_month == 9){
				alreadyDayNum = 215 + _day;
			}else if(_month == 10){
				alreadyDayNum = 245 + _day;
			}else if(_month == 11){
				alreadyDayNum = 276 + _day;
			}else if(_month == 12){
				alreadyDayNum = 306 + _day;
			}
			if(isRunYear(dayFormatStr)){    //是闰年
				if(_month == 2){
					alreadyDayNum = 31 + _day;
				}else if(_month == 1){
					
				}else{
					alreadyDayNum += 29;
				}
				_tempArr[0] = alreadyDayNum;    //已经过的天数(算上今天)
				_tempArr[1] = 366 - alreadyDayNum;    //还剩多少天没有过
			}else{    //不是闰年
				if(_month == 2){
					alreadyDayNum = 31 + _day;
				}else if(_month == 1){
					
				}else{
					alreadyDayNum += 28;
				}
				_tempArr[0] = alreadyDayNum;    //已经过的天数(算上今天)
				_tempArr[1] = 365 - alreadyDayNum;    //还剩多少天没有过
			}
			return _tempArr;
		}
		
		/*指定的一年中过了多少天了，dayStr标准格式为YYYYMMDD，例如：20100816*/
		public static function isRunYear(dayStr:String):Boolean{
			var _year:Number = Number(dayStr.substr(0, 4));
			if((_year % 4 == 0 && _year % 100 != 0) || _year % 400 == 0){
				return true;
			}else{
				return false;
			}
		}
		
	}
}