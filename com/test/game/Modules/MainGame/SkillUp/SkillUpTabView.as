package com.test.game.Modules.MainGame.SkillUp
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.Grid.AutoGrid;
	
	
	public class SkillUpTabView extends BaseSprite
	{

		public var layerName:String;
		
		private var _skillGrid:AutoGrid;
		
		private var _anti:Antiwear;
		
		private function get skillArr():Array{
			return _anti["skillArr"];
		}
		
		private function set skillArr(arr:Array):void{
			_anti["skillArr"] = arr;
		}
		
		public function SkillUpTabView()
		{
			_anti = new Antiwear(new binaryEncrypt());
			super();
		}

		
		public function update():void{
			setSkillArr();
			renderItems();
		}
		
		
		private function setSkillArr():void{
			var arr:Array = [];
			var index:int;
			switch(layerName){
				case SkillUpView.KUNG_FU_1_TAB:
					index = 0;
					break;
				case SkillUpView.KUNG_FU_2_TAB:
					index = 5;
					break;
			}
			for(var i:int = index; i < index + 5; i++){
				arr.push([i, player.skill.skillArr[i]]);
			}
			skillArr = arr;
		}
		
		private function renderItems():void{
			
			if (!_skillGrid)
			{
				_skillGrid = new AutoGrid(SkillUpComponent,1, 5, 94, 466, 10, 10);
				_skillGrid.x = 270;
				_skillGrid.y = 15;
				this.addChild(_skillGrid);
			}
			_skillGrid.setData(skillArr);
		}
		

		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		override public function destroy() : void{
			if(_skillGrid != null){
				_skillGrid.destroy();
				_skillGrid = null;
			}
			super.destroy();
		}
	}
}