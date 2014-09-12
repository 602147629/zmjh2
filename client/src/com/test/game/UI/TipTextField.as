package com.test.game.UI
{
	import com.test.game.Const.ColorConst;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TipTextField extends TextField
	{		
		private var tipTextFormat:TextFormat;
		public function TipTextField(width:int, height:int, text:String, fontName:String = "宋体", fontSize:Number = 12, color:uint=0, bold:Boolean=false):void
		{
			this.width = width;
			this.height = height;
			this.text = text;
			tipTextFormat = new TextFormat();
			tipTextFormat.font = fontName;
			tipTextFormat.size = fontSize;
			tipTextFormat.color = color;
			tipTextFormat.bold = bold;
			this.defaultTextFormat = tipTextFormat;
			checkTextHeight();
		}
		
		override public function set text(value:String):void {
			super.text = value;
			checkTextHeight();
		}
		
		override public function set htmlText(value:String):void {
			super.htmlText = setColor(value);
			
		}
		
		
		private function setColor(value:String):String{
			var bingRegExp:RegExp = /(丙以上：)(.*)/;
			var yiRegExp:RegExp = /(乙以上：)(.*)/;
			var dingRegExp:RegExp = /(丁以上：)(.*)/;
			var jiRegExp:RegExp = /(首次极评价：)(.*)/;
			var itemRegExp:RegExp = /(过关时有概率获得：\s)(.*)/;
			value = value.replace(bingRegExp,setReplGreen);
			value = value.replace(yiRegExp,setReplGreen);
			value = value.replace(dingRegExp,setReplGreen);
			value = value.replace(jiRegExp,setReplPurple);
			value = value.replace(itemRegExp,setReplGreen);
			
			function setReplGreen():String { 
				return arguments[1]+ ColorConst.setDarkGreen(arguments[2]); } 
		
			function setReplPurple():String { 
				return arguments[1]+ ColorConst.setPurple(arguments[2]); } 
			
			return value;
		}
		
		private function checkTextHeight():void{
			this.height = this.textHeight+5;
		}
	}
}