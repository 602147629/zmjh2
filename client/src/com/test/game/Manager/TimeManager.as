package com.test.game.Manager
{
	import com.adobe.serialization.json.JSON;
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.Singleton;
	import com.test.game.Utils.AllUtils;
	import com.test.game.Utils.DateUtil;
	import com.test.game.net.http.Http;
	
	import flash.utils.getTimer;
	
	public class TimeManager extends Singleton
	{
		private var _anti:Antiwear;
		
		private var _http:Http;
		// 当前时间
		private var _curTime:Array = [];
		// 年-月-日
		//private var _ymd:String;
		private function get ymd() : String{
			return _anti["ymd"];
		}
		private function set ymd(value:String) : void{
			_anti["ymd"] = value;
		}
		// 时-分-秒
		private var _hms:String;
		// 时间差
		private var _disTime:int;
		
		// 当前时间
		public function get curTimeStr() : String{
			return _anti["curTimeStr"];
		}
		public function set curTimeStr(value:String) : void{
			_anti["curTimeStr"] = value;
		}
		
		private function get curTimeList() : Array{
			return _anti["curTimeList"];
		}
		private function set curTimeList(value:Array) : void{
			_anti["curTimeList"] = value;
		}
		
		private function get timeNowStr() : String{
			return _anti["timeNowStr"];
		}
		private function set timeNowStr(value:String) : void{
			_anti["timeNowStr"] = value;
		}
		
		private var _serverDate:Date;
		public function get serverDate() : Date
		{
			return _serverDate;
		}
		
		public function TimeManager(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["curTimeStr"] = "";
			_anti["ymd"] = "";
			_anti["timeNowStr"] = "";
			_anti["curTimeList"] = new Array();
		}
		
		public static function getIns():TimeManager{
			return Singleton.getIns(TimeManager);
		}
		
		private var _timeURL:String = "http://save.api.4399.com/?ac=get_time";
		
		/**
		 * 请求时间 
		 * @param callback
		 * 
		 */		
		public function reqTime(callback:Function = null) : void{
			if (!_http) _http = new Http();
			_http.onComplete = function (data:String) : void{
				var info:Object = com.adobe.serialization.json.JSON.decode(data);
				var timeData:Array = new Array();
				
				curTimeStr = info["time"];
				timeData = info["time"].split(" ");
				
				/*curTimeStr = "2014-09-09 11:59:00";
				timeData = curTimeStr.split(" ");*/
				
				ymd = timeData[0];
				_hms = timeData[1];
				
				_curTime = ymd.split("-");
				
				curTimeList = analysisTime(curTimeStr);
				_serverDate = new Date(curTimeList[0], (int(curTimeList[1]) - 1), curTimeList[2], curTimeList[3], curTimeList[4], curTimeList[5]);
				trace("服务器时间:" + data);
				if (callback != null) callback();
			};
			_http.loads(_timeURL);
		}
		
		/**
		 * 检测输入日期和服务器时间是同一天
		 * @param input
		 * @return 
		 * 
		 */		
		public function checkEveryDayPlay(input:String) : Boolean{
			var lastDay:String = input.split(" ")[0];
			var disTime:int = disDayNum(lastDay, ymd);
			
			var result:Boolean = (disTime == 0);
			
			return result;
		}
		
		/**
		 * 相差天数 
		 * @return 
		 * 
		 */		
		public function disDayNum(lastDay:String, newYMD:String) : Number{
			lastDay = lastDay.replace("-", "");
			lastDay = lastDay.replace("-", "");
			
			newYMD = newYMD.replace("-", "");
			newYMD = newYMD.replace("-", "");
			
			var disTime:Number = DateUtil.manyDayNum(lastDay, newYMD);
			
			trace("相差天数: " + disTime);
			
			return disTime;
		}
		
		public function analysisTime(time:String) : Array{
			var timeList:Array = time.split(" ");
			var yearList:Array = timeList[0].split("-");
			var dayList:Array = timeList[1].split(":")
			var lastTime:Array = new Array();
			for(var i:int = 0; i < yearList.length; i++){
				lastTime.push(yearList[i]);
			}
			for(var j:int = 0; j < dayList.length; j++){
				lastTime.push(dayList[j]);
			}
			return lastTime;
		}
		
		public function returnTimeNow() : Date{
			if(curTimeList == null){
				curTimeList = analysisTime(curTimeStr);
				_serverDate = new Date(curTimeList[0], (int(curTimeList[1]) - 1), curTimeList[2], curTimeList[3], curTimeList[4], curTimeList[5]);
			}
			var newDate:Date = new Date(curTimeList[0], (int(curTimeList[1]) - 1), curTimeList[2], curTimeList[3], curTimeList[4], curTimeList[5]);
			newDate.milliseconds += getTimer();
			
			return newDate;
		}
		
		public function returnTimeNowStr() : String{
			var nowDate:Date = returnTimeNow();
			timeNowStr = nowDate.fullYear + "-" + AllUtils.addPre(nowDate.month + 1) + "-" + AllUtils.addPre(nowDate.date) + " " + AllUtils.addPre(nowDate.hours) + ":" + AllUtils.addPre(nowDate.minutes) + ":" + AllUtils.addPre(nowDate.seconds);
			return timeNowStr;
		}
		
		//获得输入字符串时间返回的Date
		public function getAnalysisDate(time:String) : Date{
			var timeList:Array = analysisTime(time);
			var newDate:Date = new Date(timeList[0], (int(timeList[1]) - 1), timeList[2], timeList[3], timeList[4], timeList[5]);
			return newDate;
		}
		
		//比较两个时间，返回相差毫秒数
		public function compareTime(start:String, end:String) : Number{
			var result:Number;
			result = getAnalysisDate(end).time - getAnalysisDate(start).time;
			return result;
		}
		
		public function addPre(count:Number) : String{
			var result:String = "";
			if(count < 10)
				result = "0" + count;
			else
				result = count.toString();
			
			return result
		}
		
		/**
		 * 判断当前时间是否早于给定的时间
		 * @param date
		 * @return 
		 * 
		 */		
		public function checkDate(date:String):Boolean{
			var result:Boolean = true;
			var nowDate:String = returnTimeNowStr().split(" ")[0];
			if(disDayNum(date,nowDate)>0){
				result = false;
			}

			return result;
		}
	}
}