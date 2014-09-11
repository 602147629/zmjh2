package com.test.game.Modules.MainGame.Skill
{
	import com.greensock.TweenMax;
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
	import com.test.game.Const.OccupationConst;
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
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Utils.AllUtils;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class PartnerSkillView extends BaseView{

		private var _baseInfo:Array;
		private var _skillInfo:Array;
		
		private var _skillIconList:Array;
		private var _skillType:int;
		
		public function PartnerSkillView()
		{
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
				layer = AssetsManager.getIns().getAssetObject("PartnerSkillView") as Sprite;
				this.addChild(layer);
				layer.visible = false;
				
				initUI();
				initEvents();
				initParams();
				setParams();
				setCenter();
				openTween();
			}
		}
		
		private function initEvents():void
		{
			Close.addEventListener(MouseEvent.CLICK, onClose);
			skillSelect1.addEventListener(MouseEvent.CLICK, onSelect1);
			skillSelect2.addEventListener(MouseEvent.CLICK, onSelect2);
			skillSelect1.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			skillSelect2.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			skillSelect1.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			skillSelect2.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function initParams() : void{
			_baseInfo = ConfigurationManager.getIns().getAllData(AssetsConst.CHARACTER_SKILL);
		}
		
		private function initUI():void{

			skillSelect1.stop();
			skillSelect2.stop();
			skillSelect1.buttonMode = true;
			skillSelect2.buttonMode = true;

			_skillIconList = new Array();
			for(var i:int = 1; i < 6; i++){
				(layer["Setting" + i] as SimpleButton).addEventListener(MouseEvent.CLICK, onSetSkillButton);
				
				var skillIcon:BaseNativeEntity = new BaseNativeEntity();
				(layer["SkillIcon" + i] as Sprite).addChild(skillIcon);
				_skillIconList.push(layer["SkillIcon" + i] as Sprite);
			}
			
			for(var j:int = 1; j < 3; j++){
				var skillImg:BaseNativeEntity = new BaseNativeEntity();
				skillImg.data.bitmapData = AUtils.getNewObj(player.fodder + "KungFu" + j) as BitmapData;
				skillImg.scaleX = .46;
				skillImg.scaleY = .46;
				(layer["KungFuImg_" + j] as Sprite).addChild(skillImg);
			}
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
			var fodder:String = partnerOcc==OccupationConst.KUANGWU?"KuangWu":"XiaoYao";
			_skillInfo = SkillManager.getIns().getSkillInfo(partnerOcc);
			for(var j:int = 1; j < 3; j++){
				((layer["KungFuImg_" + j] as Sprite).getChildAt(0) as BaseNativeEntity).data.bitmapData = AUtils.getNewObj(fodder + "KungFu" + j) as BitmapData;
			}
		}
		
		
		//功夫信息显示
		private function skillTypeSetting() : void{
			(layer["KungFu1"] as TextField).text = _skillInfo[0].kungfu;
			(layer["KungFu2"] as TextField).text = _skillInfo[5].kungfu;
			(layer["KungFuLv1"] as TextField).text = player.skill.kungfu1.toString();
			(layer["KungFuLv2"] as TextField).text = player.skill.kungfu2.toString();
			
			if(_skillType == 0){
				skillSelect1.gotoAndStop(2);
				skillSelect2.gotoAndStop(1);
			}else{
				skillSelect1.gotoAndStop(1);
				skillSelect2.gotoAndStop(2);
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
			
			var fodder:String = partnerOcc==OccupationConst.KUANGWU?"KuangWu":"XiaoYao";
			for(var j:int = 0; j < _skillIconList.length; j++){
				((_skillIconList[j] as Sprite).getChildAt(0) as BaseNativeEntity).data.bitmapData = AUtils.getNewObj(fodder + "SkillIcon" + ((j + 1) + _skillType * 5)) as BitmapData;
			}
			skillInfoShow();
		}
		
		private function skillInfoShow() : void{
			for(var i:int = 0; i < 5; i++){
				if(i < player.skill["kungfu" + (_skillType + 1)]){
					GreyEffect.reset(_skillIconList[i]);
					(layer["Setting" + (i + 1)] as SimpleButton).mouseEnabled = true;
					GreyEffect.reset(layer["Setting" + (i + 1)] as SimpleButton);
				}else{
					GreyEffect.change(_skillIconList[i]);
					(layer["Setting" + (i + 1)] as SimpleButton).mouseEnabled = false;
					GreyEffect.change(layer["Setting" + (i + 1)] as SimpleButton);
				}
			}
		}
		

		
		override public function show():void{
			if(layer == null) return;
			openTween();
			update();
			super.show();
		}
		
		private function openTween():void{
			layer.scaleX = layer.scaleY = 0;
			layer.visible = true;
			TweenMax.fromTo(layer,0.4,{scaleX:0,scaleY:0,x:pos.x,y:pos.y},{scaleX:1,scaleY:1,x:this.centerX,y:this.centerY});			
		}
		
		private function closeTween():void{
			TweenMax.to(layer,0.4,{scaleX:0,scaleY:0,x:pos.x,y:pos.y,onComplete:hide});			
		}
		
		
		private function get pos():Point{
			var p:Point = new Point();
			p.x = ViewFactory.getIns().getView(MainToolBar).layer["skill"].x + 25  - this.x;
			p.y = ViewFactory.getIns().getView(MainToolBar).layer["skill"].y + 25 - this.y;
			return p;
		}
		
		private function onClose(e:MouseEvent) : void{
			closeTween();
			ViewFactory.getIns().initView(SkillButtonSetView).hide();
			GuideManager.getIns().skillGuideSetting(GuideConst.CLOSE);
		}
		
		private function onSelect1(e:MouseEvent) : void{
			_skillType = 0;
			skillInfoSetting();
			skillSelect1.gotoAndStop(2);
			skillSelect2.gotoAndStop(1);
		}
		private function onSelect2(e:MouseEvent) : void{
			_skillType = 1;
			skillInfoSetting();
			skillSelect1.gotoAndStop(1);
			skillSelect2.gotoAndStop(2);
		}
		
		
		private function onSetSkillButton(e:MouseEvent) : void{
			var index:int = AllUtils.getNumFromString(e.target.name);
			(ViewFactory.getIns().initView(PartnerSkillSetView) as PartnerSkillSetView).setSkillButton(index + _skillType * 5);
		}
		
		private function nowLearnSkillCount() : int{
			var result:int = 0;
			for each(var item:int in player.skill.skillArr){
				if(item == 1){
					result++;
				}
			}
			return result;
		}
		
		private function skillLightShow():void{
			if(player.skill.kungfu1 >= 5){
				layer["Light_1"].visible = false;
				layer["BtnLight_1"].visible = false;
			}else if(player.skill.kungfu1 < 5 && player.soul < _skillInfo[player.skill.kungfu1].soul){
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
			if(player.skill.kungfu2 >= 5){
				layer["Light_2"].visible = false;
				layer["BtnLight_2"].visible = false;
			}else if(player.skill.kungfu2 < 5 && player.soul < _skillInfo[player.skill.kungfu2 + 5].soul){
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
		
		override public function update():void{
			RoleName.gotoAndStop(partnerOcc);
			skillTypeSetting();
			skillInfoSetting();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy() : void{
			for(var i:int = 1; i < 6; i++){
				(layer["Setting" + i] as SimpleButton).removeEventListener(MouseEvent.CLICK, onSetSkillButton);
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

		}
		
		private function get RoleName() : MovieClip{
			return layer["RoleName"];
		}
		
		private function get skillSelect1() : MovieClip{
			return layer["SkillSelect1"];
		}
		private function get skillSelect2() : MovieClip{
			return layer["SkillSelect2"];
		}

		
		private function get Close() : SimpleButton{
			return layer["Close"];
		}
		
		private function get partnerOcc():int{
			return player.occupation==1?2:1;
		}
		
		
		private function get player() : PlayerVo{ 
			return PlayerManager.getIns().player;
		}

	}
}