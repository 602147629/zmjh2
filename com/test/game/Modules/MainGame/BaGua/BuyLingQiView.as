package com.test.game.Modules.MainGame.BaGua
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.BaGuaManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class BuyLingQiView extends BaseView
	{		
		private var blueBaguaPiece:BaGuaPiece;
		private var purpleBaguaPiece:BaGuaPiece;
		private var blueVo:BaGuaPieceVo;
		private var purpleVo:BaGuaPieceVo;
		private var _attachEffect:BaseSequenceActionBind;
		private var _baguaEnable:Boolean;
		
		public function BuyLingQiView()
		{
			renderView();
		}		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function renderView():void{
			
			LoadManager.getIns().hideProgress();
			layer = AssetsManager.getIns().getAssetObject("BuyLingQiView") as Sprite;
			layer.x = 300;
			layer.y = 150;
			this.addChild(layer);
			
			blueVo = BaGuaManager.getIns().creatLingQiBaGua(8901);
			purpleVo = BaGuaManager.getIns().creatLingQiBaGua(8902);
			
			blueBaguaPiece = new BaGuaPiece();
			blueBaguaPiece.x = 95; 
			blueBaguaPiece.y = 90;
			blueBaguaPiece.dragable = false;
			blueBaguaPiece.menuable = false;
			layer.addChild(blueBaguaPiece);
			blueBaguaPiece.setData(blueVo);
			
			purpleBaguaPiece = new BaGuaPiece();
			purpleBaguaPiece.x = 220;
			purpleBaguaPiece.y = 90;
			purpleBaguaPiece.menuable = false;
			purpleBaguaPiece.dragable = false;
			layer.addChild(purpleBaguaPiece);
			purpleBaguaPiece.setData(purpleVo);
			
			TipsManager.getIns().addTips(blueBtn,{title:"花费3000命数购买一张蓝色灵气牌",tips:""});
			TipsManager.getIns().addTips(purpleBtn,{title:"花费8000命数购买一张紫色灵气牌",tips:""});
			
			update();
			initBg();
			initEvent();
		}
		
		
		
		override public function show():void{
			if(layer == null) return;
			update();
			super.show();
		}
		
		private function close(e:MouseEvent):void{
			this.hide();
		}
		
		
		
		override public function update():void{
			scoreTxt.text = player.baGuaScore.toString();
			_baguaEnable = true;
		}
		
		
		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			blueBtn.addEventListener(MouseEvent.CLICK,onBlueClick);
			purpleBtn.addEventListener(MouseEvent.CLICK,onPurpleClick);
		}
		
		
		private function onBlueClick(e:MouseEvent):void{
			(ViewFactory.getIns().initView(TipView) as TipView).setFun(
				"花费3000命数购买一张蓝色灵气牌？",getBlueBagua);
		}
		
		private function onPurpleClick(e:MouseEvent):void{
			(ViewFactory.getIns().initView(TipView) as TipView).setFun(
				"花费8000命数购买一张紫色灵气牌？",getPurpleBagua);
		}
		
		
		private function getBlueBagua():void
		{
			addBaGuaPiece(1);
		}
		
		private function getPurpleBagua():void
		{
			addBaGuaPiece(2);
		}
		
		private function addBaGuaPiece(color:int):void{
			if(_baguaEnable){
				_baguaEnable = false;
				var bagState:int = BaGuaManager.getIns().checkFull();
				if(bagState>=0){
					sureBuyBagua(color);
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"八卦牌背包已满！请整理，否则无法获得八卦牌");
					_baguaEnable = true;
				}
			}
			
		}
		
		private function sureBuyBagua(color:int):void{
			switch(color){
				case 1:
					if(player.baGuaScore>=50*60){
						showEffect(blueBaguaPiece.x,blueBaguaPiece.y);
						BaGuaManager.getIns().addBaGuaIntoPack(blueVo.copy());
						PlayerManager.getIns().reduceBaGuaScore(50*60);
						(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
							blueVo.name+"购买成功！");	
					}else{
						(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
							blueVo.name+"命数不足！");	
					}
					break;
				case 2:
					if(player.baGuaScore>=20*400){
						showEffect(purpleBaguaPiece.x,purpleBaguaPiece.y);
						BaGuaManager.getIns().addBaGuaIntoPack(purpleVo.copy());
						PlayerManager.getIns().reduceBaGuaScore(20*400);
						(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
							purpleVo.name+"购买成功！");
					}else{
						(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
							blueVo.name+"命数不足！");
					}
					break;
			}
			update();
			ViewFactory.getIns().getView(BaGuaView).update();
		}

		
		private function showEffect(x:int,y:int):void{
			_attachEffect = AnimationEffect.createAnimation(10015,["attachEffect"],false,removeEffect)
			_attachEffect.x = x - 33;
			_attachEffect.y = y - 33;
			layer.addChild(_attachEffect);
			RenderEntityManager.getIns().removeEntity(_attachEffect);
			AnimationManager.getIns().addEntity(_attachEffect);
		}
		
		private function removeEffect(...args):void{
			if(_attachEffect != null){
				AnimationManager.getIns().removeEntity(_attachEffect);
				_attachEffect.destroy();
				_attachEffect = null;
			}
		}
		
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		private function get blueBtn():SimpleButton
		{
			return layer["blueBtn"];
		}
		
		private function get purpleBtn():SimpleButton
		{
			return layer["purpleBtn"];
		}
		
		private function get scoreTxt():TextField
		{
			return layer["scoreTxt"];
		}
		
		
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		
		override public function destroy():void{
			if(closeBtn.hasEventListener(MouseEvent.CLICK)){
				closeBtn.removeEventListener(MouseEvent.CLICK,close);;
			}
			super.destroy();
		}
	}
}