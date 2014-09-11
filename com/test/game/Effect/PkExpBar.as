package com.test.game.Effect
{
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class PkExpBar extends RenderEffect
	{
		public function PkExpBar(){
			super();
			AnimationManager.getIns().addEntity(this);
		}
		
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		private var _exp:Sprite;
		private var _nowInfo:Array;
		private var _expStep:int;
		private var _expStart:int;
		private var _expEnd:int;
		private var _isStart:Boolean;
		public function createExpBar(obj:Sprite, addExp:int) : void{
			_exp = obj;
			if(player.pkInfo.isReachMaxLevel){
				_expStart = player.pkInfo.pkExp;
			}else{
				_expStart = player.pkInfo.pkExp - addExp;
			}
			_expEnd = player.pkInfo.pkExp;
			_expStep = addExp / 15;
			_nowInfo = player.pkInfo.getLevelInfo(_expStart);
			if(_nowInfo[2] >= 10){
				(_exp["PKTF"] as TextField).text = "0/0";
				(_exp["PKExpBar"] as Sprite).width = 229;
			}else{
				(_exp["PKTF"] as TextField).text = (_expStart - _nowInfo[0]) + "/" + (_nowInfo[1] - _nowInfo[0]);
				(_exp["PKExpBar"] as Sprite).width = (_expStart - _nowInfo[0]) / (_nowInfo[1] - _nowInfo[0]) * 229;
			}
			setPlayerLv();
		}
		
		override public function step() : void{
			if(_isStart){
				_expStart += _expStep;
				if(_expStart > _expEnd){
					_expStart = _expEnd;
				}
				if(_expStart >= _nowInfo[1]){
					_nowInfo = player.pkInfo.getLevelInfo(_expStart);;
					setPlayerLv();
				}
				if(_nowInfo[2] >= 10){
					(_exp["PKTF"] as TextField).text = "0/0";
					(_exp["PKExpBar"] as Sprite).width = 229;
				}else{
					(_exp["PKTF"] as TextField).text = (_expStart - _nowInfo[0]) + "/" + (_nowInfo[1] - _nowInfo[0]);
					(_exp["PKExpBar"] as Sprite).width = (_expStart - _nowInfo[0]) / (_nowInfo[1] - _nowInfo[0]) * 229;
				}
				if(_expStart == _expEnd){
					_isStart = false;
					this.destroy();
				}
			}
		}
		
		private function setPlayerLv() : void{
			(_exp["PKLv"] as MovieClip).gotoAndStop(_nowInfo[2]);
		}
		
		public function start() : void{
			_isStart = true;
		}
		
		override public function destroy():void{
			_exp = null;
			AnimationManager.getIns().removeEntity(this);
			super.destroy();
		}
	}
}