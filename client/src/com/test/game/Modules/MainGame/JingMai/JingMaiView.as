package com.test.game.Modules.MainGame.JingMai
{
	import com.greensock.TweenMax;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class JingMaiView extends BaseView
	{

		public function JingMaiView()
		{
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.JINGMAIVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView,LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function renderView(...args):void{
			
			LoadManager.getIns().hideProgress();
			layer = AssetsManager.getIns().getAssetObject("JingMaiView") as Sprite;
			this.addChild(layer);
			layer.visible = false;

			update();
			initEvent();
			openTween();
		}
		
		private function initEvent():void{
			for(var i:int=1;i<=10;i++){
				(layer["mai"+i] as MovieClip).buttonMode = true;
				(layer["mai"+i] as MovieClip).addEventListener(MouseEvent.CLICK,onShowXueDao);	
			}

			closeBtn.addEventListener(MouseEvent.CLICK,close);
		}
		
		protected function onShowXueDao(e:MouseEvent):void
		{
			if((e.currentTarget as MovieClip).currentFrame!=3){
				ViewFactory.getIns().initView(XueDaoView).show();
				(ViewFactory.getIns().initView(XueDaoView) as XueDaoView).setData(e.currentTarget.name);
				hide();	
				GuideManager.getIns().jingMaiGuideSetting();
			}

		}		

		
		override public function update():void{
			setJingMaiIcons();
			jingMaiPowerTxt.text = player.jingMai.jingMaiPower.toString();
			jingMaiProcessTxt.text = player.jingMai.costPoint + " / 64";
		}
		
		private function setJingMaiIcons():void
		{
			var jingMaiDataArr:Array = ConfigurationManager.getIns().getAllData(AssetsConst.JINGMAI);
			for(var i:int =1;i<=10;i++){
				var mc:MovieClip = (layer["mai"+i] as MovieClip);
				if(player.jingMai.jingMaiArr[i-1]==-1){
					mc.gotoAndStop(3);
				}else if(player.jingMai.jingMaiArr[i-1]==jingMaiDataArr[i-1].point_name.length){
					mc.gotoAndStop(2);
				}else{
					mc.gotoAndStop(1);
					
					//遮罩
					var ratio:Number = (player.jingMai.jingMaiArr[i-1])/jingMaiDataArr[i-1].point_name.length;
					var _angle:int = 300*ratio;
					
					if(mc["circleBar"].mask==null){
						var _arcMask:Sprite = new Sprite();
						_arcMask.graphics.beginFill(0xFF0000);
						mc["circleBar"].addChild(_arcMask);
						mc["circleBar"].mask=_arcMask;
						drawSector(_arcMask.graphics,_angle);
					}else{
						drawSector(mc["circleBar"].mask.graphics,_angle);
					}

				}
				
			}
		}		
		
		private function drawSector(g:Graphics,lAngle:Number,x:Number = 45, y:Number = 45, radius:Number = 50, sAngle:Number = 120):void{
			g.clear();
			g.beginFill(0xFF0000);
			var sx:Number = radius;
			var sy:Number = 0;
			if (sAngle != 0) {
				sx = Math.cos(sAngle * Math.PI/180) * radius;
				sy = Math.sin(sAngle * Math.PI/180) * radius;
			}
			g.moveTo(x, y);
			g.lineTo(x + sx, y +sy);
			var a:Number =  lAngle * Math.PI / 180 / lAngle;
			var cos:Number = Math.cos(a);
			var sin:Number = Math.sin(a);
			var b:Number = 0;
			for (var i:Number = 0; i < lAngle; i++) {
				var nx:Number = cos * sx - sin * sy;
				var ny:Number = cos * sy + sin * sx;
				sx = nx;
				sy = ny;
				g.lineTo(sx + x, sy + y);
			}
			g.lineTo(x, y);
			g.endFill();
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
			TweenMax.fromTo(layer,0.4,{scaleX:0,scaleY:0,x:pos.x,y:pos.y},{scaleX:1,scaleY:1,x:this.centerX,y:this.centerY});			
		}
		
		private function closeTween():void{
			TweenMax.to(layer,0.4,{scaleX:0,scaleY:0,x:pos.x,y:pos.y,onComplete:hide});			
		}
		
		private function get pos():Point{
			var p:Point = new Point();
			p.x = ViewFactory.getIns().getView(MainToolBar).layer["jingmai"].x  + 25 - this.x;
			p.y = ViewFactory.getIns().getView(MainToolBar).layer["jingmai"].y  + 25 - this.y;
			return p;
		}
		
		private function close(e:MouseEvent):void{
			closeTween();
			GuideManager.getIns().jingMaiGuideSetting(true);
		}
		
		
		private function get player():PlayerVo
		{
			return PlayerManager.getIns().player;
		}

		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		private function get jingMaiPowerTxt():TextField
		{
			return layer["jingMaiPowerTxt"];
		}
		
		private function get jingMaiProcessTxt():TextField
		{
			return layer["jingMaiProcessTxt"];
		}
		
		override public function destroy():void{
			if(closeBtn.hasEventListener(MouseEvent.CLICK)){
				closeBtn.removeEventListener(MouseEvent.CLICK,close);;
			}
			super.destroy();
		}
	}
}