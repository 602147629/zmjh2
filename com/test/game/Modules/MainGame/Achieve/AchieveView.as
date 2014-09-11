package com.test.game.Modules.MainGame.Achieve
{
	import com.greensock.TweenMax;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ChangePage;
	import com.test.game.UI.Grid.AutoGrid;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class AchieveView extends BaseView
	{
		
		private var _obj:Sprite;
		
		private var _achieveGrid:AutoGrid;
		
		private var _changePage:ChangePage;
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}

		public function AchieveView()
		{
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.ACHIEVEVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView,LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		

		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function renderView(...args):void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = AssetsManager.getIns().getAssetObject("AchieveView") as Sprite;
				this.addChild(layer);
				layer.visible = false;
				
				initBg();
				setCenter();
				
				update();
				initEvent();
				
				openTween();
			}

		}
		

		
		override public function show():void{
			if(layer == null) return;
			openTween();
			update();
			super.show();
		}
		
		private function openTween():void{
			layer.scaleX = layer.scaleY = 0;
			layer.visible = true;
			TweenMax.fromTo(layer,0.4,{scaleX:0,scaleY:0,x:870,y:474},{scaleX:1,scaleY:1,x:this.centerX,y:this.centerY});			
		}
		
		private function closeTween():void{
			TweenMax.to(layer,0.4,{scaleX:0,scaleY:0,x:870,y:474,onComplete:hide});			
		}
		
		override public function update():void{
			renderComponents();
			DeformTipManager.getIns().checkAchieve();
		}
		
		
		private function renderComponents():void{
			
			
			if(!_changePage){
				_changePage = new ChangePage();
				_changePage.x = 440;
				_changePage.y = 510;
				layer.addChild(_changePage);	
				_changePage.visible = false;
			}
			
			if (!_achieveGrid)
			{
				_achieveGrid = new AutoGrid(AchieveComponent,6, 1, 360, 80, 0, 0);
				_achieveGrid.x = 30;
				_achieveGrid.y = 56;
				layer.addChild(_achieveGrid);
			}
			_achieveGrid.setData(achieveDatas,_changePage);
		}
		
		private function get achieveDatas():Array{
			var arr:Array = [];
			var dataArr:Array = ConfigurationManager.getIns().getAllData(AssetsConst.ACHIEVE);
			for(var i:int = 0 ; i<dataArr.length;i++){
				arr.push(dataArr[i]);
			}	
			return sortById(arr);
		}
		
		//按照物品id排序
		private function sortById(arr:Array):Array{
			
			var newArr:Array = new Array();
			newArr=arr.sort(compare);
			
			return newArr;
			
			function compare(x:Object,y:Object):Number{
				var result:Number;
				if(x.id > y.id){
					result = 1;
				}else if(x.id < y.id){
					result = -1;
				}else{
					result = 0;
				}
				return result;
			}
		}
		
		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
		}


		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}

		
		private function close(e:MouseEvent):void{
			closeTween();
		}
		
		
		override public function destroy():void{
			closeBtn.removeEventListener(MouseEvent.CLICK,close);
			if(_achieveGrid != null){
				_achieveGrid.destroy();
				_achieveGrid = null;
			}
			if(_changePage != null){
				_changePage.destroy();
				_changePage = null;
			}
			super.destroy();
		}

	}
}