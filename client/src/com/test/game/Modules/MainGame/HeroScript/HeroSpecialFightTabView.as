package com.test.game.Modules.MainGame.HeroScript
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.OccupationConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ChangePage;
	import com.test.game.UI.Grid.AutoGrid;
	
	import flash.display.Sprite;
	import flash.text.TextField;

	public class HeroSpecialFightTabView extends BaseSprite
	{
		
		private var _obj:Sprite;
		
		public var layerName:String;
		
		private var _dungeonGrid:AutoGrid;
		
		private var _changePage:ChangePage;
		
		
		public function HeroSpecialFightTabView()
		{
			_obj = AssetsManager.getIns().getAssetObject("HeroSpecialFightTabView") as Sprite;
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
			fightNumTxt.text = (1-player.heroScriptVo.heroSpecialFightNum).toString();
			countNumTxt.text = (60-player.heroScriptVo.heroSpecialFightCount).toString();
			fightCostTxt.text = "299点券";
			
			if(player.heroScriptVo.heroSpecialFightNum==0){
				fightCostTxt.visible = false;
				costTitle.visible = false;
				fightNumTitle.visible = true;
				fightNumTxt.visible = true;
			}else{
				fightCostTxt.visible = true;
				costTitle.visible = true;
				fightNumTitle.visible = false;
				fightNumTxt.visible = false;
			}
			
			if(player.heroScriptVo.heroSpecialFightCount == 59){
				lastTF.visible = true;
				coolDwon.visible = false;
			}else{
				lastTF.visible = false;
				coolDwon.visible = true;
			}
			
			if(!_changePage){
				_changePage = new ChangePage();
				_changePage.x = 498;
				_changePage.y = 422;
				this.addChild(_changePage);	
			}
			
			if (!_dungeonGrid)
			{
				_dungeonGrid = new AutoGrid(HeroSpecialFightIcon,2, 4, 100, 100, 30, 10);
				_dungeonGrid.x = 294;
				_dungeonGrid.y = 186;
				this.addChild(_dungeonGrid);
			}
			_dungeonGrid.setData(PackManager.getIns().curBossCardData,_changePage);
		}
		
	
		private function get fightNumTxt():TextField{
			return _obj["fightNumTxt"];
		}
		
		private function get fightCostTxt():TextField{
			return _obj["fightCostTxt"];
		}
		
		private function get fightNumTitle():TextField{
			return _obj["fightNumTitle"];
		}
		
		private function get costTitle():TextField{
			return _obj["costTitle"];
		}
		
		private function get countNumTxt():TextField{
			return _obj["CoolDwon"]["countNumTxt"];
		}
		
		private function get coolDwon() : Sprite{
			return _obj["CoolDwon"];
		}
		private function get lastTF() : Sprite{
			return _obj["LastTF"];
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