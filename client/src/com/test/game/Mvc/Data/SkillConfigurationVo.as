package com.test.game.Mvc.Data
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Mvc.Configuration.SkillUp;
	import com.test.game.Mvc.Vo.PlayerVo;

	public class SkillConfigurationVo
	{
		private var _anti:Antiwear;
		public var commonList:Array = new Array();
		public var commonFrameList:Array = new Array();
		public var commonHit:Array = new Array();
		public var jumpPressHit:Array = new Array();
		public var jumpHit:Array = new Array();
		public var pressHit:Array = new Array();
		public var runHit:Array = new Array();
		public var skillList:Array = new Array();
		public var skillCountList:Array = new Array();
		public var bossSkill:Array = new Array();
		public var skillFrameList:Array = new Array();
		public var invincibleList:Array = new Array();
		public var onlyHurtList:Array = new Array();
		public var nowColdTimeList:Array = new Array();
		public var jumpSkillList:Array = new Array();
		public var rollSkillList:Array = new Array();
		public var commonOnlyHurtList:Array = new Array();
		public var releaseSkillList:Array = new Array();
		
		public function get skillColdTimeList() : Array{
			return _anti["skillColdTimeList"];
		}
		public function set skillColdTimeList(value:Array) : void{
			_anti["skillColdTimeList"] = value;
		}
		
		public function get mpUseList() : Array{
			return _anti["mpUseList"];
		}
		public function set mpUseList(value:Array) : void{
			_anti["mpUseList"] = value;
		}
		
		public function SkillConfigurationVo(){
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["skillColdTimeList"] = [];
			_anti["mpUseList"] = [];
		}
		
		public function assginPlayerData(obj:Object, playerVo:PlayerVo) : void{
			commonHit = obj.common_hit.split("|");
			runHit = obj.run_hit.split("|");
			jumpPressHit = obj.jump_press_hit.split("|");
			jumpHit = obj.jump_hit.split("|");
			for(var i:int = 1; i <= 10; i++){
				skillList.push(obj["skill" + i].split("|"));
			}
			for(var j:int = 1; j <= 10; j++){
				skillFrameList.push(obj["frame" + j].split("|"));
			}
			var baseInfo:Array = ConfigurationManager.getIns().getAllData(AssetsConst.CHARACTER_SKILL);
			var list1:Array = new Array();
			var list2:Array = new Array();
			for(var k:int = 0; k < baseInfo.length; k++){
				if(int(baseInfo[k].id / 1000) == playerVo.occupation){
					list1.push(baseInfo[k].cooldown);
					list2.push(baseInfo[k].mp);
					onlyHurtList.push(baseInfo[k].onlyhurt);
					invincibleList.push(baseInfo[k].invincible);
					releaseSkillList.push(0);
				}
			}
			
			if(playerVo.skillUp != null){
				for(var l:int = 0; l < playerVo.skillUp.skillLevels.length; l++){
					if(playerVo.skillUp.skillLevels[l] > 0){
						var index:int = playerVo.occupation * 1000 + int(l / 5) * 100 + (playerVo.skillUp.skillLevels[l]) * 10 + (l % 5 + 1);
						var skillData:SkillUp = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SKILL_UP, "id", index) as SkillUp;
						list1[l] = skillData.cooldown;
						list2[l] = skillData.mp;
						onlyHurtList[l] = skillData.onlyhurt;
						invincibleList[l] = skillData.invincible;
						releaseSkillList[l] = skillData.release;
					}
				}
			}
			
			skillColdTimeList = list1;
			mpUseList = list2;
			bossSkill = [0];
			
			skillCountList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			nowColdTimeList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		}
		
		public function resetColdTime() : void{
			skillCountList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			nowColdTimeList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		}
		
		public function assginMonsterData(obj:Object) : void{
			commonList = obj.common_hit.split("|");
			commonFrameList = obj.common_frame.split("|");
			jumpSkillList = obj.jump_skill.split("|");
			
			var rollSkill:Array = obj.roll_skill.split("|");
			for(var k:int = 0; k < rollSkill.length; k++){
				rollSkillList.push(rollSkill[i].split("_"));
			}
			
			for(var i:int = 1; i <= 5; i++){
				skillList.push(obj["skill" + i].split("|"));
			}
			for(var j:int = 1; j <= 5; j++){
				skillFrameList.push(obj["frame" + j].split("|"));
			}
			
			invincibleList = obj.invincible.split("|");
			onlyHurtList = obj.only_hurt.split("|");
			commonOnlyHurtList = obj.common_only_hurt.split("|");
			
			skillCountList = [0, 0, 0, 0, 0];
		}
		
		public function assignConjureData(obj:Object):void{
			commonList = obj.common_hit.split("|");
			commonFrameList = obj.common_frame.split("|");
			jumpSkillList = obj.jump_skill.split("|");
			rollSkillList = obj.roll_skill.split("|");
			
			for(var i:int = 1; i <= 5; i++){
				skillList.push(obj["skill" + i].split("|"));
			}
			for(var j:int = 1; j <= 5; j++){
				skillFrameList.push(obj["frame" + j].split("|"));
			}
			
			skillCountList = [0, 0, 0, 0, 0];
		}
		
		public function checkMpUse(nowMp:int) : Array{
			var result:Array = new Array();
			for(var i:int = 0; i < mpUseList.length; i++){
				if(nowMp >= mpUseList[i]){
					result.push(1);
				}else{
					result.push(0);
				}
			}
			return result;
		}
		
		public function destroy() : void{
			if(commonList){
				commonList.length = 0;
				commonList = null;
			}
			if(commonFrameList){
				commonFrameList.length = 0;
				commonFrameList = null;
			}
			if(commonHit){
				commonHit.length = 0;
				commonHit = null;
			}
			if(jumpPressHit){
				jumpPressHit.length = 0;
				jumpPressHit = null;
			}
			if(jumpHit){
				jumpHit.length = 0;
				jumpHit = null;
			}
			if(pressHit){
				pressHit.length = 0;
				pressHit = null;
			}
			if(runHit){
				runHit.length = 0;
				runHit = null;
			}
			if(skillList){
				skillList.length = 0;
				skillList = null;
			}
			if(skillCountList){
				skillCountList.length = 0;
				skillCountList = null;
			}
			if(bossSkill){
				bossSkill.length = 0;
				bossSkill = null;
			}
			if(skillFrameList){
				skillFrameList.length = 0;
				skillFrameList = null;
			}
			if(invincibleList){
				invincibleList.length = 0;
				invincibleList = null;
			}
			if(onlyHurtList){
				onlyHurtList.length = 0;
				onlyHurtList = null;
			}
			if(nowColdTimeList){
				nowColdTimeList.length = 0;
				nowColdTimeList = null;
			}
			if(skillColdTimeList){
				skillColdTimeList.length = 0;
			}
			if(mpUseList){
				mpUseList.length = 0;
			}
		}
	}
} 