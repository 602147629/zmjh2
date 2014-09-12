package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.test.game.Modules.MainGame.MainUI.BattleToolBar;
	import com.test.game.Modules.MainGame.MainUI.ExtraBattleToolBar;
	import com.test.game.Mvc.Data.SkillConfigurationVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class BattleUIManager extends Singleton
	{
		public var isStart:Boolean = false;
		public var mainBattleToolBar:BattleToolBar;
		public var partnerBattleToolBar:ExtraBattleToolBar;
		public function BattleUIManager(){
			super();
		}
		
		public static function getIns():BattleUIManager{
			return Singleton.getIns(BattleUIManager);
		}
		
		public function setMainBattleTool(player:PlayerVo, data:SkillConfigurationVo) : void{
			isStart = true;
			if(mainBattleToolBar == null){
				mainBattleToolBar = new BattleToolBar(player);
			}
			mainBattleToolBar.show();
			mainBattleToolBar.setShowInfo(data);
			mainBattleToolBar.setAnger(1);
		}
		
		public function setPartnerBattleTool(player:PlayerVo, data:SkillConfigurationVo) : void{
			isStart = true;
			if(partnerBattleToolBar == null){
				partnerBattleToolBar = new ExtraBattleToolBar(player);
			}
			partnerBattleToolBar.show();
			partnerBattleToolBar.setShowInfo(data);
			partnerBattleToolBar.setAnger(1);
		}
		
		public function step() : void{
			if(isStart){
				if(mainBattleToolBar != null){
					mainBattleToolBar.step();
				}
				if(partnerBattleToolBar != null){
					partnerBattleToolBar.step();
				}
			}
		}
		
		public function show() : void{
			isStart = true;
			if(mainBattleToolBar != null){
				mainBattleToolBar.show();
			}
			if(GameSceneManager.getIns().partnerOperate){
				if(partnerBattleToolBar != null){
					partnerBattleToolBar.show();
				}
			}
		}
		
		public function hide() : void{
			isStart = false;
			if(mainBattleToolBar != null){
				mainBattleToolBar.hide();
			}
			if(partnerBattleToolBar != null){
				partnerBattleToolBar.hide();
			}
		}
		
		public function resetCoolDownTime() : void{
			if(mainBattleToolBar != null){
				mainBattleToolBar.resetCoolDownTime();
			}
			if(partnerBattleToolBar != null){
				partnerBattleToolBar.resetCoolDownTime();
			}
		}
		
		public function clear() : void{
			hide();
			if(mainBattleToolBar != null){
				mainBattleToolBar.destroy();
				mainBattleToolBar = null;
			}
			if(partnerBattleToolBar != null){
				partnerBattleToolBar.destroy();
				partnerBattleToolBar = null;
			}
		}
		
	}
}