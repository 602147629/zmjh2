package com.test.game.Modules.MainGame.HeroScript
{
	import com.greensock.TweenMax;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class HeroAddValueIcon extends BaseSprite
	{
		private var _obj:Sprite;
		
		public var layerName:String;
		

		private var _lvData:Array;
		
		private var _heroAddValue:int;
		
		private var _totalAddValue:int;
		
		private var _preBarWidth:int;
		
		public function HeroAddValueIcon()
		{
			
			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("HeroUpgradeIcon") as Sprite;
				this.addChild(_obj);
			}

			super();
		}
		
		
		public function setData(value:int) : void{
			_lvData = getAddLv(value);
			lvMc.gotoAndStop(_lvData[2]);
			_totalAddValue = int(player.character.configProperty[layerName]+player.character.levelUpProperty[layerName]+value);
			_heroAddValue = value;
			addValue.text = _totalAddValue.toString();
			curValue.text = (value - _lvData[0]) + "/" + (_lvData[1] - _lvData[0]);
			var curWidth:int = (value - _lvData[0]) / (_lvData[1] - _lvData[0]) * 155;
			_preBarWidth = bar.width;
			if(curWidth<_preBarWidth){
				TweenMax.to(bar,1,{width:155,onComplete:
					function():void{TweenMax.fromTo(bar,1,{width:0},{width:curWidth});}
				});
			}else{
				TweenMax.to(bar,1,{width:curWidth});
			}
		}
		
		public function setUpgradeValue(add:int):int{
			var afterLv:int = getAddLv(_heroAddValue+add)[2];
			if(add>0){
				addValue.text = _totalAddValue.toString() +" + "+add.toString();
			}else{
				addValue.text = _totalAddValue.toString();
			}
			return afterLv;
		}
		
		/**
		 * 获得输入的经验值对应等级的数据
		 * @param exp
		 * @return 
		 * 
		 */		
		public function getAddLv(exp:int) : Array{
			var result:Array = new Array;
			var _heroUpInfo:Array = ConfigurationManager.getIns().getAllData(AssetsConst.HEROUP);
			for(var i:int = 0; i < _heroUpInfo.length; i++){
				if(exp >= _heroUpInfo[i][layerName]){
					continue;
				}else{
					if(i - 1 < 0){
						result.push(0);
					}else{
						result.push(_heroUpInfo[i - 1][layerName]);
					}
					result.push(_heroUpInfo[i][layerName]);
					result.push(i + 1);
					break;
				}
			}
			
			if(result[2] == NumberConst.getIns().ten){
				result = [_heroUpInfo[i-1][layerName], _heroUpInfo[i-1][layerName], NumberConst.getIns().ten];
			}
			return result;
		}
		
		public function get lv():int{
			return _lvData[2];
		}

		private function get lvMc():MovieClip
		{
			return _obj["lv"];
		}
		
		private function get addValue():TextField
		{
			return _obj["addValue"];
		}
		
		private function get curValue():TextField
		{
			return _obj["curValue"];
		}

		private function get bar():Sprite
		{
			return _obj["bar"];
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		

		override public function destroy():void{
			removeComponent(_obj);
			super.destroy();
		}
	}
}