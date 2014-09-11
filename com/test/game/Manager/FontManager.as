package com.test.game.Manager
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.Singleton;
	
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class FontManager extends Singleton
	{
		public function FontManager(){
			super();
		}
		
		public static function getIns():FontManager{
			return Singleton.getIns(FontManager);
		}
		
		private var _fontName:String = "方正行楷简体";
		public function init() : void{
			var cls:Class = AUtils.getSpecialClass("FangZhengXingKai");
			Font.registerFont(cls);
			
			for each(var font:Font in Font.enumerateFonts()){
				trace(font.fontName);
			}
		}
		
		public function getFontFormat() : TextFormat{
			var ttf:TextFormat = new TextFormat();
			ttf.font = _fontName;
			return ttf;
		}
	}
}