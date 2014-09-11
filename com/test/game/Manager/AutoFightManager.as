package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AutoFightConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	
	public class AutoFightManager extends Singleton
	{
		
		public const DIRECT_UP:uint = 0;
		public const DIRECT_DOWN:uint = 1;
		public const DIRECT_LEFT:uint = 2;
		public const DIRECT_RIGHT:uint = 3;
		
		//自动战斗类型
		private var _autoType:int = 0;
		public function get autoType() : int{
			return _autoType;
		}
		public function set autoType(value:int) : void{
			_autoType = value;
		}
		
		//开始自动战斗
		private var _startAutoFight:Boolean = false;
		public function get startAutoFight() : Boolean{
			return _startAutoFight;
		}
		public function set startAutoFight(value:Boolean) : void{
			_startAutoFight = value;
			
		}
		public function AutoFightManager(){
			super();
		}
		
		public function get player() : PlayerEntity{
			if(SceneManager.getIns().nowScene != null){
				return SceneManager.getIns().myPlayer;
			}else{
				return null;
			}
		}
		
		public static function getIns():AutoFightManager{
			return Singleton.getIns(AutoFightManager);
		}
		
		public function step() : void{
			if(player != null && player.autoFightControl != null){
				judgeBoss();
				player.autoFightControl.startAutoFight = _startAutoFight;
				player.autoFightControl.autoType = _autoType;
			}
		}
		
		private function judgeBoss():void{
			if(_autoType == AutoFightConst.AUTO_TYPE_NORMAL){
				if(player.x > 3300){
					startAutoFight = false;
					(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).renderAutoFightBtn();
					(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).autoFightBtn.mouseEnabled = false;
					GreyEffect.change((ViewFactory.getIns().getView(RoleStateView) as RoleStateView).autoFight);
				}
			}
		}
		
		public function playerReset() : void{
			if(_startAutoFight && player != null && player.autoFightControl != null){
				player.autoFightControl.playerReset();
			}
		}
		
		public function clear() : void{
			startAutoFight = false;
		}
	}
}