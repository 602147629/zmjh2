package com.test.game.Modules.MainGame.Setting
{
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.GameSettingManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.MouseEvent;
	
	public class GameSettingView extends BaseView
	{
		private var _loadType:Boolean;
		private var _deformType:Boolean;
		private var _qualityType:int;
		private var _operatingType:int;
		private var _publicNoticeType:int;
		private var _effectType:int;
		public function GameSettingView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.GAMESETTINGVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.GAMESETTINGVIEW.split("/")[1]) as Sprite;
				layer.x = 5;
				layer.y = 480;
				this.addChild(layer);
				
				initParams();
				initUI();
				setParams();
				setCenter();
			}
		}
		
		private function initParams():void{
			
		}
		
		private function initUI():void{
			initBg();
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			confirmBtn.addEventListener(MouseEvent.CLICK, onConfirm);
			loadingSet_1.buttonMode = true;
			loadingSet_2.buttonMode = true;
			deformSet_1.buttonMode = true;
			deformSet_2.buttonMode = true;
			qualitySet_1.buttonMode = true;
			qualitySet_2.buttonMode = true;
			qualitySet_3.buttonMode = true;
			operating_1.buttonMode = true;
			operating_2.buttonMode = true;
			publicNotice_1.buttonMode = true;
			publicNotice_2.buttonMode = true;
			effect_1.buttonMode = true;
			effect_2.buttonMode = true;
			loadingSet_1.addEventListener(MouseEvent.CLICK, onLoadingSetting);
			loadingSet_2.addEventListener(MouseEvent.CLICK, onLoadingSetting);
			deformSet_1.addEventListener(MouseEvent.CLICK, onDeformSetting);
			deformSet_2.addEventListener(MouseEvent.CLICK, onDeformSetting);
			qualitySet_1.addEventListener(MouseEvent.CLICK, onQualitySetting);
			qualitySet_2.addEventListener(MouseEvent.CLICK, onQualitySetting);
			qualitySet_3.addEventListener(MouseEvent.CLICK, onQualitySetting);
			operating_1.addEventListener(MouseEvent.CLICK, onOperatingSetting);
			operating_2.addEventListener(MouseEvent.CLICK, onOperatingSetting);
			publicNotice_1.addEventListener(MouseEvent.CLICK, onPublicNoticeSetting);
			publicNotice_2.addEventListener(MouseEvent.CLICK, onPublicNoticeSetting);
			effect_1.addEventListener(MouseEvent.CLICK, onEffectSetting);
			effect_2.addEventListener(MouseEvent.CLICK, onEffectSetting);
			TipsManager.getIns().addTips(operating_1, {title:"简单操作：", tips:"ASWD控制跑动，J按住连招，K跳跃，M前冲，跳跃时按M压制攻击，Q施法BOSS援护。"});
			TipsManager.getIns().addTips(operating_2, {title:"常规操作：", tips:"ASWD控制走动，连续按角色跑动，J连续按连招，K跳跃，跑动中按J释放前冲，跳跃时按S+J压制攻击，Q施法BOSS援护。"});
		}
		
		protected function onEffectSetting(e:MouseEvent) : void{
			var index:int = e.target.name.split("_")[1];
			_effectType = index;
			effectUpdate();
		}
		
		protected function onPublicNoticeSetting(e:MouseEvent) : void{
			var index:int = e.target.name.split("_")[1];
			_publicNoticeType = index;
			publicNoticeUpdate();
		}
		
		protected function onOperatingSetting(event:MouseEvent):void{
			var index:int = event.target.name.split("_")[1];
			_operatingType = index;
			operatingUpdate();
		}
		
		protected function onQualitySetting(event:MouseEvent):void{
			var index:int = event.target.name.split("_")[1];
			_qualityType = index;
			qualityUpdate();
		}
		
		private function qualityUpdate():void{
			switch(_qualityType){
				case 1:
					qualitySet_1.gotoAndStop(2);
					qualitySet_2.gotoAndStop(1);
					qualitySet_3.gotoAndStop(1);
					GameConst.stage.quality = StageQuality.LOW;
					break;
				case 2:
					qualitySet_1.gotoAndStop(1);
					qualitySet_2.gotoAndStop(2);
					qualitySet_3.gotoAndStop(1);
					GameConst.stage.quality = StageQuality.MEDIUM;
					break;
				case 3:
					qualitySet_1.gotoAndStop(1);
					qualitySet_2.gotoAndStop(1);
					qualitySet_3.gotoAndStop(2);
					GameConst.stage.quality = StageQuality.HIGH;
					break;
			}
		}
		
		protected function onDeformSetting(event:MouseEvent):void{
			var index:int = event.target.name.split("_")[1];
			if(index == 1){
				_deformType = true;
			}else{
				_deformType = false;
			}
			deformUpdate();
		}
		
		protected function onLoadingSetting(event:MouseEvent):void{
			var index:int = event.target.name.split("_")[1];
			if(index == 1){
				_loadType = true;
			}else{
				_loadType = false;
			}
			loadUpdate();
		}
		
		protected function onConfirm(event:MouseEvent):void{
			GameConst.isPreLoading = _loadType;
			DeformTipManager.getIns().deformTipControll = _deformType;
			GameSettingManager.getIns().stageQuality = _qualityType;
			GameSettingManager.getIns().operateMode = _operatingType;
			GameSettingManager.getIns().publicNotice = _publicNoticeType;
			GameSettingManager.getIns().openEffect = _effectType;			
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).renderPartner();
			this.hide();
		}
		
		private function onClose(e:MouseEvent) : void{
			this.hide();
		}
		
		override public function setParams() : void{
			if(layer == null) return;
			_loadType = GameConst.isPreLoading;
			_deformType = DeformTipManager.getIns().deformTipControll;
			_qualityType = GameSettingManager.getIns().stageQuality;
			_operatingType = GameSettingManager.getIns().operateMode;
			_publicNoticeType = GameSettingManager.getIns().publicNotice;
			_effectType = GameSettingManager.getIns().openEffect;
			update();
		}
		
		override public function update():void{
			loadUpdate();
			deformUpdate();
			qualityUpdate();
			operatingUpdate();
			publicNoticeUpdate();
			effectUpdate();
		}
		
		private function effectUpdate() : void{
			switch(_effectType){
				case 1:
					effect_1.gotoAndStop(2);
					effect_2.gotoAndStop(1);
					break;
				case 2:
					effect_1.gotoAndStop(1);
					effect_2.gotoAndStop(2);
					break;
			}
		}
		
		private function publicNoticeUpdate() : void{
			switch(_publicNoticeType){
				case 1:
					publicNotice_1.gotoAndStop(2);
					publicNotice_2.gotoAndStop(1);
					break;
				case 2:
					publicNotice_1.gotoAndStop(1);
					publicNotice_2.gotoAndStop(2);
					break;
			}
		}
		
		private function operatingUpdate():void{
			switch(_operatingType){
				case 1:
					operating_1.gotoAndStop(2);
					operating_2.gotoAndStop(1);
					break;
				case 2:
					operating_1.gotoAndStop(1);
					operating_2.gotoAndStop(2);
					break;
			}
		}
		
		private function deformUpdate():void{
			if(_deformType){
				deformSet_1.gotoAndStop(2);
				deformSet_2.gotoAndStop(1);
			}else{
				deformSet_1.gotoAndStop(1);
				deformSet_2.gotoAndStop(2);
			}
		}
		
		private function loadUpdate():void{
			if(_loadType){
				loadingSet_1.gotoAndStop(2);
				loadingSet_2.gotoAndStop(1);
			}else{
				loadingSet_1.gotoAndStop(1);
				loadingSet_2.gotoAndStop(2);
			}
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		public function get closeBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
		public function get confirmBtn() : SimpleButton{
			return layer["ConfirmBtn"];
		}
		public function get loadingSet_1() : MovieClip{
			return layer["LoadingSet_1"];
		}
		public function get loadingSet_2() : MovieClip{
			return layer["LoadingSet_2"];
		}
		public function get deformSet_1() : MovieClip{
			return layer["DeformSet_1"];
		}
		public function get deformSet_2() : MovieClip{
			return layer["DeformSet_2"];
		}
		public function get qualitySet_1() : MovieClip{
			return layer["QualitySet_1"];
		}
		public function get qualitySet_2() : MovieClip{
			return layer["QualitySet_2"];
		}
		public function get qualitySet_3() : MovieClip{
			return layer["QualitySet_3"];
		}
		public function get operating_1() : MovieClip{
			return layer["Operating_1"];
		}
		public function get operating_2() : MovieClip{
			return layer["Operating_2"];
		}
		public function get publicNotice_1() : MovieClip{
			return layer["PublicNotice_1"];
		}
		public function get publicNotice_2() : MovieClip{
			return layer["PublicNotice_2"]
		}
		public function get effect_1() : MovieClip{
			return layer["Effect_1"];
		}
		public function get effect_2() : MovieClip{
			return layer["Effect_2"];
		}
	}
}