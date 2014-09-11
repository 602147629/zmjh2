package com.test.game.Modules.MainGame.SkillUp
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.TabBar;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SkillUpView extends BaseView
	{
		public function SkillUpView()
		{
			super();
		}
		
		public static const TABS:Array = ["kungfu1Tab", "kungfu2Tab"];
		public static const KUNG_FU_1_TAB:String = "kungfu1Tab";		
		public static const KUNG_FU_2_TAB:String = "kungfu2Tab";		
		private var _tabBar:TabBar;	
		
		// 当前标签
		private var _curTab:String;
		
		private var _uiLibrary:Array;
		
		private var _kungFu1Image:BaseNativeEntity;
		
		private var _kungFu2Image:BaseNativeEntity;
		
		private var _KungFu1TabView:SkillUpTabView;
		
		private var _KungFu2TabView:SkillUpTabView;
		
		
		
		private function get skillInfo() : Array{
			return ConfigurationManager.getIns().getAllData(AssetsConst.CHARACTER_SKILL);
		}
		
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.SKILLUPVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = AssetsManager.getIns().getAssetObject("skillUpView") as Sprite;
				layer.x = -156;
				this.addChild(layer);
				
				//功能帮助隐藏
				helpBtn.visible = false;
				
				_uiLibrary = [];
				kungfu1NameTxt.mouseEnabled = false;
				kungfu2NameTxt.mouseEnabled = false;
				
				update();
				initTabBar();
				initEvents();
				
			}
		}

		private function initEvents():void
		{
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			helpBtn.addEventListener(MouseEvent.CLICK, onShowHelp);
		}
		

		override public function show():void{
			if(layer == null) return;
			
			update();
			super.show();
		}
		
		override public function update():void{
			renderUI();
		}
		

		private function renderUI():void{
			
			soulTxt.text = NumberConst.numTranslate(player.soul);
			wanNengNumTxt.text = PackManager.getIns().searchItemNum(NumberConst.getIns().wanNengId).toString();
			
			renderKungFu1();
			renderKungFu2();
		}
		
		
		public function renderKungFu1():void{
			kungfu1NameTxt.text = SkillManager.getIns().skillInfo[0].kungfu;
			
			if(!_kungFu1Image){
				_kungFu1Image = new BaseNativeEntity();
				_kungFu1Image.x=106;
				_kungFu1Image.y=86;
				_kungFu1Image.mouseEnabled = false;
				this.addChild(_kungFu1Image);
			}
			_kungFu1Image.data.bitmapData = AUtils.getNewObj(player.fodder + "KungFu" + 1) as BitmapData;
			
			
			if(!_KungFu1TabView){
				_KungFu1TabView = new SkillUpTabView();
				_KungFu1TabView["layerName"] = KUNG_FU_1_TAB;
				_KungFu1TabView.x = 30;
				_KungFu1TabView.y = 58;
				this.addChild(_KungFu1TabView);
				_uiLibrary.push(_KungFu1TabView);
			}
			_KungFu1TabView.update();
		}
		
		
		
		private function renderKungFu2():void{
			kungfu2NameTxt.text = SkillManager.getIns().skillInfo[5].kungfu;
			
			if(!_kungFu2Image){
				_kungFu2Image = new BaseNativeEntity();
				_kungFu2Image.x=106;
				_kungFu2Image.y=322;
				_kungFu2Image.mouseEnabled = false;
				this.addChild(_kungFu2Image);
			}
			_kungFu2Image.data.bitmapData = AUtils.getNewObj(player.fodder + "KungFu" + 2) as BitmapData;
			
			if(!_KungFu2TabView){
				_KungFu2TabView = new SkillUpTabView();
				_KungFu2TabView["layerName"] = KUNG_FU_2_TAB;
				_KungFu2TabView.x = 30;
				_KungFu2TabView.y = 58;
				this.addChild(_KungFu2TabView);
				_uiLibrary.push(_KungFu2TabView);
			}
			_KungFu2TabView.update();
		}
		
		

		private function onClose(e:MouseEvent) : void{
			this.hide();
		}

		protected function onShowHelp(event:MouseEvent):void
		{
			
		}
		
		
		
		
		private function initTabBar():void{
			var arr:Array = [kungfu1Tab,kungfu2Tab];
			_tabBar = new TabBar(arr);
			_tabBar.addEventListener(EventConst.TYPE_SELECT_CHANGE, onTabChange);
			_tabBar.selectIndex = 0;
		}
		
		private function onTabChange(e:CommonEvent) : void
		{
			_curTab = TABS[e.data as int];
			for each(var item:* in _uiLibrary)
			{
				if (item["layerName"] == _curTab)
				{
					item.visible = true;
					item.update();
				}
				else
				{
					item.visible = false;
				}
			}
			
		}

		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		override public function destroy() : void{

			if(_kungFu1Image){
				_kungFu1Image.destroy();
			}
			if(_kungFu2Image){
				_kungFu2Image.destroy();
			}
			
			super.destroy();

		}

		public function get closeBtn() : SimpleButton{
			return layer["closeBtn"];
		}
		public function get helpBtn() : SimpleButton{
			return layer["helpBtn"];
		}
		
		private function get kungfu1Tab():MovieClip
		{
			return layer["kungfu1Tab"];
		}
		private function get kungfu2Tab():MovieClip
		{
			return layer["kungfu2Tab"];
		}
		
		private function get kungfu1NameTxt():TextField
		{
			return layer["KungFu1NameTxt"];
		}
		private function get kungfu2NameTxt():TextField
		{
			return layer["KungFu2NameTxt"];
		}
		private function get soulTxt():TextField
		{
			return layer["soulTxt"];
		}
		private function get wanNengNumTxt():TextField
		{
			return layer["wanNengNumTxt"];
		}
		
		
		
		
		

	}
}