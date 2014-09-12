package com.test.game.Modules.MainGame
{
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.SocketConnectManager;
	import com.test.game.Modules.MainGame.DungeonMenu.DungeonMenu;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.Mission.MissionHint;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	import com.test.game.Modules.MainGame.MainUI.BattleToolBar;
	
	public class MainGameView extends BaseView
	{
		private var _bagBtn:Button;
		private var _roleBtn:Button;
		private var _startBtn:Button;
		private var _mutiBtn:Button;
		
		public function MainGameView()
		{
			super();
		}
		
		override public function init():void{
			super.init();
			initPlayerData();
			
		}

		private var itemOpened:Boolean;
		
		private function initUI():void
		{
			initViews();
			initButtons();
			var player:PlayerVo=PlayerManager.getIns().player;
		    trace(1);
		}

		
		private function initViews():void{

			ViewFactory.getIns().initView(RoleStateView).show();
			ViewFactory.getIns().initView(MainToolBar).show();
			ViewFactory.getIns().initView(BattleToolBar).show();
			ViewFactory.getIns().initView(MissionHint).hide();
		
			
			//ViewFactory.getIns().initView(DungeonMenu).hide();	
		}
		
		private function initButtons():void{
			
			_startBtn = new Button();
			_startBtn.label = "选择关卡";
			_startBtn.x = 750;
			_startBtn.y = 290;
			this.addChild(_startBtn);
			_startBtn.addEventListener(MouseEvent.CLICK, showDungeonMenu);
			
			/*_mutiBtn = new Button();
			_mutiBtn.label = "进入组队";
			_mutiBtn.x = 450;
			_mutiBtn.y = 390;
			this.addChild(_mutiBtn);
			_mutiBtn.addEventListener(MouseEvent.CLICK, mutiGame);*/
			
		}
		
		private function initPlayerData():void{
			PlayerManager.getIns().reqPlayerData(initUI);
		}

		private function showDungeonMenu(e:MouseEvent) : void{
			ViewFactory.getIns().getView(DungeonMenu).show();
		}

		
		private function startGame(e:MouseEvent) : void
		{
			//GoToBattleControl(ControlFactory.getIns().getControl(GoToBattleControl)).goToBattle();
			this.hide();
		}
		
		private function mutiGame(e:MouseEvent):void{
			this.hide();
			
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
	}
}