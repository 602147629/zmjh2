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
	import com.test.game.Const.GuideConst;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class SkillButtonSetView extends BaseView
	{
		private var _skillID:int;
		public var callback:Function;
		public function SkillButtonSetView()
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
		private function initUI() : void{
			(layer["Close"] as SimpleButton).addEventListener(MouseEvent.CLICK, onClose);
			
			var skillIcon:BaseNativeEntity = new BaseNativeEntity();
			(layer["SkillIcon"] as Sprite).addChild(skillIcon);
			(layer["SkillIcon"] as Sprite).addEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			(layer["SkillIcon"] as Sprite).addEventListener(MouseEvent.MOUSE_UP, endDragHandler);
			
			for each(var item:String in nameList){
				var skillIcons:BaseNativeEntity = new BaseNativeEntity();
				(layer["SkillIcon_" + item] as Sprite).addChild(skillIcons);
			}
		}
		
		private function startDragHandler(e:MouseEvent) : void{
			layer.setChildIndex((layer["SkillIcon"] as Sprite), layer.numChildren - 1);
			(layer["SkillIcon"] as Sprite).startDrag();
		}
		
		private var point:Point = new Point();
		private function endDragHandler(e:MouseEvent) : void{
			GuideManager.getIns().skillGuideSetting();
			(layer["SkillIcon"] as Sprite).stopDrag();
			var isSet:Boolean = false;
			for each(var item:String in nameList){
				if(((layer["SkillIcon"] as Sprite).y > ((layer["SkillIcon_" + item] as Sprite).y - 70)
					&& (layer["SkillIcon"] as Sprite).y < ((layer["SkillIcon_" + item] as Sprite).y + 70))
					&& ((layer["SkillIcon"] as Sprite).x > ((layer["SkillIcon_" + item] as Sprite).x - 40)
					&& (layer["SkillIcon"] as Sprite).x < ((layer["SkillIcon_" + item] as Sprite).x + 40))){
					(layer["SkillIcon"] as Sprite).x = (layer["SkillIcon_" + item] as Sprite).x;
					(layer["SkillIcon"] as Sprite).y = (layer["SkillIcon_" + item] as Sprite).y;
					isSet = true;
					break;
				}
			}
			if(!isSet){
				if((layer["SkillIcon"] as Sprite).x > ((layer["SkillIcon_L"] as Sprite).x + 70)){
					(layer["SkillIcon"] as Sprite).x = (layer["SkillIcon_L"] as Sprite).x;
					(layer["SkillIcon"] as Sprite).y = (layer["SkillIcon_L"] as Sprite).y;
				}else if((layer["SkillIcon"] as Sprite).x < ((layer["SkillIcon_H"] as Sprite).x - 70)){
					(layer["SkillIcon"] as Sprite).x = (layer["SkillIcon_H"] as Sprite).x;
					(layer["SkillIcon"] as Sprite).y = (layer["SkillIcon_H"] as Sprite).y;
				}else{
					(layer["SkillIcon"] as Sprite).x = point.x;
					(layer["SkillIcon"] as Sprite).y = point.y;
				}
			}
			point.x = (layer["SkillIcon"] as Sprite).x;
			point.y = (layer["SkillIcon"] as Sprite).y;
			saveSkillSetting();
		}
		
		private function onClose(e:MouseEvent) : void{
			this.hide();
			saveSkillSetting();
			GuideManager.getIns().skillGuideSetting();
		}
		
		private function saveSkillSetting():void{
			for each(var skillItem:String in nameList){
				if(PlayerManager.getIns().player.skill["skill_" + skillItem] == _skillID){
					PlayerManager.getIns().player.skill["skill_" + skillItem] = 0;
				}
			}
			for each(var item:String in nameList){
				if((layer["SkillIcon"] as Sprite).x == (layer["SkillIcon_" + item] as Sprite).x){
					PlayerManager.getIns().player.skill["skill_" + item] = _skillID;
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
			var img:Bitmap = ((layer["SkillIcon"] as Sprite).getChildAt(0) as BaseNativeEntity).data;
			img.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "SkillIcon" + _skillID) as BitmapData;
			img.x = -img.width * .5;
			img.y = -img.height * .5;
			point.x = (layer["SkillIcon"] as Sprite).x = 322;
			point.y = (layer["SkillIcon"] as Sprite).y = 103;
		}
		
		private function setAllBtn() : void{
			for each(var item:String in nameList){
				var img:Bitmap = ((layer["SkillIcon_" + item] as Sprite).getChildAt(0) as BaseNativeEntity).data;
				if(PlayerManager.getIns().player.skill["skill_" + item] != 0){
					img.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "SkillIcon" + PlayerManager.getIns().player.skill["skill_" + item]) as BitmapData;
					img.x = -img.width * .5;
					img.y = -img.height * .5;
				}else{
					img.bitmapData = null;
				}
			}
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy() : void{
			(layer["Close"] as SimpleButton).removeEventListener(MouseEvent.CLICK, onClose);
			(layer["SkillIcon"] as Sprite).removeEventListener(MouseEvent.MOUSE_DOWN, startDragHandler);
			(layer["SkillIcon"] as Sprite).removeEventListener(MouseEvent.MOUSE_UP, endDragHandler);
			super.destroy();
		}
	}
}