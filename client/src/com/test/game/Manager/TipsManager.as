package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.NumberConst;
	import com.test.game.UI.SimpleTips;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	
	public class TipsManager extends Singleton
	{
		public function TipsManager()
		{
			tipIconArr=[];
			super();
		}
		
		public static function getIns():TipsManager{
			return Singleton.getIns(TipsManager);
		}
		
		private var tipIconArr:Array;
		private var _tips:SimpleTips;
		
		public function addTips(source:DisplayObject,data:Object):void
		{
			if(!_tips){
				_tips = ViewFactory.getIns().initView(SimpleTips) as SimpleTips;	
			}
			
			for each(var icon:Object in tipIconArr){
				if(icon.source == source){
					icon.tips = data;
					return;
				}
				
			}
			
			tipIconArr.push({source:source,tips:data});
			_tips.hide();
			
			source.addEventListener(MouseEvent.MOUSE_MOVE,showTip);
			source.addEventListener(MouseEvent.ROLL_OUT,hideTip);
		}
		

		
		public function removeTips(source:DisplayObject):void
		{
			for each(var icon:Object in tipIconArr){
				if(icon.source == source){
					icon.source.removeEventListener(MouseEvent.MOUSE_MOVE,showTip);
					icon.source.removeEventListener(MouseEvent.ROLL_OUT,hideTip);
					tipIconArr.splice(tipIconArr.indexOf(icon),1);
				}
			}
		}
		
		private function showTip(e:MouseEvent):void
		{
			
			if(e.currentTarget.hasOwnProperty("isDrag")){
				if(e.currentTarget.isDrag){
					return;
				}
			}
			_tips.show();
			for each(var icon:Object in tipIconArr){
				if(icon.source == e.currentTarget){
					_tips.setData(icon.tips);
				}
			}
			
			var distanceY:int = e.stageY + _tips.height - NumberConst.GAME_HEIGHT;
			if(distanceY>0){
				_tips.y = e.stageY - distanceY;	
			}else{
				_tips.y = e.stageY ;	
			}
			
			var distanceX:int = e.stageX + _tips.width - NumberConst.GAME_WIDTH;
			if(distanceX>0){
				_tips.x = e.stageX  - distanceX;
				if(distanceY>0){
					_tips.y = e.stageY - _tips.height -15;
				}else{
					_tips.y = e.stageY + 30;	
				}
				
			}else{
				_tips.x = e.stageX + 15 ;	
			}
			

		}
		
		public function hideTip(e:MouseEvent):void{
			_tips.hide(); 
		}
		
		
		public function clear() : void{
			for(var i:int = 0; i < tipIconArr.length; i++){
				tipIconArr[i].source.removeEventListener(MouseEvent.MOUSE_MOVE,showTip);
				tipIconArr[i].source.removeEventListener(MouseEvent.ROLL_OUT,hideTip);
				tipIconArr[i] = null;
			}
			tipIconArr.length = 0;
		}
	}
}