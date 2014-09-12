package com.test.game.Modules.MainGame.boss
{
	import com.greensock.TweenMax;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Modules.MainGame.Guide.BossAssistGuideView;
	import com.test.game.Modules.MainGame.Guide.BossAttachGuideView;
	import com.test.game.Modules.MainGame.Guide.BossSummonGuideView;
	import com.test.game.Modules.MainGame.Guide.BossUpgradeGuideView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.TabBar;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;


	
	public class BossView extends BaseView
	{
		
		public static const TABS:Array = ["summon", "upgrade","attach","assist"];
		public static const SUMMON_TAB:String = "summon";		
		public static const UPGRADE_TAB:String = "upgrade";	
		public static const ATTACH_TAB:String = "attach";	
		public static const ASSIST_TAB:String = "assist";	
		private var _tabBar:TabBar;	
		
		// 当前标签
		private var _curTab:String;
		private var _uiLibrary:Array;
		private var _summonTabView:SummonTabView;
		private var _upgradeTabView:UpgradeTabView;
		private var _attachTabView:AttachTabView;
		private var _assistTabView:AssistTabView;
		public function get summonTabView() : SummonTabView{
			return _summonTabView;
		}
		public function get upgradeTabView() : UpgradeTabView{
			return _upgradeTabView;
		}
		public function get attachTabView() : AttachTabView{
			return _attachTabView;
		}
		public function get assistTabView() : AssistTabView{
			return _assistTabView;
		}

		
		private var _player:PlayerVo;
		
		
		public function BossView()
		{
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.BOSSVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView,LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		
		
		private function renderView(...args):void{
			
			LoadManager.getIns().hideProgress();
			layer = AssetsManager.getIns().getAssetObject("BossView") as Sprite;
			_uiLibrary = [];
			this.addChild(layer);
			layer.x=0;
			layer.y=3;
			layer.visible = false;
			showUpdate();
			initTabBar();
			initEvent();
			openTween();
		}
		
		
		private function initData():void
		{
			_player = PlayerManager.getIns().player;
			
		}		
		
		
		override public function show():void{
			if(layer == null) return;
			openTween();
			showUpdate();
			_tabBar.selectIndex = 0;
			super.show();
		}
		
		private function renderUi():void{
			renderSummon(false);
			renderUpgrade();
			renderAttach();
			renderAssist();
			GuideManager.getIns().bossGuideSetting();
		}
		

		override public function update():void{
			initData();
			renderUi();
		}
		
		
		private function showUpdate():void{
			initData();
			renderSummon();
			renderUpgrade();
			renderAttach();
			renderAssist();
			GuideManager.getIns().bossGuideSetting();
		}
		
		
		public function renderSummon(selectFirst:Boolean = true):void{
			if(!_summonTabView){
				_summonTabView = new SummonTabView();
				_summonTabView["layerName"] = SUMMON_TAB;
				_summonTabView.x = 30;
				_summonTabView.y = 58;
				layer.addChild(_summonTabView);
				_uiLibrary.push(_summonTabView);
			}
			_summonTabView.update(selectFirst);
		}
		
		
		
		private function renderUpgrade():void{
			if(!_upgradeTabView){
				_upgradeTabView = new UpgradeTabView();
				_upgradeTabView["layerName"] = UPGRADE_TAB;
				_upgradeTabView.x = 52;
				_upgradeTabView.y = 96;
				layer.addChild(_upgradeTabView);
				_uiLibrary.push(_upgradeTabView);
			}
		}
		
		
		private function renderAttach():void{
			if(!_attachTabView){
				_attachTabView = new AttachTabView();
				_attachTabView["layerName"] = ATTACH_TAB;
				_attachTabView.x = 50;
				_attachTabView.y = 96;
				layer.addChild(_attachTabView);
				_uiLibrary.push(_attachTabView);
			}
		}
		
		private function renderAssist():void{
			if(!_assistTabView){
				_assistTabView = new AssistTabView();
				_assistTabView["layerName"] = ASSIST_TAB;
				_assistTabView.x = 50;
				_assistTabView.y = 96;
				layer.addChild(_assistTabView);
				_uiLibrary.push(_assistTabView);
			}
		}
		
		
		
		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			(layer["helpBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onShowHelp);
		}
		
		private function onShowHelp(e:MouseEvent) : void{
			switch(_curTab){
				case TABS[0]:
					ViewFactory.getIns().initView(BossSummonGuideView).show();
					break;
				case TABS[1]:
					ViewFactory.getIns().initView(BossUpgradeGuideView).show();
					break;
				case TABS[2]:
					ViewFactory.getIns().initView(BossAttachGuideView).show();
					break;
				case TABS[3]:
					ViewFactory.getIns().initView(BossAssistGuideView).show();
					break;
			}
		}
		
		
		
		private function initTabBar():void{
			var arr:Array = [summonTab,upgradeTab,attachTab,assistTab];
			_tabBar = new TabBar(arr);
			_tabBar.addEventListener(EventConst.TYPE_SELECT_CHANGE, onTabChange);
			_tabBar.selectIndex = 0;
		}
		
		private function onTabChange(e:CommonEvent) : void
		{
			_curTab = TABS[e.data as int];
			titleName.gotoAndStop(_curTab);
			if(_curTab != TABS[0]){
				GuideManager.getIns().bossTabJudge(e.data as int);
			}

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
			
			guideVisible();
		}
		
		private function guideVisible():void{
			var index:int = PlayerManager.getIns().player.mainMissionVo.id;
			if(index > 1005){
				upgradeTab.visible = true;
			}else{
				upgradeTab.visible = false;
			}
			if(index > 1011){
				assistTab.visible = true;
			}else{
				assistTab.visible = false;
			}
		}		
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		private function get summonTab():MovieClip
		{
			return layer["summonTab"];
		}
		
		private function get upgradeTab():MovieClip
		{
			return layer["upgradeTab"];
		}
		
		private function get attachTab():MovieClip
		{
			return layer["attachTab"];
		}
		
		private function get assistTab():MovieClip
		{
			return layer["assistTab"];
		}
		
		private function get titleName():MovieClip
		{
			return layer["titleName"];
		}
		
		private function openTween():void{
			layer.scaleX = layer.scaleY = 0;
			layer.visible = true;
			TweenMax.fromTo(layer,0.4,{scaleX:0,scaleY:0,x:pos.x,y:pos.y},{scaleX:1,scaleY:1,x:this.centerX,y:this.centerY});			
		}
		
		private function closeTween():void{
			TweenMax.to(layer,0.4,{scaleX:0,scaleY:0,x:pos.x,y:pos.y,onComplete:hide});			
		}
		
		private function get pos():Point{
			var p:Point = new Point();
			p.x = ViewFactory.getIns().getView(MainToolBar).layer["summon"].x  + 25 - this.x;
			p.y = ViewFactory.getIns().getView(MainToolBar).layer["summon"].y  + 25 - this.y;
			return p;
		}

		private function close(e:MouseEvent):void{
			closeTween();
			GuideManager.getIns().bossGuideSetting("", true);
		}
		
		
		override public function destroy():void{
			if(_summonTabView != null){
				_summonTabView.destroy();
				_summonTabView = null;
			}
			if(_upgradeTabView != null){
				_upgradeTabView.destroy();
				_upgradeTabView = null;
			}
			if(_attachTabView != null){
				_attachTabView.destroy();
				_attachTabView = null;
			}
			if(_assistTabView != null){
				_assistTabView.destroy();
				_assistTabView = null;
			}
			if(_uiLibrary != null){
				_uiLibrary.length = 0;
				_uiLibrary = null
			}
			if(_tabBar != null){
				_tabBar.destroy();
				_tabBar = null;
			}
			if(closeBtn.hasEventListener(MouseEvent.CLICK)){
				closeBtn.removeEventListener(MouseEvent.CLICK,close);;
			}
			_player = null;
			super.destroy();
		}
	}
}