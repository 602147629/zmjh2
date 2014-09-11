package com.test.game.Effect
{
	import com.superkaka.mvc.ControlFactory;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.control.View.PlayerUIControl;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class ExpBar extends RenderEffect
	{
		public function ExpBar(){
			super();
		}
		
		private var _exp:Sprite;
		private var _nowInfo:Array;
		private var _expStep:int;
		private var _expStart:int;
		private var _expEnd:int;
		private var _isStart:Boolean;
		public function createExpBar(obj:Sprite, addExp:int) : void{
			_exp = obj;
			if(PlayerManager.getIns().isReachMaxLevel){
				_expStart = PlayerManager.getIns().player.exp;
			}else{
				_expStart = PlayerManager.getIns().player.exp - addExp;
			}
			_expEnd = PlayerManager.getIns().player.exp;
			_expStep = addExp / 15;
			_nowInfo = PlayerManager.getIns().getLevelInfo(_expStart);
			(_exp["ExpTF"] as TextField).text = (_expStart - _nowInfo[0]) + "/" + (_nowInfo[1] - _nowInfo[0]);
			(_exp["ExpBar"] as Sprite).width = (_expStart - _nowInfo[0]) / (_nowInfo[1] - _nowInfo[0]) * 229;
			setPlayerLv();
		}
		
		override public function step() : void{
			if(_isStart){
				_expStart += _expStep;
				if(_expStart > _expEnd){
					_expStart = _expEnd;
				}
				if(_expStart >= _nowInfo[1]){
					_nowInfo = PlayerManager.getIns().getLevelInfo(_expStart);
					setPlayerLv();
					if(_expStart != _expEnd){
						(ControlFactory.getIns().getControl(PlayerUIControl) as PlayerUIControl).playerLevelUp();
					}
				}
				(_exp["ExpTF"] as TextField).text = (_expStart - _nowInfo[0]) + "/" + (_nowInfo[1] - _nowInfo[0]);
				(_exp["ExpBar"] as Sprite).width = (_expStart - _nowInfo[0]) / (_nowInfo[1] - _nowInfo[0]) * 229;
				
				if(_expStart == _expEnd){
					_isStart = false;
					this.destroy();
				}
			}
		}
		
		private function setPlayerLv() : void{
			if(_nowInfo[2] < 10){
				_exp["Lv_1"].x = 10;
				(_exp["Lv_1"] as MovieClip).gotoAndStop(_nowInfo[2] + 1);
				(_exp["Lv_2"] as MovieClip).visible = false;
				(_exp["Lv_2"] as MovieClip).stop();
			}else{
				_exp["Lv_1"].x = 5;
				(_exp["Lv_1"] as MovieClip).gotoAndStop(int(_nowInfo[2] / 10 + 1));
				(_exp["Lv_2"] as MovieClip).visible = true;
				(_exp["Lv_2"] as MovieClip).gotoAndStop(int(_nowInfo[2] % 10 + 1));
			}
		}
		
		public function start() : void{
			_isStart = true;
		}
		
		override public function destroy():void{
			_exp = null;
			super.destroy();
		}
	}
}