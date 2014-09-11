package com.test.game.Modules.MainGame.DungeonMenu
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class DungeonMenu extends BaseView
	{
		public var nowLevel:int;
		public var nowIndex:int;
		private var _guideMC:MovieClip;
		private var _titleArr:Array;
		
		public var callback:Function;
		public function DungeonMenu(){
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.DUNGEONMENU)],renderView, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function renderView(...args):void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("DungeonMenu") as Sprite;
				this.addChild(layer);
				
				initUI();
				initParams();
				setParams();
				setCenter();
				if(callback != null){
					callback();
				}
			}
		}
		
		
		private function initUI() : void{
			_guideMC = GuideManager.getIns().getGuideMCByName(GuideManager.ARROW, 0, 0);
			_guideMC.visible = false;
			layer.addChild(_guideMC);
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			
			initBg();
		}
		
		private var _levelInfo:Array;
		private var _DungeonData:Array;
		private function initParams() : void{
			initTitles();
		}

		private function initTitles():void{
			_titleArr = [];
			for(var i:int = 0; i < 4; i++){
				var title:DungeonTitle = new DungeonTitle();
				title.index = i;
				title.addEventListener(MouseEvent.CLICK, onTitleClicked);
				layer.addChild(title);
				_titleArr.push(title);
			}
			anaylsisData();
			setTitleVisible(0);
		}
		
		public function setTitleVisible(index:int):void{
			_titleArr[index].showDungeons();
			for(var i:int = 0; i < 4; i++){
				if(i > index){
					_titleArr[i].hideDungeonsDown();
				}
				else if(i < index){
					_titleArr[i].hideDungeonsUp();
				}
			}
			
			if(LevelManager.getIns().guideIndex == 0){
				_guideMC.visible = false;
			}else if(int((LevelManager.getIns().guideIndex - 1) / 3) == index){
				_guideMC.visible = true;
				_guideMC.y = int(((LevelManager.getIns().guideIndex - 1) / 3)) * 50 + 125;
				layer.setChildIndex(_guideMC, layer.numChildren - 1);
			}else{
				_guideMC.visible = false;
			}
		}
		
		private function onTitleClicked(e:MouseEvent):void{
			if(e.currentTarget.isShow){
				return;
			}
			setTitleVisible(e.currentTarget.index);
		}
		
		override public function setParams():void{
			if(layer == null) return;
			LevelManager.getIns().guideIndex = 0;
			_levelInfo = ConfigurationManager.getIns().getAllDataByLevel(nowLevel);
			_DungeonData = PlayerManager.getIns().getDungeonInfo(nowLevel);
			//_DungeonData = [4,4,4,4,4,4,4,4,4];
			resetTitle();
			
			(layer["SceneName"] as TextField).text = _levelInfo[0].scene_name;
			guideShowSetting();
			setTitleVisible(nowIndex);
		}
		
		private function guideShowSetting():void{
			if(LevelManager.getIns().guideIndex == 0){
				_guideMC.visible = false;
			}else{
				_guideMC.x = (LevelManager.getIns().guideIndex - 1) % 3 * 116 + 82;
			}
		}
		
		private function resetTitle() : void{
			for(var i:int = 0; i < _levelInfo.length / 3; i++){
				var infoList:Array = new Array();
				for(var j:int = i * 3; j < i * 3 + 3; j++){
					infoList.push(_levelInfo[j]);
				}				
				_titleArr[i].x = 45;
				_titleArr[i].y = 100 + 50 * i;
				_titleArr[i].setData(infoList, [_DungeonData[i * 3], _DungeonData[i * 3 + 1], _DungeonData[i * 3 + 2]]);
				if(i < 2){
					if(_DungeonData[i * 3 + 2] <= 0){
						_titleArr[i + 1].visible = false;
					}else{
						_titleArr[i + 1].visible = true;
					}
				}
				if(_DungeonData[9] == 0){
					_titleArr[3].visible = false;
				}else{
					_titleArr[3].visible = true;
				}
			}
			/*if(nowLevel == 4){
				_titleArr[2].visible = false;
			}*/
			anaylsisData();
			//setTitleVisible(0);
		}
		
		private function anaylsisData() : void{
			if(_DungeonData == null) return;
			var result:int;
			for(var i:int = 0; i < _DungeonData.length; i++){
				if(_DungeonData[i] != 0){
					result = i;
				}
			}
			setTitleVisible(int(result / 3));
		}
		
		private function close(e:MouseEvent):void{
			this.hide();
		}
		
		public function get closeBtn():SimpleButton{
			return layer["closeBtn"];
		}
		
		override public function destroy() : void{
			if(_guideMC != null){
				if(_guideMC.parent != null){
					_guideMC.parent.removeChild(_guideMC);
				}
				_guideMC = null;
			}
			closeBtn.removeEventListener(MouseEvent.CLICK,close);
			for(var i:int = 0; i < 4; i++){
				_titleArr[i].removeEventListener(MouseEvent.CLICK, onTitleClicked);
				_titleArr[i].destroy();
				_titleArr[i] = null;
			}
			_titleArr.length = 0;
			_titleArr = null;
			
			super.destroy();
		}
	}
}