package com.test.game.Modules.MainGame.HeroFight
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.ExpBar;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.FunnyBossManager;
	import com.test.game.Manager.HeroFightManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.control.key.GotoFunnyBattleControl;
	import com.test.game.Mvc.control.key.GotoHeroBattleControl;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class HeroFightResultView extends BaseView
	{
		private var _itemIcons:Vector.<ItemIcon> = new Vector.<ItemIcon>();
		private var _expBar:ExpBar = new ExpBar();
		public function HeroFightResultView()
		{
			super();
			start();
		}
		
		private function start() : void{
			layer = AssetsManager.getIns().getAssetObject("HeroFightResultView") as Sprite;
			this.addChild(layer);
			
			initUI();
			initBg();
			setCenter();
		}
		
		private function initUI() : void{
			quitHeroFight.addEventListener(MouseEvent.CLICK, onQuitHeroFight);
			
			for(var i:int = 0; i < 6; i++){
				var itemIcon:ItemIcon = new ItemIcon();
				itemIcon.x = i * 51 + 95;
				itemIcon.y = 251;
				itemIcon.selectable = false;
				itemIcon.menuable = false;
				layer.addChild(itemIcon);
				_itemIcons.push(itemIcon);
			}
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			for(var i:int = 0; i < 6; i++){
				_itemIcons[i].setData(null);
			}
			_expBar = new ExpBar();
			var result:Array = new Array();
			if(SceneManager.getIns().sceneType == SceneManager.HERO_SCENE){
				result = HeroFightManager.getIns().resultArr;
				expTF.text = HeroFightManager.getIns().exp.toString();
				soulTF.text = HeroFightManager.getIns().soul.toString();
				moneyTF.text = HeroFightManager.getIns().money.toString();
				_expBar.createExpBar(expShow, HeroFightManager.getIns().exp);
			}else if(SceneManager.getIns().sceneType == SceneManager.FUNNY_SCENE){
				result = FunnyBossManager.getIns().resultArr;
				expTF.text = FunnyBossManager.getIns().exp.toString();
				soulTF.text = FunnyBossManager.getIns().soul.toString();
				moneyTF.text = FunnyBossManager.getIns().money.toString();
				_expBar.createExpBar(expShow, FunnyBossManager.getIns().exp);
			}
			
			_expBar.start();
			for(var j:int = 0; j < result.length; j++){
				var itemVo:ItemVo = PackManager.getIns().creatBossData(ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SPECIAL, "id", int(result[j])).bid
					,int((int(result[j]) - 10000) / 100) + 1);
				_itemIcons[j].setData(itemVo);
			}
			if(result.length > 0 && SceneManager.getIns().sceneType == SceneManager.FUNNY_SCENE){
				var moonCakeVo:ItemVo = PackManager.getIns().creatItem(NumberConst.getIns().moonCakeId);
				_itemIcons[result.length].setData(moonCakeVo);
			}
		}
		
		protected function onQuitHeroFight(e:MouseEvent) : void{
			this.hide();
			if(SceneManager.getIns().sceneType == SceneManager.HERO_SCENE){
				(ControlFactory.getIns().getControl(GotoHeroBattleControl) as GotoHeroBattleControl).leaveBattle();
			}else if(SceneManager.getIns().sceneType == SceneManager.FUNNY_SCENE){
				(ControlFactory.getIns().getControl(GotoFunnyBattleControl) as GotoFunnyBattleControl).leaveBattle();
			}
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function get quitHeroFight() : SimpleButton{
			return layer["QuitHeroFight"];
		}
		private function get expTF() : TextField{
			return layer["ExpTF"];
		}
		private function get moneyTF() : TextField{
			return layer["MoneyTF"];
		}
		private function get soulTF() : TextField{
			return layer["SoulTF"];
		}
		private function get expShow() : Sprite{
			return layer["ExpShow"];
		}
	}
}