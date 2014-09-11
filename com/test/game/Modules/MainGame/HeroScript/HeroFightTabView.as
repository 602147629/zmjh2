package com.test.game.Modules.MainGame.HeroScript
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.OccupationConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ChangePage;
	import com.test.game.UI.Grid.AutoGrid;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	public class HeroFightTabView extends BaseSprite
	{
		public var layerName:String;
		private var _obj:Sprite;
		
		private var _dungeonGrid:AutoGrid;
		
		private var _changePage:ChangePage;
		
		
		public function HeroFightTabView()
		{
			_obj = AssetsManager.getIns().getAssetObject("HeroFightTabView") as Sprite;
			_obj.x = 206;
			_obj.y = 125;
			this.addChild(_obj);
			update();
			initEvent();
		}
		
		private function initEvent():void
		{
			
		}		
		

		
		public function update():void{
			renderDungeons();
		}
		
		
		private function renderDungeons():void{
			fightNumTxt.text = (3 - player.heroScriptVo.heroFightNum).toString();
			if(!_changePage){
				_changePage = new ChangePage();
				_changePage.x = 498;
				_changePage.y = 436;
				this.addChild(_changePage);	
			}
			
			if (!_dungeonGrid)
			{
				_dungeonGrid = new AutoGrid(HeroFightDungeonIcon,1, 3, 200, 270, 27, 10);
				_dungeonGrid.x = 204;
				_dungeonGrid.y = 126;
				this.addChild(_dungeonGrid);
			}
			_dungeonGrid.setData(heroFightDungeonDatas,_changePage);
		}
		
		private function get heroFightDungeonDatas():Array{
			var arr:Array = [];
			for(var i:int = 0 ; i<3;i++){
				var obj:Object = new Object();
				obj = {id:"heroDungeon"+int(i+1),isOpen:true};
				arr.push(obj);
			}	
			return arr;
		}
	
	
		private function get fightNumTxt():TextField{
			return _obj["fightNumTxt"];
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		override public function destroy() : void{
			removeComponent(_obj);
			if(_dungeonGrid != null){
				_dungeonGrid.destroy();
				_dungeonGrid = null;
			}
			if(_changePage != null){
				_changePage.destroy();
				_changePage = null;
			}
			super.destroy();
		}
	}
}