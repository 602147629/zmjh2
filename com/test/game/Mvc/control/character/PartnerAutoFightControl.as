package com.test.game.Mvc.control.character
{
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.StoryManager;
	
	public class PartnerAutoFightControl extends AutoFightControl
	{
		private var _partnerStart:Boolean;
		private function get partnerStart() : Boolean{
			return _partnerStart;
		}
		private function set partnerStart(value:Boolean) : void{
			if(_partnerStart == value)	return;
			playerReset();
			keyReset();
			_partnerStart = value;
		}
		
		private function get partnerPlayer() : PlayerEntity{
			if(SceneManager.getIns().isTwoPlayerScene){
				return SceneManager.getIns().partnerPlayer;
			}else{
				return null;
			}
		}
		
		private function get thisMonsters() : Vector.<MonsterEntity>{
			if(SceneManager.getIns().isTwoPlayerScene){
				return SceneManager.getIns().monsters;
			}else{
				return null;
			}
		}
		
		private function get nowIndex() : int{
			return LevelManager.getIns().nowMonsterIndex;
		}
		
		private function get nowStart() : int{
			return LevelManager.getIns().nowMonsterStart;
		}
		
		public function PartnerAutoFightControl(player:PlayerEntity)
		{
			super(player);
			
			isReleaseBoss = false;
		}
		
		override protected function get judgeFightStart() : Boolean{
			if(SceneManager.getIns().sceneType == SceneManager.HERO_SCENE
				|| SceneManager.getIns().sceneType == SceneManager.FUNNY_SCENE){
				partnerStart = _startAutoFight;
			}else{
				partnerStart = (_startAutoFight 
					&& !StoryManager.getIns().isStoryStart
					&& !(thisMonsters.length == 0 && partnerPlayer.x > nowStart - 100 && nowIndex != 0));
			}
			return partnerStart;
		}
	}
}