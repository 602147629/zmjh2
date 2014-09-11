package com.test.game.UI
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class SimpleNotice extends BaseSprite
	{
		public function SimpleNotice()
		{
			start();
		}
		
		private var _obj:Sprite;
		
		private var iconVec:Vector.<ItemIcon>;
		
		protected var _comfireFun:Function;
		protected var _cancelFun:Function;
		
		private var _bg:Scale9GridDisplayObject;
		private static const LEFT_GAP:Number=53;
		private static const TOP_GAP:Number=70;
		private static const INTERVAL:Number = 8;
		
		private function start(...args) : void{
			// 底图
			_bg = new Scale9GridDisplayObject(AssetsManager.getIns().getAssetObject("noticeBg")
				,new Rectangle(50,70,255,16));
			_bg.alpha = 1;
			this.addChild(_bg);
			
			if(_obj == null){
				_obj = AssetsManager.getIns().getAssetObject("newTipView") as Sprite;
				this.addChild(_obj);
			}
			
			//物品图标
			iconVec = new Vector.<ItemIcon>;
			
			initEvents();
			initParams();
			initUi();
		}
		
		private function initParams():void{
			_comfireFun = null;
			_cancelFun = null;
		}
		
		
		private function initEvents():void{
			sureBtn.addEventListener(MouseEvent.CLICK, onComfireFun);
			cancelBtn.addEventListener(MouseEvent.CLICK, onCancelFun);
		}
		
		protected function initUi() : void
		{

			var format:TextFormat = new TextFormat();
			format.leading = 6;
			
			
			//tip内容
			contentTF.multiline = true;
			contentTF.wordWrap = true;
			contentTF.defaultTextFormat = format;
			
		
		}
		
	
		
		public function setFun(content:String, comfireFun:Function = null, cancelFun:Function = null,arr:Array = null) : void{
			contentTF.width = 255;
			contentTF.x = LEFT_GAP;
			contentTF.y = TOP_GAP;
			contentTF.htmlText = content;
			_comfireFun = comfireFun;
			_cancelFun = cancelFun;
			
			if(arr!=null){
				setIcon(arr);
			}
			
			setVerticalPos();
			
			//this.parent.setChildIndex(this, this.parent.numChildren - 1);
		}
		
		public function setFunOnlySure(content:String,comfireFun:Function = null,arr:Array=null) : void{
			setFun(content,comfireFun,null,arr);
			
			sureBtn.x = 150;
			cancelBtn.visible = false;
			//this.parent.setChildIndex(this, this.parent.numChildren - 1);
		}
		
		
		protected function setVerticalPos():void{
			
			contentTF.height = contentTF.textHeight+5;

			var imageHeight:int;
			if(iconVec.length>0){
				imageHeight = iconVec[iconVec.length-1].y+50;
			}
			_bg.height = Math.max(imageHeight,contentTF.y+contentTF.height)+80;
			
			sureBtn.y = cancelBtn.y = Math.max(imageHeight,contentTF.y+contentTF.height)+18;
			
		}
		
		private function setIcon(arr:Array):void{
			for(var i:int=0;i<arr.length;i++){
				var _icon:ItemIcon  = new ItemIcon();
				this.addChild(_icon);
				_icon.setData(arr[i]);
				_icon.x=80;
				_icon.y=70+i*40;
				_icon.selectable = false;
				_icon.menuable = false;
				iconVec.push(_icon);
			}
			
			contentTF.width = 140;
			contentTF.x = LEFT_GAP+80;
		}
		
		private function onComfireFun(e:MouseEvent) : void{

			if(iconVec.length!=0){
/*				for(var i:int=0;i<iconVec.length;i++){
					TweenMax.to(iconVec[i], 0.6, {ease:Linear.easeInOut,scaleX:0.4,scaleY:0.4,x:274,y:324, onComplete:destroy});	
				}*/
				this.destroy();
			}else{
				this.destroy();
			}

			
			if(_comfireFun != null){
				_comfireFun();
			}
		}
		
		private function onCancelFun(e:MouseEvent) : void{
			this.destroy();
			if(_cancelFun != null){
				_cancelFun();
			}
		}
		
		
		private function get sureBtn():SimpleButton{
			return _obj["ComfireBtn"];
		}
		
		private function get cancelBtn():SimpleButton{
			return _obj["CancelBtn"];
		}
		
		private function get contentTF():TextField{
			return _obj["ContentTF"];
		}
		
		override public function destroy() : void{
			
			(ViewFactory.getIns().getView(NoticeView) as NoticeView).removeNotice(this);
			
			removeComponent(_obj);
			
			for(var i:int=0;i<iconVec.length;i++){
				iconVec[i].destroy();
				iconVec[i] = null;
			}
			
			
			if(_bg != null){
				if(_bg.parent != null){
					_bg.parent.removeChild(_bg);
					_bg = null;
				}
			}
			super.destroy();
			
		}
		
		
	}
}