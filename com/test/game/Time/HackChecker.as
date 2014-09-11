package com.test.game.Time
{
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public final class HackChecker
	{
		public static const checkInterval:int = 1000;
		
		private static var blur:int = 20;
		private static var timer:Timer;
		
		private static var prevDate:Number;//上次记录的时间
		private static var prevTime:int;//上次记录的Time
		
		/**
		 * 验证出错函数 
		 */
		public static var hackHandler:Function = defaultHackHandler;
		
		public static var resetHandler:Function = resetHackHandler;
		
		private static var countNum:int = 0;
		
		private static var continueNum:int = 0;
		/**
		 * 激活变速齿轮验证 
		 * 
		 * @param interval	检测间隔
		 * 
		 */
		public static function enabledCheckSpeedUp(interval:int = 1000,blur:int = 20):void
		{
			HackChecker.blur = blur;
			
			//var nextTime:int = getTimer();
			//var interval:int = nextTime - prevTime;
			
			timer = new Timer(interval);
			timer.addEventListener(TimerEvent.TIMER,timeHandler);
			timer.start();
		}
		
		private static function timeHandler(event:TimerEvent):void
		{
			var nextTime:int = getTimer();
			var newDate:Number = (new Date()).time;
			
			var interval:int = nextTime - prevTime;
			
			if (!isNaN(prevDate) && Math.abs(interval - (newDate - prevDate)) > blur)	
			{
				if(hackHandler != null) hackHandler();
			}
			else
			{
				if(resetHandler != null) resetHandler();
			}
			
			prevDate = newDate;
			prevTime = nextTime;
		}
		
		public static function defaultHackHandler():void
		{
			throw new Error("请不要使用作弊工具!");
		}
		
		public static function resetHackHandler() : void
		{
			throw new Error("未使用加速工具");
		}
	}
}