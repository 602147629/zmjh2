package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.test.game.Const.MidConst;
	import com.test.game.Modules.MainGame.boss.AttachedDragIcon;
	import com.test.game.Mvc.Vo.AttachInfo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class AttachManager extends Singleton
	{
		
		public function AttachManager()
		{
			super();
		}
		
		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public static function getIns():AttachManager{
			return Singleton.getIns(AttachManager);
		}
		
		
		public function get AttachVos() : Vector.<ItemVo>
		{
			var attachs:Vector.<ItemVo> = new Vector.<ItemVo>();
			var info:AttachInfo = player.attachInfo;
			
			for(var i:int =0 ;i<3;i++){
				if (info.attachArr[i] != -1)
				{
					var model:ItemVo = PackManager.getIns().searchAttachedBossCard(info.attachArr[i]);
					attachs.push(model);
				}
				else
				{
					attachs.push(null);
				}
			}
			return attachs;
		}
		
		
		
		
		/**
		 * 装上附体
		 * @param equip
		 * 
		 */
		public function upAttach(upBoss:ItemVo,index:int) : void
		{
			var downBossId:int;
			var upMid:int = upBoss.mid;
			
			downBossId = player.attachInfo.attachArr[index];			
			/// 卸下附体
			if (downBossId != -1)
			{
				var downBoss:ItemVo = PackManager.getIns().searchAttachedBossCard(downBossId);
				downBoss.mid = upMid;
				downBoss.isEquiped = false;
				downBoss.isAttached = false;
				
			}else{
				player.pack.packUsed -= 1;
			}
			
			player.attachInfo.attachArr[index] = upBoss.id;
			switch (index)
			{
				case 0:
					upBoss.mid = MidConst.ATTACH_FRONT_POSITION;
					break;
				case 1:
					upBoss.mid = MidConst.ATTACH_MIDDLE_POSITION;
					break;
				case 2:
					upBoss.mid = MidConst.ATTACH_BACK_POSITION;
					break;
			}
			
			upBoss.isEquiped = true;
			upBoss.isAttached = true;
			PlayerManager.getIns().updatePropertys();
		}
		
		/**
		 * 交换附体
		 * @param downEquip: 被换的boss
		 * 
		 */		
		public function exchangeAttach(upBossIcon:AttachedDragIcon,downBossIcon:AttachedDragIcon) : void
		{
			var upIndex:int = upBossIcon.index;
			var upBoss:ItemVo = upBossIcon.data;
			var downBoss:ItemVo = downBossIcon.data;
			var downBossId:int;
			
			downBossId = player.attachInfo.attachArr[downBossIcon.index];
			player.attachInfo.attachArr[downBossIcon.index] = upBoss.id;
			switch (downBossIcon.index)
			{
				case 0:
					upBoss.mid = MidConst.ATTACH_FRONT_POSITION;
					break;
				case 1:
					upBoss.mid = MidConst.ATTACH_MIDDLE_POSITION;
					break;
				case 2:
					upBoss.mid = MidConst.ATTACH_BACK_POSITION;
					break;
			}
			
			/// 卸下附体
			if (downBossId != -1)
			{
				player.attachInfo.attachArr[upIndex] = downBossId;
				switch (upIndex)
				{
					case 0:
						downBoss.mid =  MidConst.ATTACH_FRONT_POSITION;
						break;
					case 1:
						downBoss.mid =  MidConst.ATTACH_FRONT_POSITION;
						break;
					case 2:
						downBoss.mid =  MidConst.ATTACH_FRONT_POSITION;
						break;
				}
			}else{
				player.attachInfo.attachArr[upIndex] = -1;
			}
			PlayerManager.getIns().updatePropertys();
		}
		
		
		/**
		 * 卸下附体
		 * @param downEquip: 卸下的装备
		 * 
		 */		
		public function downAttach(downBoss:ItemVo) : void
		{
			player.attachInfo.attachArr[getAttachIndex(downBoss)] = -1;
			player.pack.packUsed += 1;
			downBoss.isAttached = false;
			downBoss.isEquiped = false;
			PackManager.getIns().putDownBoss(downBoss);
		}
		
		
		/**
		 * 获取boss的附体位置   -1未附体  0 前锋  1 中坚 2大将
		 * 
		 * 
		 */		
		public function getAttachIndex(boss:ItemVo) : int
		{
			var index:int = -1;
			for(var i:int=0;i<3;i++){
				if(boss.id == player.attachInfo.attachArr[i]){
					index = i;
				}
			}
			return index;
		}
		

	}
}