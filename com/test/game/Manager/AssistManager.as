package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.MidConst;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class AssistManager extends Singleton
	{

		public function AssistManager()
		{
			super();
		}
		
		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public static function getIns():AssistManager{
			return Singleton.getIns(AssistManager);
		}
		
		public function get AssistVo() :ItemVo
		{
			var model:ItemVo;
			if (player.assistInfo != -1)
			{
				model = PackManager.getIns().searchAssistedBossCard(player.assistInfo);
			}

			return model;
		}
		
		/**
		 * 装上支援
		 * @param equip
		 * 
		 */
		public function upAssist(upBoss:ItemVo) : void
		{
			var downBossId:int;

			downBossId = player.assistInfo;
			player.assistInfo = upBoss.id;
			
			/// 卸下原有的支援
			if (downBossId != -1)
			{
				var downBoss:ItemVo = PackManager.getIns().searchAssistedBossCard(downBossId);
				downBoss.mid = upBoss.mid;
				downBoss.isEquiped = false;
				downBoss.isAssisted = false;
				
			}else{
				player.pack.packUsed -= 1;
			}
			
			upBoss.isEquiped = true;
			upBoss.isAssisted = true;
			upBoss.mid = MidConst.ASSIST_POSIOTION;
			PlayerManager.getIns().updatePropertys();
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).resetState();
		}
		
		/**
		 * 卸下支援
		 * @param downAssist: 卸下的boss
		 * 
		 */		
		public function downAssist(downBoss:ItemVo) : void
		{
			player.assistInfo = -1;
			player.pack.packUsed += 1;
			downBoss.isAssisted = false;
			PackManager.getIns().putDownBoss(downBoss);
			
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).resetState();
		}
		
		

		
		
	}
}