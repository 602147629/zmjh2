package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Manager.Keyboard.PlayerKeyboardControl;
	import com.test.game.Const.CharacterType;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.ui.Keyboard;
	
	public class KeyboardManager extends Singleton
	{
		public function KeyboardManager()
		{
			super();
		}
		
		public static function getIns():KeyboardManager{
			return Singleton.getIns(KeyboardManager);
		}
		
		public function get getPlayerKeyBoard() : PlayerKeyboardControl{
			return PlayerKeyboardControl.getIns();
		}
		
		private var _skillList_1:Array = ["H", "U", "I", "O", "L"];
		private var _skillList_2:Array = ["4", "5", "6", "7", "8"];
		public function setButton(playerVo:PlayerVo) : void{
			getPlayerKeyBoard.actionDict[PlayerKeyboardControl.SKILL_1] = [];
			getPlayerKeyBoard.actionDict[PlayerKeyboardControl.SKILL_2] = [];
			getPlayerKeyBoard.actionDict[PlayerKeyboardControl.SKILL_3] = [];
			getPlayerKeyBoard.actionDict[PlayerKeyboardControl.SKILL_4] = [];
			getPlayerKeyBoard.actionDict[PlayerKeyboardControl.SKILL_5] = [];
			getPlayerKeyBoard.actionDict[PlayerKeyboardControl.SKILL_6] = [];
			getPlayerKeyBoard.actionDict[PlayerKeyboardControl.SKILL_7] = [];
			getPlayerKeyBoard.actionDict[PlayerKeyboardControl.SKILL_8] = [];
			getPlayerKeyBoard.actionDict[PlayerKeyboardControl.SKILL_9] = [];
			getPlayerKeyBoard.actionDict[PlayerKeyboardControl.SKILL_10] = [];
			
			if(playerVo.character.characterType == CharacterType.PARTNER_PLAYER
				&& GameSceneManager.getIns().partnerOperate){
				for(var j:int = 0; j < _skillList_1.length; j++){
					if(playerVo.skill["skill_" + _skillList_1[j]] != 0){
						getPlayerKeyBoard.actionDict[playerVo.skill["skill_" + _skillList_1[j]] + 5] = [0, Keyboard["NUMPAD_" + _skillList_2[j]]];
					}
				}
			}else{
				for(var i:int = 0; i < _skillList_1.length; i++){
					if(playerVo.skill["skill_" + _skillList_1[i]] != 0){
						getPlayerKeyBoard.actionDict[playerVo.skill["skill_" + _skillList_1[i]] + 5] = [Keyboard[_skillList_1[i]]];
					}
				}
			}
		}
	}
}