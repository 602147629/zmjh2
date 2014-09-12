package com.test.game.Modules.MainGame.boss
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.GuideConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.NameHelper;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.AttachManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ChangePage;
	import com.test.game.UI.Grid.AutoGrid;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class AttachTabView extends Sprite
	{
		private var _obj:Sprite;
		
		public var layerName:String;
		
		private var _bossGrid:AutoGrid
		
		private var _bossChangePage:ChangePage;
		
		private var _head:BaseNativeEntity;
		
		private var _attachIconArr:Vector.<AttachedDragIcon>;
		
		private var _frontIcon:AttachedDragIcon;
		
		private var _middleIcon:AttachedDragIcon;
		
		private var _backIcon:AttachedDragIcon;
		
		private var _attachEffect:BaseSequenceActionBind;
		
		
		public function AttachTabView()
		{
			_obj = AssetsManager.getIns().getAssetObject("attachTabView") as Sprite;
			this.addChild(_obj);
			
			
			renderView();
			update();
			initEvent();
		}
		
		private function renderView():void
		{
			_head = new BaseNativeEntity();
			_head.data.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "_LittleHead") as BitmapData;
			_head.x = 205;
			_head.y = 82;
			this.addChild(_head);
			
			_frontIcon = new AttachedDragIcon();
			_frontIcon.enable = true;
			this.addChild(_frontIcon);
			
			_middleIcon = new AttachedDragIcon();
			this.addChild(_middleIcon);
			
			_backIcon = new AttachedDragIcon();
			this.addChild(_backIcon);
			
			_attachIconArr = new Vector.<AttachedDragIcon>;
			_attachIconArr.push(_frontIcon,_middleIcon,_backIcon);
			
		}
		
		
		public function update():void{
			renderBosses();
			setAttachData();
			updateHead();
		}
		
		private function updateHead():void{
			_head.data.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "_LittleHead") as BitmapData;
		}
		
		
		/**
		 *显示boss卡牌背包 
		 * 
		 */		
		private function renderBosses():void{
			if(!_bossChangePage){
				_bossChangePage = new ChangePage();
				_bossChangePage.x = 632;
				_bossChangePage.y = 350;
				this.addChild(_bossChangePage);	
			}
			
			if (!_bossGrid)
			{
				_bossGrid = new AutoGrid(AttachDragIcon,6, 6, 50, 50, 1, 1);
				_bossGrid.x = 515;
				_bossGrid.y = 36;
				this.addChild(_bossGrid);
			}
			_bossGrid.setData(PackManager.getIns().sortByCId(player.pack.bossUnEquip)
				,_bossChangePage);
			
		}
		
		
		private function setAttachData():void{
			var attachs:Vector.<ItemVo> = AttachManager.getIns().AttachVos;
			
			_frontIcon.x = 126;
			_frontIcon.y = 50;
			_frontIcon.index = 0;
			_frontIcon.setData(null);
			
			_middleIcon.x = 332;
			_middleIcon.y =50;
			_middleIcon.index = 1;
			_middleIcon.setData(null);
			
			_backIcon.x = 226;
			_backIcon.y = 220;
			_backIcon.index = 2;
			_backIcon.setData(null);
			
			var attachNum:int = NumberConst.getIns().one;
			if(player.character.lv>=25){
				attachNum = NumberConst.getIns().two;
				BtnEnable(_middleIcon,true);
			}else{
				attachNum = NumberConst.getIns().one;
				BtnEnable(_middleIcon,false);
			}
			
			if(player.character.lv>=40){
				attachNum = attachNum = NumberConst.getIns().three;
				BtnEnable(_backIcon,true);
			}else{
				attachNum = NumberConst.getIns().two;
				BtnEnable(_backIcon,false);
			}
			
			
			for (var i:int = 0 ; i<attachNum;i++){
				_attachIconArr[i].setData(attachs[i]);
				_attachIconArr[i].setOriginalPosition();
			}

			
			if(attachs[0]){
				frontAdd.text = "";
				for(var f:int =0;f<attachs[0].bossConfig.add_type.length;f++){
					frontAdd.text += NameHelper.getPropertyName(attachs[0].bossConfig.add_type[f])
						+"+"+int(int(attachs[0].bossConfig.add_value[f])*attachs[0].bossUp.add_rate) + "  " ;
				}
	
			}else{
				frontAdd.text = "";
			}
			
			if(attachs[1]){
				middleAdd.text = "";
				for(var m:int =0;m<attachs[1].bossConfig.add_type.length;m++){
					middleAdd.text += NameHelper.getPropertyName(attachs[1].bossConfig.add_type[m])
						+"+"+int(int(attachs[1].bossConfig.add_value[m])*attachs[1].bossUp.add_rate) + "  " ;
				}
			}else{
				middleAdd.text = "";
			}
			
			if(attachs[2]){
				backAdd.text = "";
				for(var b:int =0;b<attachs[2].bossConfig.add_type.length;b++){
					backAdd.text += NameHelper.getPropertyName(attachs[2].bossConfig.add_type[b])
						+"+"+int(int(attachs[2].bossConfig.add_value[b])*attachs[2].bossUp.add_rate) + "  " ;
				}
			}else{
				backAdd.text = "";
			}

		}
		
		
		
		private function initEvent():void{
			EventManager.getIns().addEventListener(EventConst.ATTACH_BOSS_STOP_DRAG,onPackBossStopDrag);
			EventManager.getIns().addEventListener(EventConst.ATTACHED_BOSS_STOP_DRAG,onAttachedStopDrag);
		}
		
		private function onAttachedStopDrag(e:CommonEvent):void
		{
	
/*			for (var i:int = 0 ; i<3;i++){
				if(_attachIconArr[i].hitTestObject(e.data[0].bossImage) && _attachIconArr[i]!=e.data[0] && _attachIconArr[i].enable==true){
					AttachManager.getIns().exchangeAttach(e.data[0],_attachIconArr[i]);
					update();
					return;
				}
			}*/
			
			if(e.data[0].bossImage.x + e.data[0].x > 500){
				if(PackManager.getIns().checkMaxRooM([e.data[1]])){
					AttachManager.getIns().downAttach(e.data[1]);
					update();
					return;
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"背包空间不足！\n请留出空间后再卸下");
				}

			}
			
			e.data[0].setOriginalPosition();
		}
		
		private function checkSameAttach(id:int,index:int):Boolean{
			var result:Boolean = true;
			for(var i:int=0;i<3;i++){
				if(player.attachInfo.attachArr[i] == id && index != i){
					result = false;
				}
			}
			return result;
		}
		
		private function onPackBossStopDrag(e:CommonEvent):void{
			for (var i:int = 0 ; i<3;i++){
				if(_attachIconArr[i].hitTestObject(e.data[0]) && _attachIconArr[i].enable==true){
					if(checkSameAttach(e.data[1].id,i)){
						AttachManager.getIns().upAttach(e.data[1],_attachIconArr[i].index);
						update();
						updateAttach();
						GuideManager.getIns().bossGuideSetting(GuideConst.BOSSATTACH);
						_attachEffect = AnimationEffect.createAnimation(10015,["attachEffect"],false,updateAttach)
						switch(i){
							case 0:
								_attachEffect.x = 88;
								_attachEffect.y = 14;
								break;
							case 1:
								_attachEffect.x = 294;
								_attachEffect.y = 14;
								break;
							case 2:
								_attachEffect.x = 188;
								_attachEffect.y = 184;
								break;
						}
						this.addChild(_attachEffect);
						RenderEntityManager.getIns().removeEntity(_attachEffect);
						AnimationManager.getIns().addEntity(_attachEffect);
						return;
					}else{
						(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
							"同种卡牌不能附体两张以上！");
						break;
					}

				}
			}
			
			e.data[0].setOriginalPosition();
		}
		
		private function updateAttach(...args):void{
			if(_attachEffect != null){
				AnimationManager.getIns().removeEntity(_attachEffect);
				_attachEffect.destroy();
				_attachEffect = null;		
			}
		}
		
		
		private function BtnEnable(object:AttachedDragIcon,enable:Boolean):void{
			if(enable){
				GreyEffect.reset(object);
				object.enable = true;
			}else{
				GreyEffect.change(object);
				object.enable = false;
			}
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		
		private function get frontBg():Sprite
		{
			return _obj["frontBg"];
		}
		
		private function get middleBg():Sprite
		{
			return _obj["middleBg"];
		}
		
		private function get backBg():Sprite
		{
			return _obj["backBg"];
		}
		
		private function get frontAdd():TextField
		{
			return _obj["frontAdd"];
		}
		
		private function get middleAdd():TextField
		{
			return _obj["middleAdd"];
		}
		
		private function get backAdd():TextField
		{
			return _obj["backAdd"];
		}
		
		
		public function destroy() : void{
			if(_bossGrid != null){
				_bossGrid.destroy();
				_bossGrid = null;
			}
			if(_bossChangePage != null){
				_bossChangePage.destroy();
				_bossChangePage = null;
			}
			if(_head != null){
				_head.destroy();
				_head = null;
			}
			for (var i:int = 0 ; i<_attachIconArr.length;i++){
				_attachIconArr[i].destroy();
				_attachIconArr[i] = null;
			}
			_attachIconArr.length = 0;
			_attachIconArr = null;
			_obj = null;
		}
			
	}
}