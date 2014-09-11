package com.test.game.Mvc.control.character
{
	import com.superkaka.mvc.BmdViewFactory;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Mvc.BmdView.AutoPKSceneView;
	import com.test.game.Mvc.BmdView.LootSceneView;
	
	import flash.geom.Point;
	
	public class PKAutoFightControl extends AutoFightControl
	{
		private var _targetPos:Point = new Point();
		public function PKAutoFightControl(player:PlayerEntity)
		{
			super(player);
		}
		
		private function get targetPlayer() : PlayerEntity{
			if(SceneManager.getIns().sceneType == SceneManager.AUTO_PK_SCENE){
				return (BmdViewFactory.getIns().getView(AutoPKSceneView) as AutoPKSceneView).myPlayer;
			}else if(SceneManager.getIns().sceneType == SceneManager.LOOT_SCENE){
				return (BmdViewFactory.getIns().getView(LootSceneView) as LootSceneView).myPlayer;
			}else{
				return null;
			}
		}
		
		override public function step() : void{
			if(judgeFightStart){
				if(myPlayer != null){
					renderTargetPlayer();
					_stepTime++;
					playerAutoAi();
					playerPressKeyUp();
					playerKeyUp();
					playerSkill();
					playerRun();
					playerWalk();
					playerCommonHit();
					playerJumpHit();
					playerVertical();
				}
			}
		}
		
		private function renderTargetPlayer():void{
			if(_stepTime % 30 == 0){
				_targetPos = targetPlayer.pos;
			}
		}
		
		private var _canStartStep:int;
		override protected function playerAutoAi():void{
			if(targetPlayer != null){
				if(canStartHit()){
					_canStartStep++;
					if(_canStartStep > 15){
						_playerCommonHitStart = true;
					}else{
						_playerRunStart = false;
						keyReset();
					}
				}else{
					_canStartStep = 0;
					setPlayerDirect();
					_playerRunStart = true;
					_playerCommonHitStart = false;
				}
			}
		}
		
		//判断主角的方向
		override protected function setPlayerDirect() : void{
			_changeDirect++;
			if(_changeDirect >= 10){
				if(myPlayer.x > _targetPos.x + 20){
					playerDirect = DIRECT_LEFT;
				}else if(myPlayer.x < _targetPos.x - 20){
					playerDirect = DIRECT_RIGHT;
				}
				_changeDirect = 0;
			}
		}
		
		private function canStartHit():Boolean{
			var result:Boolean = false;
			if(Math.abs(myPlayer.x - _targetPos.x) < 100){
				result = true;
			}
			
			return result;
		}
	}
}