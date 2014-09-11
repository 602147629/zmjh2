package com.test.game.Modules.MainGame
{
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Manager.SocketConnectManager;
	import com.test.game.Modules.MainGame.DungeonMenu.DungeonMenu;
	
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	
	public class StartLevelView extends BaseView
	{
		private var _startBtn:Button;
		private var _startBtn1:Button;
		private var _mutiBtn:Button;
		private var _skillBtn:Button;
		
		public function StartLevelView()
		{
			super();
		}
		
		override public function init():void{
			super.init();
			
			initView();
		}
		
		private function initView():void
		{
			_startBtn = new Button();
			_startBtn.label = "进入关卡1";
			_startBtn.x = 450;
			_startBtn.y = 290;
			this.addChild(_startBtn);
			_startBtn.addEventListener(MouseEvent.CLICK, startGame);
			
			_startBtn1 = new Button();
			_startBtn1.label = "进入关卡2";
			_startBtn1.x = 450;
			_startBtn1.y = 320;
			this.addChild(_startBtn1);
			_startBtn1.addEventListener(MouseEvent.CLICK, startGame1);
			
			_mutiBtn = new Button();
			_mutiBtn.label = "进入组队";
			_mutiBtn.x = 450;
			_mutiBtn.y = 390;
			this.addChild(_mutiBtn);
			_mutiBtn.addEventListener(MouseEvent.CLICK, mutiGame);
			
			_skillBtn = new Button();
			_skillBtn.label = "技能";
			_skillBtn.x = 450;
			_skillBtn.y = 350;
			this.addChild(_skillBtn);
			_skillBtn.addEventListener(MouseEvent.CLICK, skillUI);
		}
		
		private function skillUI(e:MouseEvent) : void{
			//(ViewFactory.getIns().initView(SkillLearnView) as SkillLearnView).show();
		}
		
		private function startGame(e:MouseEvent) : void{
			(ViewFactory.getIns().initView(DungeonMenu) as DungeonMenu).nowLevel = 1;
			(ViewFactory.getIns().initView(DungeonMenu) as DungeonMenu).show();
		}
		
		private function startGame1(e:MouseEvent) : void{
			(ViewFactory.getIns().initView(DungeonMenu) as DungeonMenu).nowLevel = 2;
			(ViewFactory.getIns().initView(DungeonMenu) as DungeonMenu).show();
		}
		
		private function mutiGame(e:MouseEvent):void{
			this.hide();
			
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
	}
}