package com.test.game.Modules.MainGame.ItemCombine
{
	import com.greensock.TweenLite;
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
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Entitys.Map.GetItemIconEntity;
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
	
	public class ChargeCombineView extends BaseView
	{
		
		private var pieceVo:ItemVo;
		private var tokenVo:ItemVo;
		private var pieceIcon:ItemIcon;
		private var tokenIcon:ItemIcon;
		
		private var _combineEffect:BaseSequenceActionBind;
		
		private var _combineEnable:Boolean;
		public var callBack:Function;
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function ChargeCombineView()
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
				typeMc.gotoAndStop("charge");
				this.addChild(layer);
				
				initBg();
				setCenter();
				
				if(callBack!=null){
					callBack();
				}
			}
			
		}
		
		
		
		override public function show():void{
			if(layer == null) return;
			super.show();
		}
		
		override public function update():void{
			
		}
		

		
		public function setData(data:ItemVo):void{
			pieceVo = data;
			tokenVo = PackManager.getIns().creatItem(pieceVo.id + 10);
			
			pieceIcon = new ItemIcon();
			pieceIcon.x = 84;
			pieceIcon.y = 136;
			pieceIcon.selectable = false;
			pieceIcon.menuable = false;
			pieceIcon.num = false;
			layer.addChild(pieceIcon);
			pieceIcon.setData(pieceVo);
			
			tokenIcon = new ItemIcon();
			tokenIcon.x = 238;
			tokenIcon.y = 136;
			tokenIcon.selectable = false;
			tokenIcon.menuable = false;
			tokenIcon.num = false;
			layer.addChild(tokenIcon);
			tokenIcon.setData(tokenVo);
			
			costTxt.text = NumberConst.getIns().weatherCombinePrice.toString();
			
			initEvent();
			checkPieceNum();
			
		}
		
		
		private function checkPieceNum():void{
			var num:int = PackManager.getIns().searchItemNum(pieceVo.id);
				
			GreyEffect.change(tokenIcon);
			
			if(num>=15){
				numTxt.htmlText = ColorConst.setWhite(num.toString()) +"/15";
				if(player.money<NumberConst.getIns().weatherCombinePrice){
					combineBtnEnable(false);
				}else{
					GreyEffect.reset(tokenIcon);
					combineBtnEnable(true);
				}
			}else{
				numTxt.htmlText = ColorConst.setRed(num.toString()) +"/15";
				combineBtnEnable(false);
			}
		}
		

		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			combineBtn.addEventListener(MouseEvent.CLICK,onGetToken);
		}

		
		private function onGetToken(e:MouseEvent):void{
			if(_combineEnable){
				(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
					"是否消耗15件"+ColorConst.setDarkGreen(pieceVo.name)+"与"+NumberConst.getIns().weatherCombinePrice+
				"金钱\n合成"+ColorConst.setDarkGreen(tokenVo.name),showEffect);
			}
		}
		
		private function sureCombine():void{
			PackManager.getIns().reduceItem(pieceVo.id,15);
			PlayerManager.getIns().reduceMoney(NumberConst.getIns().weatherCombinePrice);
			PackManager.getIns().addItemIntoPack(tokenVo.copy());
			checkPieceNum();
			addDropItem(tokenVo);
			combineBtn.mouseEnabled = true;
		}
		
		
		private function showEffect():void{
			combineBtn.mouseEnabled = false;
			_combineEffect = AnimationEffect.createAnimation(10015,["attachEffect"],false,removeEffect)
			_combineEffect.x = 203;
			_combineEffect.y = 102;
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
					,{title:"消耗15件"+pieceVo.name+"合成"+tokenVo.name, tips:""});
			}else{
				GreyEffect.change(combineBtn);
				TipsManager.getIns().addTips(combineBtn
					,{title:pieceVo.name+"数量不足，无法合成", tips:""});
			}
			if(player.money<NumberConst.getIns().weatherCombinePrice){
				TipsManager.getIns().addTips(combineBtn
					,{title:"金钱不足！", tips:""});
			}
			_combineEnable = enable;
		}
		
		private function addDropItem(item:ItemVo) : void{
			
			var fodder:String = item.type+item.id;
			var dropEntity:GetItemIconEntity = new GetItemIconEntity(fodder, 1,555,240);
			LayerManager.getIns().gameTipLayer.addChild(dropEntity);
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
		
		private function get numTxt():TextField
		{
			return layer["typeMc"]["numTxt"];
		}
		
		
		private function close(e:MouseEvent):void{
			removeItemIcons();
			removeEvents();
			ViewFactory.getIns().getView(BagView).show();
			hide();
		}
		
		

		private function removeEvents():void{
			closeBtn.removeEventListener(MouseEvent.CLICK,close);
			combineBtn.removeEventListener(MouseEvent.CLICK,onGetToken);
		}
		
		private function removeItemIcons():void{
			layer.removeChild(pieceIcon);
			pieceIcon.destroy();
			pieceIcon = null;
			
			layer.removeChild(tokenIcon);
			tokenIcon.destroy();
			tokenIcon = null;
			
		}
		
		override public function destroy():void{
			super.destroy();
		}
		
		
	}
}