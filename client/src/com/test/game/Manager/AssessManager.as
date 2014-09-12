package com.test.game.Manager
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.LimitConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.PublicNoticeType;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Modules.MainGame.LevelInfoView;
	
	public class AssessManager extends Singleton{
		private var _anti:Antiwear;
		//两次连击之间最大间隔帧数
		private var _intervalCombo:int = 90;
		//计数
		private var _nowComboStep:int;
		private var _levelTimeCount:int;
		
		public function AssessManager(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["lastCombo"] = 0;
			_anti["comboCount"] = 0;
			_anti["comboTenDeathCount"] = 0;
			_anti["allDeathCount"] = 0;
			_anti["allHurtCount"] = 0;
			_anti["reliveCount"] = 0;
		}
		
		public static function getIns():AssessManager{
			return Singleton.getIns(AssessManager);
		}
		
		public function step() : void{
			if(_nowComboStep > 0){
				_nowComboStep--;
				GameProcessManager.getIns().setBarMask(_nowComboStep / _intervalCombo);
				if(_nowComboStep <= 0 && comboCount != 0){
					GameProcessManager.getIns().addComboAssess(comboCount);
					comboCount = 0;
				}
			}
		}
		
		//怪物死亡数
		public function addMonsterDeath() : void{
			if(comboCount >= 10){
				comboTenDeathCount++;
			}
			allDeathCount++;
		}
		
		//增加连击数
		public function addCombo() : void{
			if(SceneManager.getIns().hasComboScene){
				_nowComboStep = _intervalCombo;
				comboCount++;
				if(comboCount == LimitConst.MAX_COMBO){
					PublicNoticeManager.getIns().sendPublicNotice(PublicNoticeType.SUPER_COMBO, LevelManager.getIns().levelData.level_name);
				}
				if(comboCount >= lastCombo){
					lastCombo = comboCount;
				}
			}
		}
		
		public function clear() : void{
			lastCombo = NumberConst.getIns().zero;
			comboCount = NumberConst.getIns().zero;
			comboTenDeathCount = NumberConst.getIns().zero;
			reliveCount = NumberConst.getIns().zero;
			allDeathCount = NumberConst.getIns().zero;
		}
		
		//当前连击数
		public function set comboCount(value:int) : void{
			_anti["comboCount"] = value;
			GameProcessManager.getIns().showDigital(comboCount);
		}
		public function get comboCount() : int{
			return _anti["comboCount"];
		}
		
		//最大连击数
		public function set lastCombo(value:int) : void{
			/*if(value > LimitConst.MAX_COMBO){
				value = LimitConst.MAX_COMBO;
			}*/
			_anti["lastCombo"] = value;
		}
		public function get lastCombo() : int{
			return _anti["lastCombo"];
		}
		
		//连击超过十次死亡的怪
		public function set comboTenDeathCount(value:int) : void{
			_anti["comboTenDeathCount"] = value;
		}
		public function get comboTenDeathCount() : int{
			return _anti["comboTenDeathCount"];
		}
		
		//总共死亡的怪物数
		public function set allDeathCount(value:int) : void{
			_anti["allDeathCount"] = value;
		}
		public function get allDeathCount() : int{
			return _anti["allDeathCount"];
		}
		
		//复活次数
		public function set reliveCount(value:int) : void{
			_anti["reliveCount"] = value;
		}
		public function get reliveCount() : int{
			return _anti["reliveCount"];
		}
		
		//最终评价分数
		public function lastScore() : int{
			var result:int = 0;
			result = comboScore() + levelTimeScore() + playerHurtScore() + extraScore();
			return result;
		}
		
		//评价等级
		public function assessLevel() : int{
			var result:int = NumberConst.getIns().one;
			var score:int = lastScore();
			if(score < 7000){
				result = NumberConst.getIns().one;
			}else if(score >= 7000 && score < 10000){
				result = NumberConst.getIns().two;
			}else if(score >= 10000 && score < 13000){
				result = NumberConst.getIns().three;
			}else if(score >= 13000 && score < 16000){
				result = NumberConst.getIns().four;
			}else if(score == 16000){
				result = NumberConst.getIns().five;
			}
			return result;
		}
		
		// 连击分数
		private function comboScore() : int{
			var result:int = 0;
			if(lastCombo <= 20){
				result = 0;
			}else if(lastCombo > 20 && lastCombo <= 40){
				result = 1000;
			}else if(lastCombo > 40 && lastCombo <= 60){
				result = 2000;
			}else if(lastCombo > 60 && lastCombo < 100){
				result = 3000;
			}else{
				result = 4000;
			}
			return result;
		}
		
		//过关时间
		private function levelTimeScore() : int{
			var result:int;
			var timeCount:int = levelTimeCount;
			if(timeCount <= 2 * 60){
				result = 4000;
			}else if(timeCount > 2 * 60 && timeCount <= 6 * 60){
				result = 3000;
			}else if(timeCount > 6 * 60 && timeCount <= 8 * 60){
				result = 2000;
			}else if(timeCount > 8 * 60 && timeCount <= 10 * 60){
				result = 1000;
			}else{
				result = 0;
			}
			return result;
		}
		
		public function get levelTimeCount() : int{
			return (ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).levelTimeEffect.levelTime;
		}
		
		public function playerHurt() : int{
			var result:int;
			var player:PlayerEntity = SceneManager.getIns().myPlayer;
			result = player.charData.allHurtCount;
			return result;
		}
		
		public function playerHurtScore() : int{
			var result:int;
			var hurt:int = 0;
			var all:int = 0;
			var player:PlayerEntity = SceneManager.getIns().myPlayer;
			hurt = player.charData.allHurtCount;
			all = player.charData.totalProperty.hp;
			var rate:Number = hurt / all;
			if(rate == 0){
				result = 2 * 2 * 10 * 10 * 10;
			}else if(rate <= .1){
				result = 3 * 10 * 10 * 10;
			}else if(rate > .1 && rate <= .5){
				result = 2 * 10 * 10 * 10;
			}else if(rate > .5 && rate < 1){
				result = 1 * 10 * 10 * 10;
			}else if(rate >= 1){
				result = 0;
			}
			return result;
		}
		
		public function extraScore() : int{
			var result:int;
			result = (comboTenDeathCount / allDeathCount) * 2000 + 2000 - (reliveCount > 4?4:reliveCount) * 500;
			return result;
		}
		
	}
}