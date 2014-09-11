package com.test.game.Modules.MainGame.Guide
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.GuideManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class FirstLevelGuideView extends BaseView
	{
		public function FirstLevelGuideView(){
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.FIRSTLEVELGUIDEVIEW)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = new Sprite();
				this.addChild(layer);
				
				setParams();
				initUI();
			}
		}
		
		private function initUI():void{
			firstLevelGuide();
		}
		
		private var _nowGuide:int = 1;
		private var _guideMC:MovieClip;
		public function firstLevelGuide() : void{
			if(layer == null) return;
			if(_guideMC != null){
				if(_guideMC.parent != null){
					_guideMC.parent.removeChild(_guideMC);
				}
				_guideMC.stop();
				_guideMC = null;
			}
			_guideMC = GuideManager.getIns().getGuideMCByName("OperateGuide" + _nowGuide, 300, 20);
			this.addChild(_guideMC);
			_nowGuide++;
			
			/*_guideMC = GuideManager.getIns().getGuideMCByName("NewOperateGuide", 200, 20);
			this.addChild(_guideMC);
			(_guideMC["OperateSeq"] as MovieClip).gotoAndStop(_nowGuide);
			(_guideMC["TextSeq"] as MovieClip).gotoAndStop(_nowGuide);
			(_guideMC["KuangWuActionSeq"] as MovieClip).gotoAndStop(_nowGuide);
			(_guideMC["XiaoYaoActionSeq"] as MovieClip).stop();
			(_guideMC["XiaoYaoActionSeq"] as MovieClip).visible = false;
			_nowGuide++;*/
		}
		
		private var _stepInterval:int = 90;
		private var _stepTime:int;
		override public function step() : void{
			return;
			if(_stepTime >= 0 && _stepTime < _stepInterval * .5){
				_guideMC.visible = true;
			}else if(_stepTime >= _stepInterval * .5 && _stepTime < _stepInterval){
				_guideMC.visible = false;
			}else{
				_stepTime = -1;
			}
			_stepTime++;
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameInfoLayer;	
		}
	}
}