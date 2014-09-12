package com.test.game.Effect
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Manager.Layers.LayerManager;
	
	import flash.display.BitmapData;

	public class GoEffect extends RenderEffect
	{
		private var _obj:BaseNativeEntity;
		private var _isStart:Boolean;
		public function GoEffect(str:String){
			super();
			
			_obj = new BaseNativeEntity();
			_obj.data.bitmapData = AUtils.getNewObj(str) as BitmapData;
		}
		
		private var _stepTime:int;
		//显示次数
		private var _showTime:int = 3;
		//间隔时间
		private var _intervalTime:int = 10;
		override public function step() : void{
			if(_isStart){
				if(_stepTime < _showTime * _intervalTime * 2){
					if(_stepTime % (_intervalTime * 2) == 0){
						_obj.visible = true;
					}else if(_stepTime % _intervalTime == 0){
						_obj.visible = false;
					}
				}else if(_stepTime > _showTime * _intervalTime * 2 * 2){
					_stepTime = -1;
				}
				_stepTime++;
			}
		}
		
		public function start() : void{
			if(_obj.parent == null){
				_isStart = true;
				_stepTime = 0;
				_obj.x = GameConst.stage.stageWidth - _obj.width - 30;
				_obj.y = GameConst.stage.stageHeight * .5 - _obj.height * .5 - 50;
				LayerManager.getIns().gameInfoLayer.addChild(_obj);
			}
		}
		
		public function stop() : void{
			_isStart = false;
			if(_obj.parent != null){
				_obj.parent.removeChild(_obj);
			}
		}
		
		override public function destroy() : void{
			if(_obj != null){
				_obj.destroy();
				_obj = null;
			}
			super.destroy();
		}
	}
}