package com.test.game.Modules.MainGame.MainUI
{
	import com.greensock.TweenLite;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.OccupationConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.Skill.SkillManager;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class PlayerKillingBattleToolBar extends BaseView
	{
		private var _mask:Sprite;
		private var nameList:Array = ["H", "U", "I", "O", "L"];
		private var _coolDownTime:Array = [0, 0, 0, 0, 0];
		private var _nowCoolDownTime:Array = [0, 0, 0, 0, 0];
		private var _buringDown:BaseSequenceActionBind;
		private var _buringRelease:BaseSequenceActionBind;
		private var _buringFull:BaseSequenceActionBind;
		public function PlayerKillingBattleToolBar()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.MAINUI)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("BattleToolBar") as Sprite;
				layer.x = 5;
				layer.y = 480;
				this.addChild(layer);
				
				initParams();
				initUI();
				setParams();
				maskTest();
			}
		}
		
		private function initParams():void{
			
		}
		
		private var _buringTip:Sprite;
		private function initUI():void{
			for each(var item:String in nameList){
				var skillIcon:BaseNativeEntity = new BaseNativeEntity();
				(layer["SkillIcon_" + item] as Sprite).addChild(skillIcon);
				(layer["SkillMask_" + item] as Sprite).visible = false;
			}
			setBuringTip();
		}
		
		public function setBuringTip() : void{
			_buringTip = new Sprite();
			_buringTip.graphics.beginFill(0xFFFFFF, 0);
			_buringTip.graphics.drawCircle(45, 50, 45);
			_buringTip.graphics.endFill();
			_buringTip.x = 5;
			_buringTip.y = 480;
			this.addChild(_buringTip);
			var info:String;
			switch(PlayerManager.getIns().player.occupation){
				case OccupationConst.KUANGWU:
					info = "持续霸体，移速加快";
					break;
				case OccupationConst.XIAOYAO:
					info = "伤害加深，闪避提高";
					break;
			}
			info += "\n\n按空格键释放"
			TipsManager.getIns().addTips(_buringTip, {title:"怒气爆发", tips:info});
		}
		
		public function onBuringDown() : void{
			if(_buringFull.parent != null){
				_buringFull.parent.removeChild(_buringFull);
			}
			_buringDown.setAction(ActionState.SHOW);
			layer.addChild(_buringDown);
			layer.addChild(_buringRelease);
			_buringRelease.setAction(ActionState.SHOW);
			_buringRelease.funcWhenActionOver = addBuringDown;
		}
		
		private function addBuringDown(...args) : void{
			if(_buringRelease.parent != null){
				_buringRelease.parent.removeChild(_buringRelease);
			}
			_buringRelease.funcWhenActionOver = null;
		}
		
		public function removeBuringDown() : void{
			if(_buringDown != null && _buringDown.parent != null){
				_buringDown.parent.removeChild(_buringDown);
			}
		}
		
		//设置技能冷却时间
		public function setCoolDown(skillID:int, time:int) : void{
			for(var i:int = 0; i < nameList.length; i++){
				if(PlayerManager.getIns().player.skill["skill_" + nameList[i]] == skillID){
					_coolDownTime[i] = time;
					_nowCoolDownTime[i] = time;
					(layer["SkillMask_" + nameList[i]] as Sprite).visible = true;
					(layer["SkillMask_" + nameList[i]] as Sprite).height = 32;
				}
			}
		}
		
		override public function step():void{
			coolDownStep();
		}
		
		public function skillMpSet(input:Array) : void{
			if(layer == null) return;
			var index:int;
			for(var i:int = 0; i < nameList.length; i++){
				index = PlayerManager.getIns().player.skill["skill_" + nameList[i]];
				if(input[index - 1] == 1){
					GreyEffect.reset((layer["SkillIcon_" + nameList[i]] as Sprite).getChildAt(0) as BaseNativeEntity);
				}else{
					GreyEffect.change((layer["SkillIcon_" + nameList[i]] as Sprite).getChildAt(0) as BaseNativeEntity);
				}
			}
		}
		
		//技能冷却时间遮罩
		private function coolDownStep() : void{
			for(var i:int = 0; i < nameList.length; i++){
				if(layer != null){
					if(_nowCoolDownTime[i] > 0){
						_nowCoolDownTime[i]--;
						(layer["SkillMask_" + nameList[i]] as Sprite).visible = true;
						(layer["SkillMask_" + nameList[i]] as Sprite).height = 32 * _nowCoolDownTime[i] / _coolDownTime[i];
					}else{
						(layer["SkillMask_" + nameList[i]] as Sprite).visible = false;
						(layer["SkillMask_" + nameList[i]] as Sprite).height = 32;
					}
				}
			}
		}
		
		public function resetCoolDownTime() : void{
			_nowCoolDownTime = [0, 0, 0, 0, 0];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			this.renderSpeed = 1;
			var info:Array = SkillManager.getIns().getSkillInfo();
			for each(var item:String in nameList){
				var bitmapData:BitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "SkillIcon" + PlayerManager.getIns().player.skill["skill_" + item]) as BitmapData;
				((layer["SkillIcon_" + item] as Sprite).getChildAt(0) as BaseNativeEntity).data.bitmapData = bitmapData;
				((layer["SkillIcon_" + item] as Sprite).getChildAt(0) as BaseNativeEntity).data.width = 30;
				((layer["SkillIcon_" + item] as Sprite).getChildAt(0) as BaseNativeEntity).data.height = 30;
				
				if(bitmapData == null){
					TipsManager.getIns().removeTips((layer["SkillIcon_" + item] as Sprite));
				}else{
					var index:int = PlayerManager.getIns().player.skill["skill_" + item];
					var content:String = "元气消耗：" + info[index - 1].mp + "\n冷却时间：" + info[index - 1].cooldown / 30 + "s";
					TipsManager.getIns().addTips((layer["SkillIcon_" + item] as Sprite), {title:info[index - 1].skill_name, tips:content});
				}
			}
			
			if(_buringDown == null){
				_buringDown = AnimationEffect.createAnimation(10002, ["BuringDown"], false);
				_buringFull = AnimationEffect.createAnimation(10003, ["BuringFull"], false);
				_buringRelease = AnimationEffect.createAnimation(10004, ["BuringRelease"], false);
				RenderEntityManager.getIns().removeEntity(_buringDown);
				RenderEntityManager.getIns().removeEntity(_buringFull);
				RenderEntityManager.getIns().removeEntity(_buringRelease);
				
				AnimationManager.getIns().addEntity(_buringDown);
				AnimationManager.getIns().addEntity(_buringFull);
				AnimationManager.getIns().addEntity(_buringRelease);
				
				_buringFull.x = -4;
				_buringFull.y = -14;
				_buringFull.mouseChildren = false;
				_buringFull.mouseEnabled = false;
				_buringRelease.x = -25;
				_buringRelease.y = -23;
				_buringRelease.mouseChildren = false;
				_buringRelease.mouseEnabled = false;
				_buringDown.x = 1;
				_buringDown.y = -8;
				_buringDown.scaleX = .9;
				_buringDown.scaleY = .9;
				_buringDown.mouseChildren = false;
				_buringDown.mouseEnabled = false;
			}
		}
		
		private function maskTest():void{
			_mask = new Sprite();
			_mask.graphics.beginFill(0xFF0000);
			_mask.graphics.drawRect(-220, 0, 220, 20);
			_mask.graphics.endFill();
			_mask.x = 220;
			_mask.width = 0;
			PowerBar.addChild(_mask);
			PowerBar.mask = _mask;
		}
		
		public function setAnger(rate:Number) : void{
			if(rate <= 0){
				rate = 0;
			}else if(rate > 1){
				rate = 1;
			}
			TweenLite.to(_mask, 1, {width:rate * 220});
			if(rate == 1 && _buringFull != null){
				layer.addChild(_buringFull);
			}
		}
		
		public function get PowerBar():Sprite{
			return layer["PowerBar"];
		}
		
		override public function hide() : void{
			super.hide();
			buringClear();
		}
		
		private function buringClear() : void{
			if(_buringDown){
				AnimationManager.getIns().removeEntity(_buringDown);
				_buringDown.destroy();
				_buringDown = null;
			}
			if(_buringFull){
				AnimationManager.getIns().removeEntity(_buringFull);
				_buringFull.destroy();
				_buringFull = null;
			}
			if(_buringRelease){
				AnimationManager.getIns().removeEntity(_buringRelease);
				_buringRelease.destroy();
				_buringRelease = null;
			}
		}
		
		override public function destroy():void{
			_mask = null;
			layer = null;
			if(_buringTip.parent != null){
				_buringTip.parent.removeChild(_buringTip);
			}
			_buringTip = null;
			buringClear();
			super.destroy();
		}
	}
}