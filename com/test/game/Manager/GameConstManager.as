package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	
	
	public class GameConstManager extends Singleton
	{
		public function GameConstManager()
		{
			super();
		}
		
		public static function getIns():GameConstManager{
			return Singleton.getIns(GameConstManager);
		}
		
		public function init() : void{
			GameConst.VERSION = "V1.23";
			GameConst.USE_ASSETS_WORKER = false;//是否使用多线程处理素材
			GameConst.USE_TOTAL_BITMAPDATA = true;//是否使用缓存为一整张位图显示的方式(false时则采用原生显示方式)
			GameConst.USE_UNION_BITMAPDATA = false;//重叠素材是否使用新的合成位图（使用此技术，同屏人数上升，但是内存消耗增加）
			GameConst.useCrypt = false;//是否加密存档
			GameConst.useDebug = true;//是否使用dedbug后台
			GameConst.localData = true;//是否使用本地存档
			GameConst.localLogin = true;//是否本地登录
			GameConst.GATE_IP = "api1.zmjh2.aiwan4399.com";
			GameConst.GATE_PORT = 4097;
		}
	}
}