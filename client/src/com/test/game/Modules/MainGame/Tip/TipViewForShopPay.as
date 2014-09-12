package com.test.game.Modules.MainGame.Tip
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TipViewForShopPay extends TipView
	{
		public function TipViewForShopPay()
		{
			super();
		}
		
		
		override public function setFun(content:String, comfireFun:Function = null, cancelFun:Function = null, hideBtn:Boolean = false) : void{
			
			(layer["urlMc"] as Sprite).visible = true;
			var format:TextFormat=new TextFormat();
			format.underline = true;
			(layer["urlMc"] as Sprite).buttonMode = true;
			(layer["urlMc"] as Sprite).mouseChildren = false;
			(layer["urlMc"] as Sprite)["urlText"].setTextFormat(format);
			
			(layer["CancelBtn"] as SimpleButton).visible = false;
			(layer["ComfireBtn"] as SimpleButton).x = 150;
			
			_content = content;
			_comfireFun = comfireFun;
			
			(layer["ContentTF"] as TextField).text = _content;
			this.show();
			
			getContainer().setChildIndex(this, getContainer().numChildren - 1);
			
			if(hideBtn){
				(layer["ComfireBtn"] as SimpleButton).visible = false;
			}else{
				(layer["ComfireBtn"] as SimpleButton).visible = true;
			}
		}
	}
}