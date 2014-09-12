package
{
	import com.gameServer.ApiFor4399;
	import com.gameServer.RankFor4399;
	import com.gameServer.ShopFor4399;
	import com.superkaka.game.Const.GameConst;
	import com.test.game.GameMain;
	import com.test.game.Manager.GameConstManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.Socket;
	import flash.system.Security;

//	import flash.system.WorskeraaDomain;
	
	
	[SWF(width='940', height='590', frameRate='30')]
	public class Main extends Sprite{
		
		//======此代码为存档功能专用代码========/
		public const _4399_function_store_id:String = '3885799f65acec467d97b4923caebaae';
		//======此代码为多排行榜功能专用代码========/
		public const _4399_function_rankList_id:String = '69f52ab6eb1061853a761ee8c26324ae';
		//======此代码为商城功能专用代码========/
		public const _4399_function_shop_id:String = '30ea6b51a23275df624b781c3eb43ac6';
		public const _4399_function_payMoney_id:String = '10f73c09b41d9f41e761232f5f322f38';
		//======此代码为api通用代码，在所有api里面只需加一次========/
		public static var serviceHold:* = null;
		public function setHold(hold:*):void
		{
			serviceHold = hold;
		}
		public function Main(){
			GameConstManager.getIns().init();
			if(!stage){
				this.addEventListener(Event.ADDED_TO_STAGE,__added);
			}else{
				this.init();
			}
		}
		
		protected function __added(evt:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,__added);
			this.init();
		}
		
		private var api:ApiFor4399;

		private var socket:Socket;
		
		
		private function init():void{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
//			if(GameConst.USE_ASSETS_WORKER && WorkerDomain.isSupported){
//				var url:String = this.loaderInfo.url;
//				if(url.indexOf("www.4399api.com") != -1){
//					//api测试
//					GameConst.ASSETS_URL = "http://www.4399api.com/system/attachment/100/02/19/100021992/Assets/";
//				}else if(url.indexOf("file://") != -1){
//					//本地
//					GameConst.ASSETS_URL = "http://127.0.0.1/zmjh2/Assets/";
//				}else if(url.indexOf("s1.4399.com") != -1){
//					//s1
//					
//				}else if(url.indexOf("s8.4399.com") != -1){
//					//s8
//					
//				}
				
				//启动多线程
//				AssetsMainWorker.getIns().initWorker(Workers.com_superkaka_game_Manager_Workers_Assets_AssetsWorker);
//			}
			//checkHold();
			ApiFor4399.getIns().stage = this.stage;
			RankFor4399.getIns().stage = this.stage;
			ShopFor4399.getIns().stage = this.stage;
			GameConst.stage = this.stage;
			stage.stageFocusRect = false;
			//configUI();
			
			/*var myContextMenu:ContextMenu = new ContextMenu();
			var mAuthor:ContextMenuItem = new ContextMenuItem("我们是星星后宫粉丝团！");
			myContextMenu.customItems.push(mAuthor);
			this.contextMenu = myContextMenu;*/

			
			new GameMain(this);
		}
	}
}