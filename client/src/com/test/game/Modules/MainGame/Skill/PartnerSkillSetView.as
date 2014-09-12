package com.test.game.Modules.MainGame.Skill
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class PartnerSkillSetView extends BaseView
	{
		private var _skillID:int;
		public var callback:Function;
		public function PartnerSkillSetView()
		{
			super();
			init();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.SKILL_BUTTON_SELECT_VIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("SkillButtonSetView") as Sprite;
				this.addChild(layer);
				
				keyName.gotoAndStop(2);
				initParams();
				initUI();
				setParams();
				setCenter();
				
				if(callback != null){
					callback();
				}
			}
		}
		
		private function initParams():void{
			
		}
		
		public function setSkillButton(skillID:int) : void{
			_skillID = skillID;
			show();
		}
		
		private var nameList:Array = ["H", "U", "I", "O", "L"];
		private var keyList:Array = ["4", "5", "6", "7", "8"];
		private function initUI() : void{
			Close.addEventListener(MouseEvent.CLICK, onClose);
			
			var skillIcon:BaseNativeEntity = new BaseNativeEntity();
			SkillIcon.addChild(skillIcon);
			SkillIcon.addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			SkillIcon.addEventListener(MouseEvent.MOUSE_UP, endDragHandler);
			
			for each(var item:String in nameList){
				var skillIcons:BaseNativeEntity = new BaseNativeEntity();
				(layer["SkillIcon_" + item] as Sprite).addChild(skillIcons);
			}
		}
		
		private function startDragHandler(e:MouseEvent) : void{
			layer.setChildIndex(SkillIcon, layer.numChildren - 1);
			SkillIcon.startDrag();
		}
		
		private var point:Point = new Point();
		private function endDragHandler(e:MouseEvent) : void{
			GuideManager.getIns().skillGuideSetting();
			SkillIcon.stopDrag();
			var isSet:Boolean = false;
			for each(var item:String in nameList){
				if((SkillIcon.y > ((layer["SkillIcon_" + item] as Sprite).y - 70)
					&& SkillIcon.y < ((layer["SkillIcon_" + item] as Sprite).y + 70))
					&& (SkillIcon.x > ((layer["SkillIcon_" + item] as Sprite).x - 40)
					&& SkillIcon.x < ((layer["SkillIcon_" + item] as Sprite).x + 40))){
					SkillIcon.x = (layer["SkillIcon_" + item] as Sprite).x;
					SkillIcon.y = (layer["SkillIcon_" + item] as Sprite).y;
					isSet = true;
					break;
				}
			}
			if(!isSet){
				if(SkillIcon.x > ((layer["SkillIcon_L"] as Sprite).x + 70)){
					SkillIcon.x = (layer["SkillIcon_L"] as Sprite).x;
					SkillIcon.y = (layer["SkillIcon_L"] as Sprite).y;
				}else if(SkillIcon.x < ((layer["SkillIcon_H"] as Sprite).x - 70)){
					SkillIcon.x = (layer["SkillIcon_H"] as Sprite).x;
					SkillIcon.y = (layer["SkillIcon_H"] as Sprite).y;
				}else{
					SkillIcon.x = point.x;
					SkillIcon.y = point.y;
				}
			}
			point.x = SkillIcon.x;
			point.y = SkillIcon.y;
			saveSkillSetting();
		}
		
		private function onClose(e:MouseEvent) : void{
			this.hide();
			saveSkillSetting();
		}
		
		private function saveSkillSetting():void{
			for each(var skillItem:String in keyList){
				if(player.partnerSkill["skill_" + skillItem] == _skillID){
					player.partnerSkill["skill_" + skillItem] = 0;
				}
			}
			for(var i:int =0 ; i <nameList.length ; i++){
				if(SkillIcon.x == (layer["SkillIcon_" + nameList[i]] as Sprite).x){
					player.partnerSkill["skill_" + keyList[i]] = _skillID;
				}
			}
			setAllBtn();
		}
		
		override public function setParams() : void{
			if(layer == null) return;
			
			setSelectBtn();
			setAllBtn();
		}
		
		private function setSelectBtn() : void{
			var img:Bitmap = (SkillIcon.getChildAt(0) as BaseNativeEntity).data;
			img.bitmapData = AUtils.getNewObj(partnerFodder + "SkillIcon" + _skillID) as BitmapData;
			img.x = -img.width * .5;
			img.y = -img.height * .5;
			point.x = SkillIcon.x = 322;
			point.y = SkillIcon.y = 103;
		}
		
		private function setAllBtn() : void{
			for(var i:int = 0; i<nameList.length ; i++){
				var img:Bitmap = ((layer["SkillIcon_" + nameList[i]] as Sprite).getChildAt(0) as BaseNativeEntity).data;
				if(player.partnerSkill["skill_" + keyList[i]] != 0){
					img.bitmapData = AUtils.getNewObj(partnerFodder + "SkillIcon" + player.partnerSkill["skill_" + keyList[i]]) as BitmapData;
					img.x = -img.width * .5;
					img.y = -img.height * .5;
				}else{
					img.bitmapData = null;
				}
			}
		}
		
		private function get SkillIcon() : Sprite{
			return layer["SkillIcon"];
		}
		
		
		private function get Close() : SimpleButton{
			return layer["Close"];
		}
		
		private function get keyName() : MovieClip{
			return layer["keyName"];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		private function get partnerFodder():String{
			return player.fodder=="KuangWu"?"XiaoYao":"KuangWu";
		}
		
		
		private function get player() : PlayerVo{ 
			return PlayerManager.getIns().player;
		}
		
		override public function destroy() : void{
			Close.removeEventListener(MouseEvent.CLICK, onClose);
			SkillIcon.removeEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			SkillIcon.removeEventListener(MouseEvent.MOUSE_UP, endDragHandler);
			super.destroy();
		}
	}
}