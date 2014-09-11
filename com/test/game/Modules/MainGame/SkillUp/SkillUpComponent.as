package com.test.game.Modules.MainGame.SkillUp
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.PublicNoticeType;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.PublicNoticeManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Configuration.Book;
	import com.test.game.Mvc.Configuration.CharacterSkill;
	import com.test.game.Mvc.Configuration.SkillUp;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SkillUpComponent extends BaseSprite implements IGrid
	{

		private var _mc:Sprite;
		
		private var _skillImage:BaseNativeEntity
		
		private var _curSkillUpInfo:SkillUp;
		
		public function get skillIndex():int
		{
			return _anti["skillIndex"];
		}
		public function set skillIndex(value:int):void
		{
			_anti["skillIndex"] = value;
		}
		
		private var _skillUpEffect:BaseSequenceActionBind;
		
		public function get skillUpState():int
		{
			return _anti["skillUpState"];
		}
		public function set skillUpState(value:int):void
		{
			_anti["skillUpState"] = value;
		}
		
		private var _anti:Antiwear;
		
		public function SkillUpComponent()
		{
			_anti = new Antiwear(new binaryEncrypt());
			
			_mc = AssetsManager.getIns().getAssetObject("skillComponent") as Sprite;
			this.addChild(_mc);
			
			_skillImage = new BaseNativeEntity();
			_skillImage.x = 12;
			_skillImage.y = 378;
			this.addChild(_skillImage);
			
			super();
		}
		
		public function update():void{
			removeEvents();
			renderSkill();
			renderSkillUps();
		}
		
		private function removeEvents():void
		{
			for(var i:int =1;i<=5;i++){
				if((_mc["skillUp"+i] as MovieClip).hasEventListener(MouseEvent.CLICK)){
					(_mc["skillUp"+i] as MovieClip).removeEventListener(MouseEvent.CLICK,onSkillUp);
				}
			}
			
		}		

		private function renderSkill():void
		{
			//技能信息
			var skill:CharacterSkill = searchSkillInfo();
			_skillImage.data.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "SkillIcon" + int(skillIndex+1)) as BitmapData;
			
			if(skillIndex < 5){
				if(skillIndex + 1 <= player.skill.kungfu1){
					GreyEffect.reset(_skillImage);
				}else{
					GreyEffect.change(_skillImage,0.3);
				}
			}else{
				if(skillIndex - 4 <= player.skill.kungfu2){
					GreyEffect.reset(_skillImage);
				}else{
					GreyEffect.change(_skillImage,0.3);
				}
			}
			/*if(player.skill.skillArr[skillIndex] > 0){
				GreyEffect.reset(_skillImage);
			}else{
				GreyEffect.change(_skillImage,0.3);
			}*/
			
			TipsManager.getIns().addTips(_skillImage,{title:ColorConst.setGold(skill.skill_name), tips:skill.info});
		}
		
		private function renderSkillUps():void
		{
			//技能升级信息
			for(var i:int = 1;i<=5;i++){
				
				//技能升级id
				var skillUpId:int
				if(skillIndex < 5){
					skillUpId = player.occupation*1000 + i*10 +skillIndex+1;
				}else{
					skillUpId = player.occupation*1000 + 100 + i*10 +(skillIndex+1-5);
				}
				
				var info:SkillUp = searchSkillUpInfo(skillUpId);
				var numArr:Array = info.up_number.split("|");
				var idArr:Array = info.up_item.split("|");
				var bookConfig:Book = ConfigurationManager.getIns().getObjectByID(AssetsConst.BOOK,idArr[0]) as Book;
				
				var curBookNum:int = player.skillUp["skillBooks"+int(skillIndex+1)][i-1];
				var needBookNum:int = numArr[0];
				
				var curPieceNum:int = PackManager.getIns().searchItemNum(int(idArr[1]));
				var needPieceNum:int = numArr[1];
				
				
				(_mc["numTxt"+i] as TextField).mouseEnabled = false;
				(_mc["trainIcon"+i] as MovieClip).mouseEnabled = false;
				(_mc["skillUp"+i] as MovieClip).buttonMode = true;
				

				
				//tip内容
				var tipText:String = info.info  +"<br>" +
					ColorConst.setDarkGreen("需要"+bookConfig.name + ": " + curBookNum + "/" +needBookNum+ "<br>" +
					ColorConst.setLightBlue("消耗战魂：" +info.soul) +"<br>"+ 
					ColorConst.setPurple("消耗万能碎片：" + needPieceNum) +"<br>")
					;
			
				if(int(player.skillUp.skillLevels[skillIndex])+1 == i){
					_curSkillUpInfo = info;
					(_mc["skillUp"+i] as MovieClip).addEventListener(MouseEvent.CLICK,onSkillUp);
					_mc["numTxt"+i].text = curBookNum+"/"+needBookNum;
					//防止需要的残卷被修改为0
					if(curBookNum>=needBookNum && needBookNum != NumberConst.getIns().zero){
						skillUpState = NumberConst.getIns().one;
						_mc["trainIcon"+i].visible = true;
						GreyEffect.reset(_mc["trainIcon"+i]);
						if(player.soul < info.soul){
							skillUpState = NumberConst.getIns().negativeOne;
							GreyEffect.change(_mc["trainIcon"+i],0.4);
						}
						if(curPieceNum < needPieceNum){
							skillUpState = NumberConst.getIns().negativeTwo;
							GreyEffect.change(_mc["trainIcon"+i],0.4);
						}
						if(player.character.lv < (i+1)*2*5){
							skillUpState = NumberConst.getIns().negativeThree;
							GreyEffect.change(_mc["trainIcon"+i],0.4);
						}
						GreyEffect.change(_mc["skillUp"+i],0.4);
						
					}else{
						_mc["trainIcon"+i].visible = false;
						GreyEffect.change(_mc["skillUp"+i],Math.max(0.05,0.4*(curBookNum/needBookNum)));
						//Number(curNum/needNum)
						skillUpState = NumberConst.getIns().zero;
					}
					TipsManager.getIns().addTips(_mc["skillUp"+i],
						{title:ColorConst.setGold(info.skill_name), tips:tipText});
				}else if(int(player.skillUp.skillLevels[skillIndex])+1 > i){
					_mc["numTxt"+i].text = "";
					_mc["trainIcon"+i].visible = false;
					GreyEffect.reset(_mc["skillUp"+i]);
					TipsManager.getIns().addTips(_mc["skillUp"+i],
						{title:ColorConst.setGold(info.skill_name), tips:info.info + ColorConst.setGold("\n      (已修炼)")});
				}else{
					_mc["numTxt"+i].text = "";
					_mc["trainIcon"+i].visible = false;
					GreyEffect.change(_mc["skillUp"+i],0.03);	
					TipsManager.getIns().addTips(_mc["skillUp"+i],
						{title:ColorConst.setGold(info.skill_name), tips:info.info });
				}
			}
		}
		
		
		public function setData(data:*) : void{
			skillIndex = data[0];
			update();
			

			
		}
		
		protected function onSkillUp(event:MouseEvent):void
		{
			if(skillUpState == NumberConst.getIns().one){
				var numArr:Array = _curSkillUpInfo.up_number.split("|");
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice(
					"是否消耗"+_curSkillUpInfo.soul+"战魂 "+numArr[1]+"万能碎片 "+"升级该技能？",confirmSkillUp);
			}else if(skillUpState == NumberConst.getIns().negativeThree){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"等级不足！");
			}else if(skillUpState == NumberConst.getIns().zero){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"残卷不足！");
			}else if(skillUpState == NumberConst.getIns().negativeOne){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"战魂不足！");
			}else if(skillUpState == NumberConst.getIns().negativeTwo){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"万能碎片不足！");
			}
		}
		
		private function confirmSkillUp():void
		{
			var numArr:Array = _curSkillUpInfo.up_number.split("|");
			var newSkillLv:String = (int(player.skillUp.skillLevels[skillIndex])+NumberConst.getIns().one).toString();
			var skillLevelArr:Array = player.skillUp.skillLevels;
			skillLevelArr[skillIndex] = newSkillLv;
			player.skillUp.skillLevels = skillLevelArr;
			addSkillUpPublicNotice();
			PlayerManager.getIns().reduceSoul(_curSkillUpInfo.soul);
			PackManager.getIns().reduceItem(NumberConst.getIns().wanNengId,int(numArr[1]));
			SaveManager.getIns().onSaveGame();
			//闪光效果
			
			var upIndex:int = int(_curSkillUpInfo.id.toString().substr(2,1));
			_skillUpEffect = AnimationEffect.createAnimation(10015,["attachEffect"],false,destroyAssistEffect)
			_skillUpEffect.x = -12;
			_skillUpEffect.y = 274-(upIndex-1)*70;
			this.addChild(_skillUpEffect);
			RenderEntityManager.getIns().removeEntity(_skillUpEffect);
			AnimationManager.getIns().addEntity(_skillUpEffect);
		}
		
		
		private function addSkillUpPublicNotice():void{
			var info:String;
			var nameArr:Array = _curSkillUpInfo.skill_name.split("（");
			info = nameArr[0] + "|" + nameArr[1].replace("）","");
			PublicNoticeManager.getIns().sendPublicNotice(PublicNoticeType.SKILL_UP,info);
		}
		
		private function destroyAssistEffect(...args):void{
			AnimationManager.getIns().removeEntity(_skillUpEffect);
			_skillUpEffect.destroy();
			_skillUpEffect = null;		
			ViewFactory.getIns().initView(SkillUpView).update();
		}
		
		private function searchSkillInfo():CharacterSkill{
			var result:Object = null;

			for each(var obj:Object in SkillManager.getIns().getSkillInfo(PlayerManager.getIns().player.occupation)){
				var index:int 
				var type:int
				type = int(obj.id.toString().substr(1, 1));
				index = int(obj.id.toString().substr(3, 1));
				if(skillIndex<5){
					if(index == skillIndex+1 && type == 0){
						result = obj;
					}
				}else{
					if(index == skillIndex+1-5 && type == 1){
						result = obj;
					}
				}
			}
			return result as CharacterSkill;
		}
		
		
		private function searchSkillUpInfo(id:int):SkillUp{
			var result:SkillUp = null;
			for each(var obj:Object in SkillManager.getIns().getSkillUpInfo()){
				if(obj.id == id){
					result = obj as SkillUp;
				}
			}
			return result;
		}
		
		
		private function get skillInfo():Array{
			return SkillManager.getIns().getSkillInfo(PlayerManager.getIns().player.occupation);
		}

		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function setLocked() : void{
		}
		
		public function set menuable(value:Boolean) : void{
		}
		
		public function set selectable(value:Boolean) : void{
		}
		
		public function set index(value:int) : void{
		}
		
		override public function destroy():void{
			removeComponent(_mc);
			super.destroy();
		}
	}
}