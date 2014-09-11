package com.test.game.Mvc.control.character
{
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.StoryManager;
	
	public class AceAutoFightControl extends AutoFightControl
	{
		public function AceAutoFightControl(player:PlayerEntity)
		{
			super(player);
		}
		
		override public function set startAutoFight(value:Boolean) : void{
			if(_startAutoFight == value) return;
			playerReset();
			keyReset();
			_startAutoFight = value;
			if(myPlayer != null
				&& PlayerManager.getIns().player.autoFightInfo.autoFightCount > NumberConst.getIns().zero
				&& !GameSceneManager.getIns().partnerOperate){
				myPlayer.setAutoFightStatus(_startAutoFight);
			}
		}
		
		override protected function get judgeFightStart() : Boolean{
			var result:Boolean = false;
			result = (_startAutoFight && !StoryManager.getIns().isStoryStart);
			return result;
		}
		
		override protected function judgeEverySecond():void{
			if(myPlayer != null && PlayerManager.getIns().player.autoFightInfo.autoFightCount > NumberConst.getIns().zero){
				myPlayer.setAutoFightStatus(_startAutoFight);
			}
		}
	}
}