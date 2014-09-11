package com.test.game.Modules.MainGame.ItemCombine
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.BagView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class FashionCombineView extends BaseView
	{
		
		private var curFashionVo:ItemVo;
		private var nextFashionVo:ItemVo;
		private var _nextFashionIcon:ItemIcon;
		private var _itemIconArr:Array;
		private var _combineEffect:BaseSequenceActionBind;
		
		private var _combineEnable:Boolean;
		public var callBack:Function;
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function FashionCombineView()
		{
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.ITEMCOMBINEVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView,LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function renderView(...args):void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = AssetsManager.getIns().getAssetObject("ItemCombineView") as Sprite;
				typeMc.gotoAndStop("fashion");
				this.addChild(layer);
				
				initBg();
				setCenter();
				
				update();
				initEvent();
				
				if(callBack!=null){
					callBack();
				}
			}
			
		}
		
		
		
		override public function show():void{
			if(layer == null) return;
			update();
			super.show();
		}
		
		override public function update():void{
			
		}
		

		
		public function setData(data:ItemVo):void{
			curFashionVo = data;
			_itemIconArr = [];
			for(var i:int =0;i<3;i++){
				var itemIcon:ItemIcon = new ItemIcon();
				if(i<2){
					itemIcon.x = 94+i*144;
					itemIcon.y = 90;
				}else{
					itemIcon.x = 162;
					itemIcon.y = 220;
				}
				
				itemIcon.selectable = false;
				itemIcon.menuable = false;
				itemIcon.num = true;
				layer.addChild(itemIcon);
				itemIcon.setData(curFashionVo);
				_itemIconArr.push(itemIcon);
			}
			
			nextFashionVo = PackManager.getIns().creatItem(curFashionVo.fashionConfig.next);
			
			_nextFashionIcon = new ItemIcon();
			_nextFashionIcon.x = 162;
			_nextFashionIcon.y = 146;
			_nextFashionIcon.selectable = false;
			_nextFashionIcon.menuable = false;
			_nextFashionIcon.num = true;
			layer.addChild(_nextFashionIcon);
			_nextFashionIcon.setData(nextFashionVo);
			
			costTxt.text = curFashionVo.fashionConfig.money.toString();
			
			checkFashionNum();
			
		}
		
		
		private function checkFashionNum():void{
			var num:int;
			for each(var fashion:ItemVo in player.pack.fashion){
				if(fashion.id == curFashionVo.id && fashion.mid>0){
					num++;
				}
			}
			num = Math.min(num,3);
			
			if(num>=3){
				if(player.money<curFashionVo.fashionConfig.money){
					combineBtnEnable(false);
				}else{
					combineBtnEnable(true);
				}
			}else{
				combineBtnEnable(false);
			}
			
			for(var i:int = 0;i<3;i++){
				if(i<num){
					GreyEffect.reset(_itemIconArr[i]);
				}else{
					GreyEffect.change(_itemIconArr[i]);
				}
				
			}
		}
		
		
		
		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			combineBtn.addEventListener(MouseEvent.CLICK,onGetNext);
		}

		
		private function onGetNext(e:MouseEvent):void{
			if(_combineEnable){
				(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
					"是否消耗3件"+ColorConst.setLightBlue(curFashionVo.name)+"与"+curFashionVo.fashionConfig.money+
				"金钱\n合成"+ColorConst.setGold(nextFashionVo.name),showEffect);
			}
		}
		
		private function sureCombine():void{
			var arr:Array = [];
			for (var i:int=0;i<player.pack.fashion.length;i++){
				var fashion:ItemVo = player.pack.fashion[i]
				if(fashion.id == curFashionVo.id && fashion.mid>0){
					arr.push(fashion);
				}
				if(arr.length == 3){
					break;
				}
			}
			
			for each (var item:ItemVo in arr){
				PackManager.getIns().reduceItemByItemVo(item,1);
			}
			
			PlayerManager.getIns().reduceMoney(curFashionVo.fashionConfig.money);
			PackManager.getIns().addItemIntoPack(nextFashionVo.copy());
			checkFashionNum();
			combineBtn.mouseEnabled = true;
		}
		
		
		private function showEffect():void{
			combineBtn.mouseEnabled = false;
			_combineEffect = AnimationEffect.createAnimation(10015,["attachEffect"],false,removeEffect)
			_combineEffect.x = 128;
			_combineEffect.y = 112;
			layer.addChild(_combineEffect);
			RenderEntityManager.getIns().removeEntity(_combineEffect);
			AnimationManager.getIns().addEntity(_combineEffect);
		}
		
		private function removeEffect(...args):void{
			if(_combineEffect != null){
				AnimationManager.getIns().removeEntity(_combineEffect);
				_combineEffect.destroy();
				_combineEffect = null;
			}
			sureCombine();
		}
		
		
		private function combineBtnEnable(enable:Boolean):void{
			if(enable){
				GreyEffect.reset(combineBtn);
				TipsManager.getIns().addTips(combineBtn
					,{title:"消耗3件"+curFashionVo.name+"合成"+nextFashionVo.name, tips:""});
			}else{
				GreyEffect.change(combineBtn);
				TipsManager.getIns().addTips(combineBtn
					,{title:"时装数量不足，无法合成", tips:""});
			}
			if(player.money<curFashionVo.fashionConfig.money){
				TipsManager.getIns().addTips(combineBtn
					,{title:"金钱不足！", tips:""});
			}
			_combineEnable = enable;
		}
		
		
		private function get typeMc():MovieClip
		{
			return layer["typeMc"];
		}
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		private function get combineBtn():SimpleButton
		{
			return layer["typeMc"]["combineBtn"];
		}
		
		private function get costTxt():TextField
		{
			return layer["typeMc"]["costTxt"];
		}
		

		
		
		private function close(e:MouseEvent):void{
			removeItemIcons();
			ViewFactory.getIns().getView(BagView).show();
			hide();
		}
		
		private function removeItemIcons():void{
			
			for(var i:int =0;i<_itemIconArr.length;i++){
				layer.removeChild(_itemIconArr[i]);
				(_itemIconArr[i] as ItemIcon).destroy();
			}
			_itemIconArr = [];
			
			layer.removeChild(_nextFashionIcon);
			_nextFashionIcon.destroy();
			_nextFashionIcon = null;
			
		}
		
		override public function destroy():void{
			closeBtn.removeEventListener(MouseEvent.CLICK,close);
			combineBtn.removeEventListener(MouseEvent.CLICK,onGetNext);
			for(var i:int=0;i<_itemIconArr.length;i++){
				_itemIconArr[i].destroy();
			}
			super.destroy();
		}
		
		
	}
}