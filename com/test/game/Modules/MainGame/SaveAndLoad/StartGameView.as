package com.test.game.Modules.MainGame.SaveAndLoad
{
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	
	public class StartGameView extends BaseView
	{
		public function StartGameView()
		{
			super();
			renderView();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private var newGameBtn:Button;
		private var loadGameBtn:Button;
		private var quitGameBtn:Button;
		private var saveListView:SaveListView;
		
		private function renderView():void
		{
			newGameBtn = new Button();
			newGameBtn.label = "新的开始";
			newGameBtn.x = 450;
			newGameBtn.y = 190;
			this.addChild(newGameBtn);
			newGameBtn.addEventListener(MouseEvent.CLICK, newGame);
			
			loadGameBtn = new Button();
			loadGameBtn.label = "读取存档";
			loadGameBtn.x = 450;
			loadGameBtn.y = 260;
			this.addChild(loadGameBtn);
			loadGameBtn.addEventListener(MouseEvent.CLICK, loadGame);
			
			quitGameBtn = new Button();
			quitGameBtn.label = "退出游戏";
			quitGameBtn.x = 450;
			quitGameBtn.y = 330;
			this.addChild(quitGameBtn);
			quitGameBtn.addEventListener(MouseEvent.CLICK, quitGame);
			
			saveListView = new SaveListView();
			saveListView.x = 270;
			saveListView.y = 130;
			saveListView.visible = false;
			this.addChild(saveListView);
		}
		
		
		protected function newGame(event:MouseEvent):void
		{
			saveListView.saveShow();
			
		}
		
		
		protected function loadGame(event:MouseEvent):void
		{
			saveListView.loadShow();
		}
		
		protected function quitGame(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}


		
	}
}