package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.system.IMEConversionMode;
	
	public class IMEManager extends Singleton
	{
		public function IMEManager()
		{
			super();
		}
		
		public static function getIns():IMEManager{
			return Singleton.getIns(IMEManager);
		}
		
		//设置为英文输入法
		public function setEnglishIMEStatus() : void{
			//使用者的电脑中是否有安裝 IME (Capabilities.hasIME)
			if (Capabilities.hasIME){
				//使用者的电脑目前启用或停用 IME (IME.enabled)
				if (IME.enabled){
					//目前 IME 所使用的装换模式 (IME.conversionMode) 
					IME.conversionMode = IMEConversionMode.ALPHANUMERIC_HALF;
				}
			}
		}
	}
}