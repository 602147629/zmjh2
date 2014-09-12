package com.test.game.Mvc.control.character
{
	import com.superkaka.mvc.BmdViewFactory;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Monsters.EscortEntity;
	import com.test.game.Manager.AutoFightManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Mvc.BmdView.LootSceneView;
	
	import flash.geom.Point;
	
	public class EscortAutoFightControl extends AutoFightControl
	{
		private var _targetPos:Point = new Point();
		private function get escortPlayer() : PlayerEntity{
			if(SceneManager.getIns().sceneType == SceneManager.LOOT_SCENE){
				return (BmdViewFactory.getIns().getView(LootSceneView) as LootSceneView).myPlayer;
			}else{
				return null;
			}
		}
		
		private function get biaoChe() : EscortEntity{
			if(SceneManager.getIns().sceneType == SceneManager.LOOT_SCENE){
				return (BmdViewFactory.getIns().getView(LootSceneView) as LootSceneView).convoys[0];
			}else{
				return null;
			}
		}
		
		public function EscortAutoFightControl(player:PlayerEntity)
		{
			super(player);
		}
		
		override protected function get canFightJudge():Boolean{
			var result:Boolean = false;
			var intervalLittle:int = 1000;
			intervalLittle = Math.abs(myPlayer.x - _target.x);
			if(myPlayer.x < _target.x){
				playerDirect =  AutoFightManager.getIns().DIRECT_RIGHT;
			}else{
				playerDirect =  AutoFightManager.getIns().DIRECT_LEFT;
			}
			if(intervalLittle < 150){
				result = true;
			}else{
				result = false;
			}
			return result;
		}
		
		override protected function get judgeFightStart() : Boolean{
			var result:Boolean = false;
			var interval:int = 10000;
			if(EscortEntity != null && biaoChe != null){
				interval = Math.abs(escortPlayer.x - biaoChe.x);
			}
			result = _startAutoFight && interval<800;
			return result;
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
					if(_stepTime == 30){
						judgeMonster();
						judgeEverySecond();
						_stepTime = 0;
					}
				}
			}else{
				otherMoveStep();
			}
		}
		
		
		private function renderTargetPlayer():void{
			if(_stepTime % 30 == 0){
				_targetPos = escortPlayer.pos;
			}
		}
		
		
		private var _canStartStep:int;
		override protected function playerAutoAi():void{
			if(escortPlayer != null){
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
					setPKPlayerDirect();
					_playerRunStart = true;
					_playerCommonHitStart = false;
				}
			}
		}
		
		//判断主角的方向
		protected function setPKPlayerDirect() : void{
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
		
		override protected function otherMoveStep():void{
			if(myPlayer != null && _target != null){
				_stepTime++;
				setPlayerDirect();
				playerPressKeyUp();
				playerKeyUp();
				playerRun();
				playerWalk();
				if(_stepTime == 30){
					judgeEscort();
					_stepTime = 0;
				}
			}
		}
		
		private function judgeEscort():void{
			_target = null;
			if(biaoChe != null){
				_target = biaoChe;
			}
		}
		
		override protected function checkTarget() : void{
			if(escortPlayer != null){
				if(escortPlayer.charData.useProperty.hp > 0){
					_target = escortPlayer;
				}
			}
		}
	}
}