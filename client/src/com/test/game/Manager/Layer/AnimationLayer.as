package com.test.game.Manager.Layer
{
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class AnimationLayer extends BaseLayer{
		private var _content:BaseNativeEntity;
		private var bm:Bitmap;
		public var bpWidth:int = 10;
		public var bpHeight:int = 10;
		public function AnimationLayer(){
			this._content = new BaseNativeEntity();
			if(!GameConst.USE_TOTAL_BITMAPDATA){
				this.addChild(this._content);
			}else{
				this.bm = new Bitmap();
				this.addChild(this.bm);
			}
		}
		
		
		override public function step():void{
			super.step();
			//渲染
			if(this.bm){
				if(this.bm.bitmapData){
					this.bm.bitmapData.dispose();
				}
				this.bm.bitmapData = this.getTotalBmd();
			}
		}
		
		private var entityVecTemp:Vector.<BaseNativeEntity>;
		private function getTotalBmd():BitmapData{
			if(!this.visible){
				return null;
			}
			var renderBm:Bitmap;
			var stagePos:Point;
			var returnBmd:BitmapData = new BitmapData(bpWidth,bpHeight,true,0x00ffffff);
			entityVecTemp = this.content.getTotalChildEntitys(true);
			for each(var bne:BaseNativeEntity in entityVecTemp){
				if(bne.isShow() && bne.data){
					if(bne.isNeedUnionDeal()){
						renderBm = bne.getChildrenBmd();
						var rect:Rectangle = bne.stageRect;
						stagePos = new Point(renderBm.x,renderBm.y);
						returnBmd.copyPixels(renderBm.bitmapData,renderBm.bitmapData.rect,stagePos,null,null,true);
					}else{
						if(bne.data.bitmapData){
							renderBm = bne.getRenderData();
							stagePos = bne.dataStagePos;
							returnBmd.copyPixels(renderBm.bitmapData,renderBm.bitmapData.rect,stagePos,null,null,true);
						}
					}
				}
			}
			
			return returnBmd;
		}
		
		/**
		 * 重置游戏层（退出副本后调用） 
		 * 
		 */		
		public function reset():void{
			if(this.bm){
				this.bm.bitmapData = null;
			}
		}
		
		
		override public function destroy():void{
			if(this._content){
				this._content.destroy();
				this._content = null;
			}
			if(this.bm){
				this.bm.bitmapData.dispose();
				this.bm = null;
			}
			super.destroy();
		}
		
		public function get content():BaseNativeEntity
		{
			return _content;
		}
		
		public function set content(value:BaseNativeEntity):void
		{
			_content = value;
		}

	}
}