package com.test.game.Modules.MainGame.Tip
{
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.UI.SimpleNotice;
	
	import flash.display.Sprite;
	
	public class NoticeView extends BaseView
	{
		
		private var noticeVec:Vector.<SimpleNotice>;
		
		public function NoticeView()
		{
			super();
			start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = new Sprite();
				this.addChild(layer);
				initBg();
				noticeVec = new Vector.<SimpleNotice>;
				
			}
		}
		

		public function addNotice(content:String,sureFunc:Function = null,cancelFunc:Function = null,arr:Array =null):void{
			show();
			var notice:SimpleNotice = new SimpleNotice();
			layer.addChild(notice);
			notice.setFun(content,sureFunc,cancelFunc,arr);
			noticeVec.push(notice);
			setCenter();
		}
		
		public function addOnlySureNotice(content:String,sureFunc:Function = null,arr:Array =null):void{
			show();
			var notice:SimpleNotice = new SimpleNotice();
			layer.addChild(notice);
			notice.setFunOnlySure(content,sureFunc,arr);
			noticeVec.push(notice);
			setCenter();
		}
		
		public function removeNotice(notice:SimpleNotice):void{
			for each(var item:SimpleNotice in noticeVec){
				if(item == notice){
					noticeVec.splice(noticeVec.indexOf(item),1);
				}
			}
			if(noticeVec.length==0){
				hide();
			}
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameTipLayer;
		}
		
		override public function destroy() : void{
			if(layer != null){
				layer = null
			}
			super.destroy();
		}
	}
}