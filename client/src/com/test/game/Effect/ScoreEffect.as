package com.test.game.Effect
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.ResourceOperation.BitmapDataPool;
	import com.superkaka.mvc.Vo.SequenceVo;
	
	import flash.display.Sprite;

	public class ScoreEffect extends RenderEffect
	{
		private var _digitalLayer:BaseNativeEntity;
		private var _digitalNum:Vector.<BaseSequenceActionBind>;
		private var _score:int;
		private var _nowScore:int;
		private var _layer:Sprite;
		private var _stepTime:int = 15;
		private var _isStart:Boolean = false;
		public function ScoreEffect()
		{
			super();
		}
		
		public function createScore(count:int, layer:Sprite) : ScoreEffect{
			_score = count;
			_layer = layer;
			_nowScore = 0;
			
			var len:int = (_score.toString()).length;
			_digitalLayer = new BaseNativeEntity();
			_digitalLayer.x = 0;
			_digitalLayer.y = 0;
			
			BitmapDataPool.registerData("Score", false);
			var vo:SequenceVo = new SequenceVo();
			vo.sequenceId = 10001;
			vo.assetsArray = ["Score"];
			vo.isDouble = false;
			_digitalNum = new Vector.<BaseSequenceActionBind>();
			for(var i:int = 0; i < len; i++){
				var digital:BaseSequenceActionBind = new BaseSequenceActionBind(vo);
				digital.setAction(ActionState.DIGITAL0);
				_digitalNum.push(digital);
			}
			
			return this;
		}
		
		override public function step():void{
			if(_isStart){
				_nowScore += ((_score / _stepTime) < 1?1:(_score / _stepTime));
				if(_nowScore >= _score){
					_nowScore = _score;
				}
				showDigital(_nowScore);
				if(_nowScore == _score){
					_isStart = false;
				}
			}
		}
		
		public function start() : void{
			_isStart = true;
		}
		
		public function showDigital(count:int):void{
			if(count < 0){
				for each(var item:BaseSequenceActionBind in _digitalNum){
					if(item.parent != null){
						item.parent.removeChild(item);
					}
					if(_digitalLayer.parent != null){
						_digitalLayer.parent.removeChild(_digitalLayer);
					}
				}
			}else{
				var len:int = (count.toString()).length;
				var str:String;
				for(var i:int = 0; i < _digitalNum.length; i++){
					if(i < len){
						str = count.toString().substr(len - i - 1, 1)
						_digitalNum[i].x = - (i + 1) * 20;
						_digitalNum[i].setAction(ActionState["DIGITAL" + str]);
						_layer.addChild(_digitalNum[i]);
					}
				}
				if(_digitalLayer.parent == null){
					_layer.addChild(_digitalLayer);
				}
			}
		}
		
		public function setLast() : void{
			_nowScore = _score;
		}
		
		override public function destroy() : void{
			for(var i:int = 0; i < _digitalNum.length; i++){
				if(_digitalNum[i] != null){
					_digitalNum[i].destroy();
					_digitalNum[i] = null
				}
			}
			_digitalNum.length = 0;
			_digitalNum = null;
			if(_digitalLayer != null){
				_digitalLayer.destroy();
				_digitalLayer = null;
			}
			super.destroy();
		}
	}
}