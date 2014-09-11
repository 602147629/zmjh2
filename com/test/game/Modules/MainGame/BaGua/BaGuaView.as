package com.test.game.Modules.MainGame.BaGua
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.DigitalEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.BaGuaManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.Mvc.Vo.BasePropertyVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.Grid.BaGuaAutoGrid;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class BaGuaView extends BaseView
	{
		
		private var _baGuaGrid:BaGuaAutoGrid;
		
		private var _attachBaGuaArr:Vector.<BaGuaAttached>;
		
		private static const orginFortuneBarWidth:int = 115;
		
		private var effectEnd:Boolean = true;
		
		public function BaGuaView()
		{
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.BAGUAVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView,LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		private function renderView(...args):void{
			
			LoadManager.getIns().hideProgress();
			layer = AssetsManager.getIns().getAssetObject("BaGuaView") as Sprite;
			this.addChild(layer);
			
			suanGuaBtn.buttonMode = true;
			xianLingBtn.buttonMode = true;
			TipsManager.getIns().addTips(mingShuMc,{title:"命数：算卦合成卦象的时候获得的点数，可以累积点数抽取八卦牌",tips:""});
			
			update();
			initEvent();
			
			GuideManager.getIns().baGuaPanGuideSetting();
		}
		
		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			suanGuaBtn.addEventListener(MouseEvent.CLICK,showSuanGua);
			buMingBtn.addEventListener(MouseEvent.CLICK,buMing);
			xianLingBtn.addEventListener(MouseEvent.CLICK,xianLing);
			oneKeyCombineBtn.addEventListener(MouseEvent.CLICK,oneKeyCombine);
			couponBtn.addEventListener(MouseEvent.CLICK,onCouponShow);
			lingQiBtn.addEventListener(MouseEvent.CLICK,onBuyLingQiShow);
			EventManager.getIns().addEventListener(EventConst.BAGUA_STOP_DRAG,onBaguaStopDrag);
			EventManager.getIns().addEventListener(EventConst.ATTACHED_BAGUA_STOP_DRAG,onAttachedStopDrag);
			EventManager.getIns().addEventListener(EventConst.BAGUA_UNLOCK,onUnlock);
			
		}
		
		protected function onCouponShow(event:MouseEvent):void
		{
			(ViewFactory.getIns().initView(CouponBaguaView) as CouponBaguaView).show();
		}	
		
		protected function onBuyLingQiShow(event:MouseEvent):void
		{
			(ViewFactory.getIns().initView(BuyLingQiView) as BuyLingQiView).show();
		}
		
		
		/**
		 * 
		 * 一键聚灵
		 * 
		 */		
		protected function oneKeyCombine(event:MouseEvent):void
		{
			if(BaGuaManager.getIns().unProtectedBaGuaPiece.length>1 && effectEnd){
				var receiver:BaGuaPieceVo = null;
				var arr:Vector.<BaGuaPieceVo> =  sortByCombine(BaGuaManager.getIns().unProtectedBaGuaPiece);
				for(var i:int=0;i<arr.length;i++){
					if(arr[i].lv<NumberConst.getIns().baguaMaxLv && arr[i].isLingqi==false){
						receiver =arr[i];
						break;
					}
				}
				if(receiver){
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice(
						receiver.name+"将会吞噬背包中其他八卦牌！是否确定聚灵？",sureOneKeyCombine);	
				}
			}
		}		
		
		private function sureOneKeyCombine():void{
			var arr:Vector.<BaGuaPieceVo> =  sortByCombine(BaGuaManager.getIns().unProtectedBaGuaPiece);
			var receiver:BaGuaPieceVo = null;
			for(var i:int=0;i<arr.length;i++){
				if(arr[i].lv<NumberConst.getIns().baguaMaxLv && arr[i].isLingqi==false){
					receiver =arr[i];
					break;
				}
			}
			for each(var bagua:BaGuaPieceVo in arr){
				if(bagua != receiver){
					BaGuaManager.getIns().combineBaGua(bagua,receiver);
				}
			}
			var x:int = (receiver.cid%6)*50;
			var y:int = int(receiver.cid/6)*50;
			showEffect(x,y);	
		}
		
		//按照聚灵顺序排序
		public function sortByCombine(vector:Vector.<BaGuaPieceVo>):Vector.<BaGuaPieceVo>{
			
			var newVector:Vector.<BaGuaPieceVo> = new Vector.<BaGuaPieceVo>;
			newVector=vector.sort(compare);
			
			return newVector;
			
			function compare(x:BaGuaPieceVo,y:BaGuaPieceVo):Number{
				var result:Number;
				if(x.color > y.color){
					result = -1;
				}else if(x.color < y.color){
					result = 1;
				}else{
					if(x.exp > y.exp){
						result = -1;
					}else if(x.exp < y.exp){
						result = 1;
					}else{
						if(x.cid > y.cid){
							result = 1;
						}else if(x.cid < y.cid){
							result = -1;
						}else{
							result = 0;
						}
					}
				}
				
				return result;
			}
		}
		
		/**
		 * 
		 * 卜命
		 * 
		 */		
		protected function buMing(event:MouseEvent):void
		{
			var state:int = checkBuMingBtn();
			if(state==1 && effectEnd){
				if(BaGuaManager.getIns().checkMaxRooM()){
					var vo:BaGuaPieceVo;
					PlayerManager.getIns().reduceBaGuaScore(NumberConst.getIns().buMingPrice);
					vo = BaGuaManager.getIns().addRandomBaguaPiece(0);
					PlayerManager.getIns().addBaGuaFortune();
					var x:int = (vo.cid%6)*50;
					var y:int = int(vo.cid/6)*50;
					showEffect(x,y);
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"八卦牌背包已满！请整理");
				}
			}
		}
		
		/**
		 * 
		 * 显灵
		 * 
		 */	
		private function xianLing(event:MouseEvent):void{
			var state:int = checkBuMingBtn();
			if(state == 2 && effectEnd){
				if(BaGuaManager.getIns().checkMaxRooM()){
					var vo:BaGuaPieceVo;
					this.layer.mouseChildren = false;
					SaveManager.getIns().onSaveGame(
						function() : void{
							PlayerManager.getIns().reduceBaGuaScore(NumberConst.getIns().xianLingPrice);
							PlayerManager.getIns().clearBaGuaFortune();
							if(Math.random()*100>NumberConst.getIns().fivePercentage){
								vo = BaGuaManager.getIns().addRandomBaguaPiece(1);
							}else{
								vo = BaGuaManager.getIns().addRandomBaguaPiece(2);
							}
						},
						function () : void{
							var x:int = (vo.cid%6)*50;
							var y:int = int(vo.cid/6)*50;
							showEffect(x,y);
							layer.mouseChildren = true;
						});
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"八卦牌背包已满！请整理");
					
				}
			}
		}
		
		/**
		 * 
		 * 进入算卦界面
		 * 
		 */		
		protected function showSuanGua(event:MouseEvent):void
		{
			GuideManager.getIns().baGuaPanGuideSetting();
			if(BaGuaManager.getIns().checkFull()<0){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"八卦牌背包已满！请整理，否则无法获得八卦牌");	
			}
			(ViewFactory.getIns().initView(SuanGuaView) as SuanGuaView).show();
			this.hide();
		}
		
		override public function update():void{
			renderAttachBaGuaPieces();
			renderBaGuaPieces(true);
			setBaGuaPowerDigital();
			checkBuMingBtn();
			updateText();
		}
		
		
		public function refresh():void{
			renderAttachBaGuaPieces();
			renderBaGuaPieces();
			setBaGuaPowerDigital();
			checkBuMingBtn();
			updateText();
		}
		
		/**
		 *刷新背包 
		 * 
		 */		
		private function refreshBag():void{
			renderBaGuaPieces();
			checkBuMingBtn();
			updateText();
		}
		
		private function updateText():void
		{
			scoreTxt.text = player.baGuaScore.toString();
			fortuneTxt.text = player.baGuaFortune+"/"+NumberConst.getIns().fortuneMax;
			fortuneBar.width = orginFortuneBarWidth*(player.baGuaFortune/NumberConst.getIns().fortuneMax);
			if(ShopManager.getIns().vipLv >= NumberConst.getIns().two){
				couponBtn.visible = true;
			}else{
				couponBtn.visible = false;
			}
		}
		
		private function checkBuMingBtn():int
		{
			var buMingState:int; // -1卜命命数不足   1可以卜命  -2显灵命数不足   2可以显灵
			if(player.baGuaFortune>=NumberConst.getIns().fortuneMax){
				xianLingBtn.visible = true;
				buMingBtn.visible = false;
				if(player.baGuaScore>=NumberConst.getIns().xianLingPrice){
					buMingState = 2;
					GreyEffect.reset(xianLingBtn);
					TipsManager.getIns().addTips(
						xianLingBtn,{title:"花费"+NumberConst.getIns().xianLingPrice+"命数随机抽取一个蓝色八卦牌，有机会获得紫色八卦牌",tips:""});
				}else{
					buMingState = -2;
					GreyEffect.change(xianLingBtn);
					TipsManager.getIns().addTips(xianLingBtn,{title:"需要1000命数，当前命数不足",tips:""});
				}
			}else{
				xianLingBtn.visible = false;
				buMingBtn.visible = true;
				if(player.baGuaScore>=NumberConst.getIns().buMingPrice){
					buMingState = 1;
					GreyEffect.reset(buMingBtn);
					TipsManager.getIns().addTips(
						buMingBtn,{title:"花费"+NumberConst.getIns().buMingPrice+"命数随机抽取一个绿色八卦牌",tips:""});
				}else{
					buMingState = -1;
					GreyEffect.change(buMingBtn);
					TipsManager.getIns().addTips(buMingBtn,{title:"需要500命数，当前命数不足",tips:""});
				}
			}
			return buMingState;
		}
		
		/**
		 *显示已装备八卦牌
		 * 
		 */		
		private function renderAttachBaGuaPieces():void{
			clearAllAttached();
			_attachBaGuaArr = new Vector.<BaGuaAttached>;
			
			var attachBaGuaVos:Vector.<BaGuaPieceVo> = BaGuaManager.getIns().attachBaGuaPiece;
			
			for(var i:int = 0;i<attachBaGuaVos.length;i++){
				var BaGuaAttach:BaGuaAttached = new BaGuaAttached();
				var position:Object = getBaGuaPosition(attachBaGuaVos[i].index);
				BaGuaAttach.x = position.x;
				BaGuaAttach.y = position.y;
				BaGuaAttach.setData(attachBaGuaVos[i]);
				layer.addChild(BaGuaAttach);
				_attachBaGuaArr.push(BaGuaAttach);
			}
		}
		
		private function getBaGuaPosition(index:int):Object{
			var posX:int;
			var posY:int;
			switch(index){
				case 0:
					posX = 228;
					posY = 134;
					break;
				case 1:
					posX = 295;
					posY = 135;
					break;
				case 2:
					posX = 294;
					posY = 229;
					break;
				case 3:
					posX = 294;
					posY = 296;
					break;
				case 4:
					posX = 228;
					posY = 298;
					break;
				case 5:
					posX = 132;
					posY = 296;
					break;
				case 6:
					posX = 132;
					posY = 229;
					break;
				case 7:
					posX = 133;
					posY = 135;
					break;
					
			}
			return {
				x:posX,y:posY
			};
		}
		
		private function clearAllAttached():void{
			if(_attachBaGuaArr){
				for(var i:int = 0;i<_attachBaGuaArr.length;i++){
					if(_attachBaGuaArr[i].parent){
						_attachBaGuaArr[i].destroy();
						_attachBaGuaArr[i].parent.removeChild(_attachBaGuaArr[i]);
					}
				}
				_attachBaGuaArr = null;
			}
		}
		

		/**
		 *显示八卦牌背包 
		 * 
		 */		
		private function renderBaGuaPieces(sort:Boolean = false):void{
			
			if (!_baGuaGrid)
			{
				_baGuaGrid = new BaGuaAutoGrid(BaGuaPiece,5, 6, 50, 50, 1, 1);
				_baGuaGrid.x = 570;
				_baGuaGrid.y = 124;
				layer.addChild(_baGuaGrid);
			}
			if(sort){
				BaGuaManager.getIns().sortBaGuaByItemId();
			}
			_baGuaGrid.setData(BaGuaManager.getIns().sortByCId(BaGuaManager.getIns().unAttachBaGuaPiece));
			
		}
		
		
		private var _baGuaPowerDigital:Sprite;
		private var _attachEffect:BaseSequenceActionBind;
		
		private function setBaGuaPowerDigital():void{
			if(_baGuaPowerDigital != null && _baGuaPowerDigital.parent != null){
				layer.removeChild(_baGuaPowerDigital);
				_baGuaPowerDigital = null;
			}
			var baGuaProperty:BasePropertyVo = PlayerManager.getIns().BaGuaProperty;
			var baGuaPower:int = ((baGuaProperty.hp+baGuaProperty.mp+
				baGuaProperty.atk+baGuaProperty.def+baGuaProperty.ats+baGuaProperty.adf)+
				(baGuaProperty.hp_regain+baGuaProperty.mp_regain)*50)*
				(1+(baGuaProperty.hit+baGuaProperty.evasion+baGuaProperty.crit+
					baGuaProperty.toughness+baGuaProperty.hurt_deepen+baGuaProperty.hurt_reduce)/100);
				
			
			_baGuaPowerDigital = DigitalEffect.createDigital("AtkHp",baGuaPower);
			_baGuaPowerDigital.x = 390;
			_baGuaPowerDigital.y = 490;
			_baGuaPowerDigital.scaleX = .6;
			_baGuaPowerDigital.scaleY = .6;
			if(_baGuaPowerDigital.parent == null){
				layer.addChild(_baGuaPowerDigital);
			}
		}	

		
		private function onAttachedStopDrag(e:CommonEvent):void
		{
			
			if(e.data[0].x>560){
				if(BaGuaManager.getIns().checkMaxRooM()){
					BaGuaManager.getIns().downAttach(e.data[1]);
					refresh();
					return;
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"八卦牌背包空间不足！\n请留出空间后再卸下");
				}
			}
			e.data[0].setOriginalPosition();
		}
		
		
		private function onUnlock(e:CommonEvent):void
		{
			PlayerManager.getIns().player.baGuaRoomMax+=NumberConst.getIns().one;
			PackManager.getIns().reduceItem(NumberConst.getIns().wanNengKeyId,NumberConst.getIns().one);
			(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
				"开启一格背包！");
			update();
		}

		
		

		private function onBaguaStopDrag(e:CommonEvent):void{
			if(effectEnd){
				for(var i:int = 0;i<_baGuaGrid.itemArr.length;i++){
					if(_baGuaGrid.itemArr[i].hitTestObject(e.data[0]) && 
						_baGuaGrid.itemArr[i]!=e.data[0] &&
						!_baGuaGrid.itemArr[i].locked ){						
						var giver:BaGuaPieceVo;
						var receiver:BaGuaPieceVo;
						var effectX:int;
						var effectY:int;
						if(_baGuaGrid.itemArr[i].data.isLingqi){
							(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
								"灵气牌不能升级~");
							e.data[0].setOriginalPosition();
							return;
						}else{
							if(e.data[1].isLingqi){
								giver =	e.data[1];
								receiver = _baGuaGrid.itemArr[i].data;
								effectX = _baGuaGrid.itemArr[i].x;
								effectY = _baGuaGrid.itemArr[i].y;
							}else{
								if(e.data[1].color > _baGuaGrid.itemArr[i].data.color){
									giver = _baGuaGrid.itemArr[i].data;
									receiver =	e.data[1];
									effectX = e.data[0].x;
									effectY = e.data[0].y;
								}else {
									giver =	e.data[1];
									receiver = _baGuaGrid.itemArr[i].data;
									effectX = _baGuaGrid.itemArr[i].x;
									effectY = _baGuaGrid.itemArr[i].y;
								}
							}

							
							if(receiver.lv >= NumberConst.getIns().baguaMaxLv){
								(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
									receiver.name+"已达到最高级别~",null);
								e.data[0].setOriginalPosition();
							}else{
								(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice(
									receiver.name+"将会吞噬"+giver.name+"获得"+int(giver.exp+giver.baseExp)+"灵气!",
									function ():void{
										showEffect(effectX,effectY);
										BaGuaManager.getIns().combineBaGua(giver,receiver);
									},
									function ():void{
										e.data[0].setOriginalPosition();
									});
							}
							return;
						}
					}
				}
				
				if(baGuaBg.hitTestObject(e.data[0]) && e.data[1].isLingqi==false){
					BaGuaManager.getIns().upBaGua(e.data[1]);
					refresh();
					return;
				}
			}
			e.data[0].setOriginalPosition();

			
		}
		
		
		private function showEffect(x:int,y:int):void{
			effectEnd = false;
			_attachEffect = AnimationEffect.createAnimation(10015,["attachEffect"],false,removeEffect)
			_attachEffect.x = x + 535;
			_attachEffect.y = y + 89;
			this.addChild(_attachEffect);
			RenderEntityManager.getIns().removeEntity(_attachEffect);
			AnimationManager.getIns().addEntity(_attachEffect);
		}
		
		private function removeEffect(...args):void{
			if(_attachEffect != null){
				AnimationManager.getIns().removeEntity(_attachEffect);
				_attachEffect.destroy();
				_attachEffect = null;
			}
			refreshBag();
			effectEnd = true;
		}
		

		override public function show():void{
			if(layer == null) return;
			update();
			super.show();
		}
		
		private function close(e:MouseEvent):void{
			GuideManager.getIns().baGuaPanGuideSetting();
			PlayerManager.getIns().updatePropertys();
			hide();
		}
		
		
		private function get player():PlayerVo
		{
			return PlayerManager.getIns().player;
		}
		
		
		private function get baGuaBg():MovieClip
		{
			return layer["baGuaBg"];
		}
		
		private function get suanGuaBtn():MovieClip
		{
			return layer["suanGuaBtn"];
		}
		
		private function get buMingBtn():SimpleButton
		{
			return layer["buMingBtn"];
		}
		
		private function get xianLingBtn():MovieClip
		{
			return layer["xianLingBtn"];
		}
		
		private function get fortuneBar():Sprite
		{
			return layer["fortuneBar"];
		}
		
		
		private function get scoreTxt():TextField
		{
			return layer["scoreTxt"];
		}
		
		private function get fortuneTxt():TextField
		{
			return layer["fortuneTxt"];
		}
		
		private function get oneKeyCombineBtn():SimpleButton
		{
			return layer["oneKeyCombineBtn"];
		}
		
		private function get mingShuMc():Sprite
		{
			return layer["mingShuMc"];
		}
		
		private function get couponBtn():SimpleButton
		{
			return layer["couponBtn"];
		}
		
		private function get lingQiBtn():SimpleButton
		{
			return layer["lingQiBtn"];
		}
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		
		override public function destroy():void{
			if(closeBtn.hasEventListener(MouseEvent.CLICK)){
				closeBtn.removeEventListener(MouseEvent.CLICK,close);;
			}
			super.destroy();
		}
	}
}