package com.test.game.Modules.MainGame.Setting
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Mvc.control.View.GameSceneControl;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SoundSettingView extends BaseView
	{
		public function SoundSettingView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.SOUNDSETTINGVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.SOUNDSETTINGVIEW.split("/")[1]) as Sprite;
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
		
		private var _bgDrag:DragSetting;
		private var _fightDrag:DragSetting;
		private var _bgVolume:UpAndDownSetting;
		private var _fightVolume:UpAndDownSetting;
		private function initUI():void{
			initBg();
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			_bgDrag = new DragSetting(bgSoundArea, bgSoundDrag, onBgSetting);
			_fightDrag = new DragSetting(fightSoundArea, fightSoundDrag, onFightSetting);
			_bgVolume = new UpAndDownSetting(bgSoundUp, bgSoundDown, bgSoundAdd, bgSoundReduce);
			_fightVolume = new UpAndDownSetting(fightSoundUp, fightSoundDown, fightSoundAdd, fightSoundReduce);
		}
		
		private function bgSoundReduce() : void{
			SoundManager.getIns().bgSoundVolume -= .05;
			bgSoundUpdate(SoundManager.getIns().bgSoundVolume);
		}
		private function bgSoundAdd() : void{
			SoundManager.getIns().bgSoundVolume += .05;
			bgSoundUpdate(SoundManager.getIns().bgSoundVolume);
		}
		private function fightSoundReduce() : void{
			SoundManager.getIns().fightSoundVolume -= .05;
			fightSoundUpdate(SoundManager.getIns().fightSoundVolume);
		}
		private function fightSoundAdd() : void{
			SoundManager.getIns().fightSoundVolume += .05;
			fightSoundUpdate(SoundManager.getIns().fightSoundVolume);
		}
		
		private function onFightSetting():void{
			fightSoundBar.width = fightSoundArea.mouseX;
			fightSoundDrag.x = fightSoundArea.mouseX + 160;
			fightSoundTF.text = Math.ceil(fightSoundArea.mouseX / 170 * 100) + "%";
			SoundManager.getIns().fightSoundVolume = fightSoundArea.mouseX / 170;
		}
		
		private function onBgSetting() : void{
			bgSoundBar.width = bgSoundArea.mouseX;
			bgSoundDrag.x = bgSoundArea.mouseX + 160;;
			bgSoundTF.text = Math.ceil(bgSoundArea.mouseX / 170 * 100) + "%";
			SoundManager.getIns().bgSoundVolume = bgSoundArea.mouseX / 170;
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			update();
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
		}
		
		override public function update():void{
			bgSoundUpdate(SoundManager.getIns().bgSoundVolume);
			fightSoundUpdate(SoundManager.getIns().fightSoundVolume);
		}
		
		private function fightSoundUpdate(volume:Number):void{
			volume = volume < 0?0:volume;
			volume = volume > 1?1:volume;
			fightSoundBar.width = volume * 170 ;
			fightSoundDrag.x = volume * 170 + 160;
			fightSoundTF.text = Math.ceil(volume * 100) + "%";
		}
		
		private function bgSoundUpdate(volume:Number):void{
			volume = volume < 0?0:volume;
			volume = volume > 1?1:volume;
			bgSoundBar.width = volume * 170 ;
			bgSoundDrag.x = volume * 170 + 160;
			bgSoundTF.text = Math.ceil(volume * 100) + "%";
		}
		
		protected function onClose(event:MouseEvent):void{
			(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameStartRender();
			this.hide();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameTipLayer;	
		}
		
		public function get closeBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
		public function get bgSoundBar() : Sprite{
			return layer["BgSoundBar"];
		}
		public function get fightSoundBar() : Sprite{
			return layer["FightSoundBar"];
		}
		public function get bgSoundDrag() : Sprite{
			return layer["BgSoundDrag"];
		}
		public function get fightSoundDrag() : Sprite{
			return layer["FightSoundDrag"];
		}
		public function get bgSoundArea() : Sprite{
			return layer["BgSoundArea"];
		}
		public function get fightSoundArea() : Sprite{
			return layer["FightSoundArea"];
		}
		public function get bgSoundTF() : TextField{
			return layer["BgSoundTF"];
		}
		public function get fightSoundTF() : TextField{
			return layer["FightSoundTF"];
		}
		public function get bgSoundDown() : SimpleButton{
			return layer["BgSoundDown"];
		}
		public function get bgSoundUp() : SimpleButton{
			return layer["BgSoundUp"];
		}
		public function get fightSoundDown() : SimpleButton{
			return layer["FightSoundDown"];
		}
		public function get fightSoundUp() : SimpleButton{
			return layer["FightSoundUp"];
		}
		
	}
}