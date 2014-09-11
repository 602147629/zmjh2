package com.test.game.Modules.MainGame.Tip
{
	
	import flash.display.SimpleButton;
	import flash.text.TextField;

	public class TipViewWithoutCancel extends TipView
	{
		public function TipViewWithoutCancel()
		{
			super();
		}
		
		override public function setFun(content:String, comfireFun:Function = null, cancelFun:Function = null, hideBtn:Boolean = false) : void{
			(layer["CancelBtn"] as SimpleButton).visible = false;
			(layer["ComfireBtn"] as SimpleButton).x = 150;
			
			if(hideBtn){
				(layer["ComfireBtn"] as SimpleButton).visible = false;
			}else{
				(layer["ComfireBtn"] as SimpleButton).visible = true;
			}
			
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
		
		override public function hide():void{
			super.hide();
		}
	}
}