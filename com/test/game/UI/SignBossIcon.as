package com.test.game.UI
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Mvc.Vo.ItemVo;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class SignBossIcon extends BaseSprite
	{
		private var _layer:Sprite;
		private var _itemVo:ItemVo;
		private var _bossHead:BaseNativeEntity;
		public function SignBossIcon()
		{
			super();
			
			_layer = AUtils.getNewObj("SignBossIcon") as Sprite;
			this.addChild(_layer);
			
			_bossHead = new BaseNativeEntity();	
			_bossHead.y = -10;
			exchangeHead.addChild(_bossHead);
		}
		
		public function setData(data:ItemVo) : void{
			_itemVo = data;
			
			_bossHead.data.bitmapData = AUtils.getNewObj(_itemVo.bossConfig.fodder + "_LittleHead") as BitmapData;
			bossName.text = _itemVo.name;
			bossColor.gotoAndStop(int(_itemVo.lv / 3) + 1);
			var index:int = _itemVo.lv % 3;
			for(var i:int = 1; i <= 3; i++){
				if(i <= index){
					this["star" + i].gotoAndStop(1);
				}else{
					this["star" + i].gotoAndStop(2);
				}
				
			}
		}
		
		private function get exchangeHead() : Sprite{
			return _layer["ExchangeHead"];
		}
		private function get bossColor() : MovieClip{
			return _layer["BossLv"]["BossColor"];
		}
		private function get star1() : MovieClip{
			return _layer["BossLv"]["Star1"];
		}
		private function get star2() : MovieClip{
			return _layer["BossLv"]["Star2"];
		}
		private function get star3() : MovieClip{
			return _layer["BossLv"]["Star3"];
		}
		private function get bossName() : TextField{
			return _layer["BossName"];
		}
	}
}