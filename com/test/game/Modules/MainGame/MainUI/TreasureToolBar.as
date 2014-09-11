package com.test.game.Modules.MainGame.MainUI
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Modules.MainGame.BagView;
	import com.test.game.Modules.MainGame.Role.RoleDetailView;
	import com.test.game.Modules.MainGame.Treasure.AllTreasureView;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class TreasureToolBar extends BaseView
	{
		public function TreasureToolBar()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.MAINUI)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("TreasureToolBar") as Sprite;
				layer.x = 300;
				layer.y = 20;
				this.addChild(layer);
				
				initUI();
				initParams();
				setParams();
				update();
			}
		}
		
		private function initUI():void{
			(layer["TreasureBtn"] as MovieClip).addEventListener(MouseEvent.CLICK, onShowAllTreasure);
		}
		
		private function onShowAllTreasure(e:MouseEvent) : void{
			if(HideMissionManager.getIns().returnHideMissionComplete(3002)
				||HideMissionManager.getIns().returnHideMissionComplete(3012)){
				ViewFactory.getIns().initView(AllTreasureView).show();
				if(ViewFactory.getIns().getView(BagView) != null){
					ViewFactory.getIns().getView(BagView).hide();
				}
				if(ViewFactory.getIns().getView(RoleDetailView) != null){
					ViewFactory.getIns().getView(RoleDetailView).hide();
				}
			}
		}
		
		private function initParams():void{
			var str:String = "江湖至宝，武林神器！\n你的使命就是收集十大至宝，进入混沌魔境，打败无相天尊，挽救江湖于危难之中！\n翠竹杖重现墨竹林！\n八卦盘聚灵太虚观！\n英雄谱汇集万恶谷！";
			TipsManager.getIns().addTips((layer["TreasureBtn"] as MovieClip), {title:"至宝", tips:str});
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			update();
		}
		
		override public function update():void{
			if(HideMissionManager.getIns().returnHideMissionComplete(3002)
				||HideMissionManager.getIns().returnHideMissionComplete(3012)
				||HideMissionManager.getIns().returnHideMissionComplete(3022)){
				GreyEffect.reset(layer["TreasureBtn"] as MovieClip);
				(layer["TreasureBtn"] as MovieClip).buttonMode = true;
			}else{
				GreyEffect.change(layer["TreasureBtn"] as MovieClip);
				(layer["TreasureBtn"] as MovieClip).buttonMode = false;
			}
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy() : void{
			super.destroy();
		}
	}
}