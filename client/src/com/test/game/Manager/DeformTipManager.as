package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.DeformConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Mvc.Configuration.MainMission;
	import com.test.game.Mvc.Configuration.Strengthen;
	import com.test.game.Mvc.Vo.EliteDungeonPassVo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class DeformTipManager extends Singleton
	{
		private var _deformTipControll:Boolean = true;
		public function DeformTipManager(){
			super();
		}
		
		public static function getIns():DeformTipManager{
			return Singleton.getIns(DeformTipManager);
		}
		
		public function get player():PlayerVo{
			return PlayerManager.getIns().player;	
		}
		
		public function get deformTipControll() : Boolean{
			return _deformTipControll;
		}
		public function set deformTipControll(value:Boolean) : void{
			_deformTipControll = value;
			setDeformTip();
		}
		
		public function setDeformTip() : void{
			if(_deformTipControll){
				allCheck();
			}else{
				allClose();
			}
		}
		
		public function allClose():void{
			DeformManager.getIns().removeDeform(DeformConst.GIFT_PART);
			DeformManager.getIns().removeDeform(DeformConst.MISSION_PART);
			DeformManager.getIns().removeDeform(DeformConst.SKILL_PART);
			DeformManager.getIns().removeDeform(DeformConst.STRENGTHEN_PART);
			DeformManager.getIns().removeDeform(DeformConst.SUMMON_PART);
			DeformManager.getIns().removeDeform(DeformConst.ELITE_PART);
			DeformManager.getIns().removeDeform(DeformConst.FIRST_CHARGE);
			DeformManager.getIns().removeDeform(DeformConst.ACHIEVE);
		}
		
		private var _mainTool:MainToolBar;
		private var _extra:ExtraBar;
		public function allCheck() : void{
			if(_deformTipControll){
				_mainTool = ViewFactory.getIns().getView(MainToolBar) as MainToolBar;
				_extra = ViewFactory.getIns().getView(ExtraBar) as ExtraBar;
				if(_mainTool == null || _extra == null) return;
				checkMissionDeform();
				checkStrengthenDeform();
				checkSkillDeform();
				checkBossDeform();
				checkEliteDeform();
				checkGiftDeform();
				checkAchieve();
				//checkFirstCharge();
				
			}
		}
		
		
		private function get getGiftNum():int{
			var num:int;
			for(var i:int=0;i<player.gift.length;i++){
				if(player.gift[i].id != NumberConst.getIns().jiangHuGiftId
					&& player.gift[i].id != NumberConst.getIns().guiZuGiftId
					&& player.gift[i].id != NumberConst.getIns().fiveYearsGiftId
					&& player.gift[i].id != NumberConst.getIns().tenYearsGiftId){
					num++;
				}
			}
			return num;
		}
		
		
		public function checkAchieve():Boolean{
			var result:Boolean = false;
			if(_deformTipControll){
				for(var i:int=0;i<player.achieveArr.length;i++){
					if(int(player.achieveArr[i])==NumberConst.getIns().zero){
						result = true;
					}
				}
				if(result){
					DeformManager.getIns().addNewDeform(_mainTool.achieve, DeformConst.ACHIEVE);
				}else{
					DeformManager.getIns().removeDeform(DeformConst.ACHIEVE);
				}
			}
			return result;
		}
		
		public function checkFirstCharge():Boolean{
			var result:Boolean = false;
			if(_deformTipControll){
				if(player.vip.firstCharge!=NumberConst.getIns().one){
					result = true;
				}
				if(result){
					DeformManager.getIns().addNewDeform(_mainTool.firstCharge, DeformConst.FIRST_CHARGE);
				}else{
					DeformManager.getIns().removeDeform(DeformConst.FIRST_CHARGE);
				}
			}
			return result;
		}
		
		public function checkGiftDeform():Boolean{
			if(_extra == null) return false;
			var result:Boolean = false;
			var curNum:int = getGiftNum;
			var totalGiftNum:int = NumberConst.getIns().giftIdArray.length-3;//不算上积分礼包
			if(_deformTipControll){
				if(curNum < totalGiftNum){
					var diff:int = totalGiftNum - curNum;
					var num:int;
					if(!TimeManager.getIns().checkDate(NumberConst.getIns().returnGiftDate)){
						num++;
					}
					
					if(!TimeManager.getIns().checkDate(NumberConst.getIns().wuYiGiftDate)){
						num++;
					}
					
					if(diff == num){
						result = false;
					}else{
						result = true;
					}
				}
				
/*				if(result){
					DeformManager.getIns().addNewDeform(_extra.giftObj, DeformConst.GIFT_PART);
				}else{
					DeformManager.getIns().removeDeform(DeformConst.GIFT_PART);
				}*/
			}
			return result;
		}
		
		public function checkMissionDeform():Boolean{
			var result:Boolean = false;
			if(_deformTipControll){
				var missionData:MainMission = ConfigurationManager.getIns().getObjectByID(
					AssetsConst.MAIN_MISSION,player.mainMissionVo.id) as MainMission;
				if(missionData.lv <= player.character.lv
					|| DailyMissionManager.getIns().isDailyMissionStart
					|| checkHideMission){
					result = true;
				}
				if(result){
					DeformManager.getIns().addNewDeform(_mainTool.misssionObj, DeformConst.MISSION_PART);
				}else{
					DeformManager.getIns().removeDeform(DeformConst.MISSION_PART);
				}
			}
			return result;
		}
		
		private function get checkHideMission() : Boolean{
			var result:Boolean = false;
			for(var i:int = 0; i < player.hideMissionInfo.length; i++){
				if(player.hideMissionInfo[i].isComplete == true
					&& player.hideMissionInfo[i].isShow == true){
					result = true;
				}
			}
			return result;
		}
		
		public function checkSkillDeform():Boolean{
			var result:Boolean = false;
			if(_deformTipControll){
				var skillInfo:Array = SkillManager.getIns().getSkillInfo(PlayerManager.getIns().player.occupation);
				var player:PlayerVo = PlayerManager.getIns().player;
				if(player.skill.kungfu1 < 5 && player.soul >= skillInfo[player.skill.kungfu1].soul){
					result = true;
				}
				if(player.skill.kungfu2 < 5 && player.soul >= skillInfo[player.skill.kungfu2 + 5].soul){
					result = true;
				}
				//是否学满5个技能
				var count:int = 0;
				for(var i:int = 0; i < player.skill.skillArr.length; i++){
					if(player.skill.skillArr[i] == 1){
						count++;
					}
				}
				if(count == 5){
					result = false;
				}
				
				if(result){
					DeformManager.getIns().addNewDeform(_mainTool.skillObj, DeformConst.SKILL_PART);
				}else{
					DeformManager.getIns().removeDeform(DeformConst.SKILL_PART);
				}
			}
			return result;
		}
		
		public function checkStrengthenDeform():Boolean{
			var result:Boolean = false;
			if(_deformTipControll){
				for each (var equip:ItemVo in EquipedManager.getIns().EquipedVos){
					if(checkForge(equip) || checkStrengthen(equip)){
						result = true;
						break;
					}
				}
				if(result){
					DeformManager.getIns().addNewDeform(_mainTool.strengthenObj, DeformConst.STRENGTHEN_PART);
				}else{
					DeformManager.getIns().removeDeform(DeformConst.STRENGTHEN_PART);
				}
			}
			return result;
		}
		
		public function checkBossDeform():Boolean{
			var result:Boolean = false;
			if(_deformTipControll){
				for each(var bossData:ItemVo in PackManager.getIns().curBossCardData){
					if(checkSummon(bossData)){
						result = true;
						break;
					}
				}
				
				/*			for each(var packBossData:ItemVo in player.pack.boss){
				if(checkUpgrade(packBossData)){
				result = true;
				break;
				}
				}*/
				if(result){
					DeformManager.getIns().addNewDeform(_mainTool.summonObj, DeformConst.SUMMON_PART);
				}else{
					DeformManager.getIns().removeDeform(DeformConst.SUMMON_PART);
				}
			}
			return result;
		}
		
		public function checkEliteDeform():Boolean{
			var result:Boolean = false;
			if(_deformTipControll){
				for each(var elitePass:EliteDungeonPassVo in player.eliteDungeon.eliteDungeonPass){
					if(elitePass.num == 0){
						result = true;
						break;
					}
				}
				if(result){
					DeformManager.getIns().addNewDeform(_extra.eliteObj, DeformConst.ELITE_PART);
				}else{
					DeformManager.getIns().removeDeform(DeformConst.ELITE_PART);
				}
			}
			return result;
		}
		
		public function checkStrengthen(data:ItemVo):Boolean{
			var result:Boolean = true;
			
			if(data==null){
				return false;
			}
			
			var nextStrengthenData:Strengthen=
				ConfigurationManager.getIns().getObjectByID(AssetsConst.STRENGTHEN,data.lv+1) as Strengthen
			
			
			if(data.lv+1>PlayerManager.getIns().player.character.lv){
				result = false;
			}
			
			if(PackManager.getIns().searchItemNum(nextStrengthenData.stoneId)<nextStrengthenData.stoneNum){
				result = false;
			}
			
			if(!PlayerManager.getIns().checkNumber("money",nextStrengthenData.money_add)){
				result = false;
			}
			
			return result;
		}
		
		
		public function checkForge(data:ItemVo):Boolean{
			var result:Boolean = true;
			
			if(data==null){
				return false;
			}
			
			var materials:Array = data.equipConfig.need_material.split("|");
			var materialNumList:Array = data.equipConfig.material_number.split("|");
			
			if(PackManager.getIns().searchItemNum(data.equipConfig.need_book)==0){
				result = false;
			}
			
			if(PackManager.getIns().searchItemNum(materials[0])<materialNumList[0]){
				result = false;
			}
			
			if(PackManager.getIns().searchItemNum(materials[1])<materialNumList[1]){
				result = false;
			}
			
			if(!PlayerManager.getIns().checkNumber("soul",data.equipConfig.need_soul)){
				result = false;
			}
			
			return result;
		}
		
		public function checkSummon(data:ItemVo):Boolean{
			var result:Boolean = true;
			
			if(data==null){
				return false;
			}
			
			var pieceId:int = data.id - 10000 + 9000;
			
			if(PackManager.getIns().searchItemNum(pieceId) < NumberConst.getIns().summonBossCost){
				result = false;
			}
			
			return result;
		}
		
		
		

		
		public function checkUpgrade(data:ItemVo):Boolean{
			var result:Boolean = true;
			
			if(!checkCard(data)){
				result = false;
			}
			
			if(!checkMaterial(data)){
				result = false;
			}
			
			if(!PlayerManager.getIns().checkNumber("money",data.bossUp.up_money)){
				result = false;
			}
			
			if(!PlayerManager.getIns().checkNumber("soul",data.bossUp.up_soul)){
				result = false;
			}
			
			return result;
		}
		
		private function checkMaterial(data:ItemVo):Boolean{
			var result:Boolean;
			
			var materials:Array = data.bossUp.up_material.split("|");
			var materialNumList:Array = data.bossUp.up_number.split("|");
			
			for(var i:int = 0;i<materials.length;i++){
				if(PackManager.getIns().searchItemNum(materials[i])>=materialNumList[i]){
					result = true;
				}else{
					result = false;
					break
				}
			}
			return result;
		}
		
		private function checkCard(data:ItemVo):Boolean
		{
			var result:Boolean;
			if(data.bossUp.up_card!=0){
				if(PackManager.getIns().searchMaterialBossCard(data.id,data.lv)){
					result = true;
				}else{
					result = false;
				}
			}else{
				result = true;
			}
			return result;
		}
	}
}