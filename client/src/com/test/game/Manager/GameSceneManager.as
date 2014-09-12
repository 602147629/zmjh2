package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.test.game.Const.CharacterType;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Roles.KuangWuEntity;
	import com.test.game.Entitys.Roles.XiaoYaoEntity;
	import com.test.game.Mvc.control.key.role.KuangWuActionControl;
	import com.test.game.Mvc.control.key.role.KuangWuSimpleActionControl;
	import com.test.game.Mvc.control.key.role.XiaoYaoActionControl;
	import com.test.game.Mvc.control.key.role.XiaoYaoSimpleActionControl;
	
	public class GameSceneManager extends Singleton
	{
		public var partnerOperate:Boolean = false;
		public function GameSceneManager()
		{
			super();
		}
		
		public static function getIns():GameSceneManager{
			return Singleton.getIns(GameSceneManager);
		}
		
		public function clear() : void{
			partnerOperate = false;
		}
		
		//普通关卡角色动作控制
		public function gameScenePlayerControl(player:PlayerEntity) : void{
			var playerType:int;
			if(GameSceneManager.getIns().partnerOperate){
				if(player.charData.characterType == CharacterType.PARTNER_PLAYER){
					playerType = GameConst.PLAYER_2;
				}else{
					playerType = GameConst.PLAYER_1;
				}
			}else{
				playerType = GameConst.PLAYER_1;
			}
			if(player is KuangWuEntity){
				if(GameSettingManager.getIns().operateMode == GameSettingManager.NORMAL_OPERATE){
					KuangWuActionControl.getIns().controlPlayer(player, playerType);
				}else if(GameSettingManager.getIns().operateMode == GameSettingManager.SIMPLE_OPERATE){
					KuangWuSimpleActionControl.getIns().controlPlayer(player, playerType);
				}
			}else if(player is XiaoYaoEntity){
				if(GameSettingManager.getIns().operateMode == GameSettingManager.NORMAL_OPERATE){
					XiaoYaoActionControl.getIns().controlPlayer(player, playerType);
				}else if(GameSettingManager.getIns().operateMode == GameSettingManager.SIMPLE_OPERATE){
					XiaoYaoSimpleActionControl.getIns().controlPlayer(player, playerType);
				}
			}
			player.keyBoard.step();
		}
		
		//其他单机副本角色动作控制
		public function singleScenePlayerControl(player:PlayerEntity) : void{
			if(player is KuangWuEntity){
				if(GameSettingManager.getIns().operateMode == GameSettingManager.NORMAL_OPERATE){
					KuangWuActionControl.getIns().controlPlayer(player, GameConst.PLAYER_1);
				}else if(GameSettingManager.getIns().operateMode == GameSettingManager.SIMPLE_OPERATE){
					KuangWuSimpleActionControl.getIns().controlPlayer(player, GameConst.PLAYER_1);
				}
			}else if(player is XiaoYaoEntity){
				if(GameSettingManager.getIns().operateMode == GameSettingManager.NORMAL_OPERATE){
					XiaoYaoActionControl.getIns().controlPlayer(player, GameConst.PLAYER_1);
				}else if(GameSettingManager.getIns().operateMode == GameSettingManager.SIMPLE_OPERATE){
					XiaoYaoSimpleActionControl.getIns().controlPlayer(player, GameConst.PLAYER_1);
				}
			}
			player.keyBoard.step();
		}
		
		//pk副本角色动作控制
		public function pkScenePlayerControl(player:PlayerEntity) : void{
			if(player is KuangWuEntity){
				if(player.player.operateMode == GameSettingManager.NORMAL_OPERATE){
					KuangWuActionControl.getIns().controlPlayer(player, GameConst.PLAYER_1);
				}else if(player.player.operateMode == GameSettingManager.SIMPLE_OPERATE){
					KuangWuSimpleActionControl.getIns().controlPlayer(player, GameConst.PLAYER_1);
				}
			}else if(player is XiaoYaoEntity){
				if(player.player.operateMode == GameSettingManager.NORMAL_OPERATE){
					XiaoYaoActionControl.getIns().controlPlayer(player, GameConst.PLAYER_1);
				}else if(player.player.operateMode == GameSettingManager.SIMPLE_OPERATE){
					XiaoYaoSimpleActionControl.getIns().controlPlayer(player, GameConst.PLAYER_1);
				}
			}
			player.keyBoard.step();
		}
		
	}
}