package com.test.game.Mvc.control.net.rm{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Control.net.rm.LoginReceiveControl;
	import com.test.game.Manager.MyUserManager;
	import com.test.game.Manager.PlayersManager;
	import com.test.game.Modules.GameMenu.view.GameMenuView;
	import com.test.game.Mvc.Vo.Item;
	
	import flash.utils.ByteArray;
	
	public class MyPlayerReceiveControl extends LoginReceiveControl{
		public function MyPlayerReceiveControl(){
			super();
		}
		
		
		//玩家升级通知
		public function UpgradeLevelTo(body:ByteArray):void{
			trace("-------UpgradeLevelTo----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var level:int = jObj.level;
			var gameKey:String = jObj.gameKey;
			
			//更新玩家管理器内玩家的等级(包括自己的一份)
			PlayersManager.getIns().UpdatePlayerLevel(gameKey,level);
			
//			if(gameKey == MyUserManager.getIns().user.uid){
//				//我自己升级
//				MyUserManager.getIns().socketPlayer.level = level;
//				//刷新界面
//				if(!GameConst.isAutoTest){
//					var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
//					gmv.updatePlayerInfo();
//				}
//			}else{
//				//别人升级
//				
//			}
		}
		
		
		//刷新玩家经验
		public function PlayerExp(body:ByteArray):void{
			trace("-------PlayerExp----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var exp:int = jObj.exp;
			
			MyUserManager.getIns().player.exp = exp;
			if(!GameConst.isAutoTest){
				//刷新界面
				var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
				gmv.updatePlayerInfo();
			}
			
		}
		
		//刷新玩家属性
		public function PlayerProperty(body:ByteArray):void{
			trace("-------PlayerProperty----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var property:Object = jObj.property;
			
			MyUserManager.getIns().player.property.buildFromObject(property);
			if(!GameConst.isAutoTest){
				//刷新界面
				var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
				gmv.updatePlayerInfo();
			}
		}
		
		//背包发生改变
		public function PlayerEquipmentChange(body:ByteArray):void{
			trace("-------PlayerEquipmentChange----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
//			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
//			var items:Array = jObj.items;
//			for each(var iObj:Object in items){
//				var itemId:int = iObj.id;
//				var num:int = iObj.num;
//				var index:int = iObj.index;
//				
//				var newItem:Item = new Item();//是否是新道具
//				newItem.buildFromObject(iObj);
//				
//				var totalItemLen:int = MyUserManager.getIns().player.items.length;
//				for(var i:uint=0;i<totalItemLen;i++){
//					var item:Item = MyUserManager.getIns().player.items[i];
//					if(item.index == index){
//						newItem = null;
//						if(num <= 0){
//							//删除
//							MyUserManager.getIns().player.items.splice(i,1);
//						}else{
//							//置换
//							item.num = num;
//						}
//						break;
//					}
//				}
//				//新增道具
//				if(newItem){
//					MyUserManager.getIns().player.items.push(newItem);
//				}
//			}
//			
//			if(!GameConst.isAutoTest){
//				//刷新界面
//				var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
//				gmv.itemChange();
//			}
		}
		
		public function GetBag(body:ByteArray):void{
			trace("-------GetBag----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			
//			MyUserManager.getIns().player.items.length = 0;
//			var items:Array = jObj.items;
//			for each(var iObj:Object in items){
//				var itemId:int = iObj.id;
//				var num:int = iObj.num;
//				
//				var newItem:Item = new Item();//是否是新道具
//				newItem.buildFromObject(iObj);
//				
//				MyUserManager.getIns().player.items.push(newItem);
//			}
//			if(!GameConst.isAutoTest){
//				//刷新界面
//				var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
//				gmv.itemChange();
//			}
		}
		
	}
}