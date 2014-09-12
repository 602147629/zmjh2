package com.test.game.Modules.MainGame.Achieve
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Configuration.Achieve;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ItemIcon;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class AchieveComponent extends BaseSprite implements IGrid
	{
		private var _obj:Sprite;
		
		private var _itemIcon1:ItemIcon;
		
		private var _itemIcon2:ItemIcon;
		
		private var _itemVo1:ItemVo;
		
		private var _itemVo2:ItemVo;
		
		private var _data:Achieve;
		private var _getEnable:Boolean;
		
		public function AchieveComponent()
		{
			//this.buttonMode = true;
			//this.mouseChildren = false;
			
			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("AchieveComponent") as Sprite;
				this.addChild(_obj);
			}
			
			if(!_itemIcon1){
				_itemIcon1 = new ItemIcon();
				_itemIcon1.x = 185;
				_itemIcon1.y = 25;
				_itemIcon1.selectable = false;
				_itemIcon1.menuable = false;
				_itemIcon1.num = true;
				this.addChild(_itemIcon1);
			}
			
			if(!_itemIcon2){
				_itemIcon2 = new ItemIcon();
				_itemIcon2.x = 235;
				_itemIcon2.y = 25;
				_itemIcon2.selectable = false;
				_itemIcon2.menuable = false;
				_itemIcon2.num = true;
				this.addChild(_itemIcon2);
			}
			
			initEvent();
			super();
		}
		
		
		public function setData(data:*) : void{
			if(data == null){
				this.visible = false;
				return;
			}
			this.visible = true;
			_data = data as Achieve;
			
			var itemArr:Array = _data.prop_id.split("|");
			var itemNumArr:Array = _data.number.split("|");
			
			_itemVo1 = PackManager.getIns().creatItem(int(itemArr[0]));
			_itemVo1.num = int(itemNumArr[0]);
			_itemIcon1.setData(_itemVo1);
			
			_itemVo2 = PackManager.getIns().creatItem(int(itemArr[1]));
			_itemVo2.num = int(itemNumArr[1]);
			_itemIcon2.setData(_itemVo2);
			
			TipsManager.getIns().addTips(moneyIcon,{title:"金钱："+_data.gold, tips:""});
			TipsManager.getIns().addTips(soulIcon,{title:"战魂："+_data.soul, tips:""});
			
			achieveTitle.gotoAndStop(_data.id);
			achieveIcon.gotoAndStop(_data.id);
			
			
			var isGet:int = int(player.achieveArr[_data.id-1]);
			getBtn.visible = true;
			completeIcon.visible = false;
			if(isGet==NumberConst.getIns().zero){
				getBtnEnable(true);	
				TipsManager.getIns().addTips(getBtn,{title:"点击领取奖励", tips:""});
			}else if(isGet==NumberConst.getIns().negativeOne){
				getBtnEnable(false);	
				TipsManager.getIns().addTips(getBtn,{title:"完成要求即可领取奖励", tips:""});
			}else{
				getBtnEnable(false);
				completeIcon.visible = true;
				getBtn.visible = false;
				TipsManager.getIns().addTips(getBtn,{title:"已领取奖励", tips:""});
			}
			
			
		}
		
		private function initEvent():void{
			getBtn.addEventListener(MouseEvent.CLICK,_onGet);
		}
		
		private  function _onGet(event:MouseEvent):void
		{
			if(_getEnable){
				if(PackManager.getIns().checkMaxRooM([_itemVo1,_itemVo2])){
					PackManager.getIns().addItemIntoPack(_itemVo1.copy());
					PackManager.getIns().addItemIntoPack(_itemVo2.copy());
					PlayerManager.getIns().addMoney(_data.gold);
					PlayerManager.getIns().addSoul(_data.soul);
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"获得\n金钱"+_data.gold+"\n战魂"+_data.soul+","
						+_itemVo1.name+"x"+_itemVo1.num+","+_itemVo2.name+"x"+_itemVo2.num);
					setAchieveGet();
					ViewFactory.getIns().getView(AchieveView).update();
					ViewFactory.getIns().getView(MainToolBar).update();
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"背包空间不足！\n请留出空间后再领取");
				}
			}
		}
		
		private function setAchieveGet():void{
			var arr:Array = player.achieveArr;
			arr[_data.id-1] = NumberConst.getIns().one;
			player.achieveArr = arr;
		}
		
		private function getBtnEnable(enable:Boolean):void{
			if(enable){
				GreyEffect.reset(getBtn);
			}else{
				GreyEffect.change(getBtn);
			}
			_getEnable = enable;
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		private function get completeIcon():Sprite
		{
			return _obj["completeIcon"];
		}
		
		
		private function get achieveIcon():MovieClip
		{
			return _obj["achieveIcon"];
		}
		
		private function get achieveTitle():MovieClip
		{
			return _obj["achieveTitle"];
		}
		
		private function get moneyIcon():Sprite
		{
			return _obj["moneyIcon"];
		}
		
		private function get soulIcon():Sprite
		{
			return _obj["soulIcon"];
		}

		
		private function get getBtn():SimpleButton
		{
			return _obj["getBtn"];
		}
		

		
		public function setLocked() : void{
		}
		
		public function set menuable(value:Boolean) : void{
		}
		
		public function set selectable(value:Boolean) : void{
		}
		
		public function set index(value:int) : void{
		}
		
		override public function destroy():void{
			removeComponent(_obj);
			_itemIcon1.destroy();
			_itemIcon2.destroy();
			super.destroy();
		}
	}
}