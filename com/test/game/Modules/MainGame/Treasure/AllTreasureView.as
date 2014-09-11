package com.test.game.Modules.MainGame.Treasure
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Modules.MainGame.BaGua.BaGuaView;
	import com.test.game.Modules.MainGame.HeroScript.HeroScriptView;
	import com.test.game.Modules.MainGame.SkillUp.SkillUpView;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class AllTreasureView extends BaseView
	{
		private var _showBtn:Array = new Array();
		public function AllTreasureView(){
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.MAINUI)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("AllTreasureView") as Sprite;
				layer.x = 350;
				layer.y = 80;
				this.addChild(layer);
				
				initUI();
				setParams();
				update();
			}
		}
		
		private function initUI():void{
			initBg();
			treasureBtn_1.addEventListener(MouseEvent.CLICK, onShowSkillUp);
			treasureBtn_2.addEventListener(MouseEvent.CLICK, onShowBgGuaPan);
			treasureBtn_3.addEventListener(MouseEvent.CLICK, onShowHero);
			this.bg.addEventListener(MouseEvent.CLICK, onClose);
		}
		
		protected function onClose(event:MouseEvent):void{
			this.hide();
		}
		
		private function onShowSkillUp(e:MouseEvent) : void{
			(ViewFactory.getIns().initView(SkillUpView) as SkillUpView).show();
			this.hide();
		}
		
		private function onShowBgGuaPan(e:MouseEvent) : void{
			(ViewFactory.getIns().initView(BaGuaView) as BaGuaView).show();
			this.hide();
		}
		
		protected function onShowHero(e:MouseEvent) : void{
			(ViewFactory.getIns().initView(HeroScriptView) as HeroScriptView).show();
			this.hide();
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			update();
		}
		
		override public function update():void{
			_showBtn = [];
			
			for(var i:int = 0; i < 3; i++){
				var missionID:int = 3000 + i * 10 + 2;
				if(HideMissionManager.getIns().returnHideMissionComplete(missionID)){
					_showBtn.push(i + 1);
				}
				this["treasure_" + (i + 1)].visible = false;
			}
			
			for(var j:int = 0; j < _showBtn.length; j++){
				this["treasure_" + _showBtn[j]].visible = true;
				this["treasure_" + _showBtn[j]].y = 17 + 60 * j;
			}
			treasureBg.height = ((_showBtn.length - 1) * 60) + 90;
		}
		
		public function get treasure_1() : Sprite{
			return layer["Treasure_1"];
		}
		public function get treasure_2() : Sprite{
			return layer["Treasure_2"];
		}
		public function get treasure_3() : Sprite{
			return layer["Treasure_3"];
		}
		
		public function get treasureBtn_1() : SimpleButton{
			return layer["Treasure_1"]["TreasureBtn_1"];
		}
		public function get treasureBtn_2() : SimpleButton{
			return layer["Treasure_2"]["TreasureBtn_2"];
		}
		public function get treasureBtn_3() : SimpleButton{
			return layer["Treasure_3"]["TreasureBtn_3"];
		}
		
		private function get treasureBg() : Sprite{
			return layer["TreasureBg"];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy() : void{
			super.destroy();
		}
	}
}