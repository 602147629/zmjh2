package com.test.game.Modules.MainGame.Skill
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.GuideConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Modules.MainGame.Guide.SkillGuideView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Utils.AllUtils;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SkillLearnView extends BaseView
	{
		private var _baseInfo:Array;
		private var _skillInfo:Array;
		private var _skillLevelUpBtn1:SimpleButton;
		private var _skillLevelUpBtn2:SimpleButton;
		private var _skillIconList:Array;
		private var _skillType:int;
		public function SkillLearnView(){
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.SKILLVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = AssetsManager.getIns().getAssetObject("SkillView") as Sprite;
				this.addChild(layer);
				
				initUI();
				initParams();
				setParams();
				setCenter();
			}
		}
		
		private function initParams() : void{
			_baseInfo = ConfigurationManager.getIns().getAllData(AssetsConst.CHARACTER_SKILL);
		}
		
		private function initUI():void{
			(layer["Close"] as SimpleButton).addEventListener(MouseEvent.CLICK, onClose);
			(skillSelect1 as MovieClip).stop();
			(skillSelect2 as MovieClip).stop();
			skillSelect1.addEventListener(MouseEvent.CLICK, onSelect1);
			skillSelect2.addEventListener(MouseEvent.CLICK, onSelect2);
			skillSelect1.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			skillSelect2.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			skillSelect1.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			skillSelect2.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			skillSelect1.buttonMode = true;
			skillSelect2.buttonMode = true;
			_skillLevelUpBtn1 = layer["SkillLevelUpBtn1"] as SimpleButton;
			_skillLevelUpBtn2 = layer["SkillLevelUpBtn2"] as SimpleButton;
			
			_skillIconList = new Array();
			for(var i:int = 1; i < 6; i++){
				(layer["Setting" + i] as SimpleButton).addEventListener(MouseEvent.CLICK, onSetSkillButton);
				(layer["Learn" + i] as SimpleButton).addEventListener(MouseEvent.CLICK, onLearnSkill);
				
				var skillIcon:BaseNativeEntity = new BaseNativeEntity();
				(layer["SkillIcon" + i] as Sprite).addChild(skillIcon);
				_skillIconList.push(layer["SkillIcon" + i] as Sprite);
			}
			
			for(var j:int = 1; j < 3; j++){
				var skillImg:BaseNativeEntity = new BaseNativeEntity();
				skillImg.data.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "KungFu" + j) as BitmapData;
				skillImg.scaleX = .46;
				skillImg.scaleY = .46;
				(layer["KungFuImg_" + j] as Sprite).addChild(skillImg);
			}
			(layer["helpBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onShowHelp);
		}
		
		private function onShowHelp(e:MouseEvent) : void{
			ViewFactory.getIns().initView(SkillGuideView).show();
		}
		
		private function onMouseOver(e:MouseEvent) : void{
			(e.currentTarget as MovieClip).gotoAndStop(2);
		}
		
		private function onMouseOut(e:MouseEvent) : void{
			if((e.currentTarget as MovieClip).name.split("Select")[1] != (_skillType + 1)){
				(e.currentTarget as MovieClip).gotoAndStop(1);
			}
		}
		
		override public function setParams() : void{
			if(layer == null) return;
			
			changeRoleInfo();
			update();
			
			GuideManager.getIns().skillGuideSetting();
		}
		
		private function changeRoleInfo():void{
			_skillInfo = SkillManager.getIns().getSkillInfo(PlayerManager.getIns().player.occupation);
			for(var j:int = 1; j < 3; j++){
				((layer["KungFuImg_" + j] as Sprite).getChildAt(0) as BaseNativeEntity).data.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "KungFu" + j) as BitmapData;
			}
		}
		
		private function skillLightShow():void{
			if(PlayerManager.getIns().player.skill.kungfu1 >= 5){
				layer["Light_1"].visible = false;
				layer["BtnLight_1"].visible = false;
			}else if(PlayerManager.getIns().player.skill.kungfu1 < 5 && PlayerManager.getIns().player.soul < _skillInfo[PlayerManager.getIns().player.skill.kungfu1].soul){
				layer["Light_1"].visible = false;
				layer["BtnLight_1"].visible = false;
			}else{
				layer["Light_1"].visible = true;
				if(_skillType == 0){
					layer["BtnLight_1"].visible = true;
				}else{
					layer["BtnLight_1"].visible = false;
				}
			}
			if(PlayerManager.getIns().player.skill.kungfu2 >= 5){
				layer["Light_2"].visible = false;
				layer["BtnLight_2"].visible = false;
			}else if(PlayerManager.getIns().player.skill.kungfu2 < 5 && PlayerManager.getIns().player.soul < _skillInfo[PlayerManager.getIns().player.skill.kungfu2 + 5].soul){
				layer["Light_2"].visible = false;
				layer["BtnLight_2"].visible = false;
			}else{
				layer["Light_2"].visible = true;
				if(_skillType == 1){
					layer["BtnLight_2"].visible = true;
				}else{
					layer["BtnLight_2"].visible = false;
				}
			}
		}
		
		//功夫信息显示
		private function skillTypeSetting() : void{
			(layer["KungFu1"] as TextField).text = _skillInfo[0].kungfu;
			(layer["KungFu2"] as TextField).text = _skillInfo[5].kungfu;
			(layer["KungFuLv1"] as TextField).text = PlayerManager.getIns().player.skill.kungfu1.toString();
			(layer["KungFuLv2"] as TextField).text = PlayerManager.getIns().player.skill.kungfu2.toString();
			if(PlayerManager.getIns().player.skill.kungfu1 < 5){
				(layer["KungFuSoul1"] as TextField).text = _skillInfo[PlayerManager.getIns().player.skill.kungfu1].soul;
			}else{
				(layer["KungFuSoul1"] as TextField).text = "";
			}
			if(PlayerManager.getIns().player.skill.kungfu2 < 5){
				(layer["KungFuSoul2"] as TextField).text = _skillInfo[PlayerManager.getIns().player.skill.kungfu2 + 5].soul;
			}else{
				(layer["KungFuSoul2"] as TextField).text = "";
			}
		}
		
		//10个技能信息显示
		private function skillInfoSetting() : void{
			for(var i:int = 0; i < _skillInfo.length; i++){
				var idInfo:String = (_skillInfo[i].id).toString();
				if(int(idInfo.substr(1, 1)) == _skillType){
					var seq:String = idInfo.substr(3, 1);
					(layer["SkillName" + seq] as TextField).text = _skillInfo[i].skill_name;
					(layer["SkillInfo" + seq] as TextField).text = _skillInfo[i].info;
				}
			}
			
			for(var j:int = 0; j < _skillIconList.length; j++){
				((_skillIconList[j] as Sprite).getChildAt(0) as BaseNativeEntity).data.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "SkillIcon" + ((j + 1) + _skillType * 5)) as BitmapData;
			}
			skillInfoShow();
		}
		
		private function skillInfoShow() : void{
			if(_skillType == 0){
				for(var i:int = 0; i < 5; i++){
					if(i < PlayerManager.getIns().player.skill.kungfu1){
						(layer["Learn" + (i + 1)] as SimpleButton).visible = true;
					}else{
						(layer["Learn" + (i + 1)] as SimpleButton).visible = false;
					}
					if(PlayerManager.getIns().player.skill.skillArr[i] != 0){
						(layer["Learn" + (i + 1)] as SimpleButton).visible = false;
						GreyEffect.reset(_skillIconList[i]);
						(layer["Setting" + (i + 1)] as SimpleButton).mouseEnabled = true;
						GreyEffect.reset(layer["Setting" + (i + 1)] as SimpleButton);
					}else{
						GreyEffect.change(_skillIconList[i]);
						(layer["Setting" + (i + 1)] as SimpleButton).mouseEnabled = false;
						GreyEffect.change(layer["Setting" + (i + 1)] as SimpleButton);
					}
				}
			}else if(_skillType == 1){
				for(var j:int = 0; j < 5; j++){
					if(j < PlayerManager.getIns().player.skill.kungfu2){
						(layer["Learn" + (j + 1)] as SimpleButton).visible = true;
					}else{
						(layer["Learn" + (j + 1)] as SimpleButton).visible = false;
					}
					if(PlayerManager.getIns().player.skill.skillArr[j + 5] != 0){
						(layer["Learn" + (j + 1)] as SimpleButton).visible = false;
						GreyEffect.reset(_skillIconList[j]);
						(layer["Setting" + (j + 1)] as SimpleButton).mouseEnabled = true;
						GreyEffect.reset(layer["Setting" + (j + 1)] as SimpleButton);
					}else{
						GreyEffect.change(_skillIconList[j]);
						(layer["Setting" + (j + 1)] as SimpleButton).mouseEnabled = false;
						GreyEffect.change(layer["Setting" + (j + 1)] as SimpleButton);
					}
				}
			}
			if(nowLearnSkillCount() >= 5){
				for(var k:int = 0; k < 5; k++){
					(layer["Learn" + (k + 1)] as SimpleButton).visible = false;
				}
			}
		}
		
		//升级按钮显示
		private function skillLevelBtnShow() : void{
			if(_skillType == 0){
				_skillLevelUpBtn1.visible = true;
				_skillLevelUpBtn2.visible = false;
				skillSelect1.gotoAndStop(2);
				skillSelect2.gotoAndStop(1);
				if(PlayerManager.getIns().player.skill.kungfu1 >= 5){
					_skillLevelUpBtn1.visible = false;
				}
				if(PlayerManager.getIns().player.skill.kungfu1 < 5 && PlayerManager.getIns().player.soul < _skillInfo[PlayerManager.getIns().player.skill.kungfu1].soul){
					GreyEffect.change(_skillLevelUpBtn1);
					TipsManager.getIns().addTips(_skillLevelUpBtn1, {title:"战魂不足", tips:""});
					_skillLevelUpBtn1.removeEventListener(MouseEvent.CLICK, onLevelUp);
				}else{
					GreyEffect.reset(_skillLevelUpBtn1);
					TipsManager.getIns().removeTips(_skillLevelUpBtn1);
					if(!_skillLevelUpBtn1.hasEventListener(MouseEvent.CLICK)){
						_skillLevelUpBtn1.addEventListener(MouseEvent.CLICK, onLevelUp);
					}
				}
			}else if(_skillType == 1){
				_skillLevelUpBtn1.visible = false;
				_skillLevelUpBtn2.visible = true;
				skillSelect1.gotoAndStop(1);
				skillSelect2.gotoAndStop(2);
				if(PlayerManager.getIns().player.skill.kungfu2 >= 5){
					_skillLevelUpBtn2.visible = false;
				}
				if(PlayerManager.getIns().player.skill.kungfu2 < 5 && PlayerManager.getIns().player.soul < _skillInfo[PlayerManager.getIns().player.skill.kungfu2 + 5].soul){
					GreyEffect.change(_skillLevelUpBtn2);
					TipsManager.getIns().addTips(_skillLevelUpBtn2, {title:"战魂不足", tips:""});
					_skillLevelUpBtn2.removeEventListener(MouseEvent.CLICK, onLevelUp);
				}else{
					GreyEffect.reset(_skillLevelUpBtn2);
					TipsManager.getIns().removeTips(_skillLevelUpBtn2);
					if(!_skillLevelUpBtn2.hasEventListener(MouseEvent.CLICK)){
						_skillLevelUpBtn2.addEventListener(MouseEvent.CLICK, onLevelUp);
					}
				}
			}
		}
		
		private function onClose(e:MouseEvent) : void{
			this.hide();
			ViewFactory.getIns().initView(SkillButtonSetView).hide();
			GuideManager.getIns().skillGuideSetting(GuideConst.CLOSE);
		}
		
		private function onSelect1(e:MouseEvent) : void{
			_skillType = 0;
			skillSelect2.gotoAndStop(1);
			skillInfoSetting();
			skillLevelBtnShow();
			skillLightShow();
			GuideManager.getIns().skillGuideSetting(GuideConst.TYPEONE);
		}
		private function onSelect2(e:MouseEvent) : void{
			_skillType = 1;
			skillSelect1.gotoAndStop(1);
			skillInfoSetting();
			skillLevelBtnShow();
			skillLightShow();
			GuideManager.getIns().skillGuideSetting(GuideConst.TYPETWO);
		}
		
		private function onLevelUp(e:MouseEvent) : void{
			var index:int = AllUtils.getNumFromString(e.target.name);
			PlayerManager.getIns().addSoul(-_skillInfo[PlayerManager.getIns().player.skill["kungfu" + index]].soul);
			PlayerManager.getIns().player.skill["kungfu" + index]++;
			
			update();
			DeformTipManager.getIns().checkSkillDeform();
			(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).update();
			GuideManager.getIns().skillGuideSetting();
		}
		
		private var _skillIndex:int;
		private function onLearnSkill(e:MouseEvent) : void{
			_skillIndex = AllUtils.getNumFromString(e.target.name);
			(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice("是否学习该技能?",comfire);
		}
		
		private function comfire() : void{
			GuideManager.getIns().skillGuideSetting();
			PlayerManager.getIns().player.skill.skillArr[_skillIndex - 1 + 5 * _skillType] = 1;
			skillInfoShow();
			(ViewFactory.getIns().initView(SkillButtonSetView) as SkillButtonSetView).setSkillButton(_skillIndex + _skillType * 5);
		}
		
		private function onSetSkillButton(e:MouseEvent) : void{
			GuideManager.getIns().skillGuideSetting();
			var index:int = AllUtils.getNumFromString(e.target.name);
			(ViewFactory.getIns().initView(SkillButtonSetView) as SkillButtonSetView).setSkillButton(index + _skillType * 5);
		}
		
		private function nowLearnSkillCount() : int{
			var result:int = 0;
			for each(var item:int in PlayerManager.getIns().player.skill.skillArr){
				if(item == 1){
					result++;
				}
			}
			return result;
		}
		
		override public function update():void{
			(layer["RoleName"] as MovieClip).gotoAndStop(PlayerManager.getIns().player.occupation);
			(layer["AllSoul"] as TextField).text = PlayerManager.getIns().player.soul.toString();
			skillTypeSetting();
			skillInfoSetting();
			skillLevelBtnShow();
			skillLightShow();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy() : void{
			for(var i:int = 1; i < 6; i++){
				(layer["Setting" + i] as SimpleButton).removeEventListener(MouseEvent.CLICK, onSetSkillButton);
				(layer["Learn" + i] as SimpleButton).removeEventListener(MouseEvent.CLICK, onLearnSkill);
			}
			if(_skillLevelUpBtn1.hasEventListener(MouseEvent.CLICK)){
				_skillLevelUpBtn1.removeEventListener(MouseEvent.CLICK, onLevelUp);
			}
			if(_skillLevelUpBtn2.hasEventListener(MouseEvent.CLICK)){
				_skillLevelUpBtn2.removeEventListener(MouseEvent.CLICK, onLevelUp);
			}
			skillSelect1.removeEventListener(MouseEvent.CLICK, onSelect1);
			skillSelect2.removeEventListener(MouseEvent.CLICK, onSelect2);
			skillSelect1.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			skillSelect2.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			skillSelect1.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			skillSelect2.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_skillInfo.length = 0;
			_skillInfo = null;
			super.destroy();
			/*_baseInfo.length = 0;
			_baseInfo = null;*/
		}
		
		public function get skillSelect1() : MovieClip{
			return layer["SkillSelect1"];
		}
		public function get skillSelect2() : MovieClip{
			return layer["SkillSelect2"];
		}
		
		public function get skillInfo() : Array{
			return _skillInfo;
		}
	}
}