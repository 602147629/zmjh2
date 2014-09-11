package com.test.game.Modules.MainGame.MainUI
{
	import com.greensock.TweenLite;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.Const.OccupationConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Data.SkillConfigurationVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class BattleToolBar extends Sprite
	{
		public var layer:Sprite;
		public var nameList:Array = ["H", "U", "I", "O", "L"];
		protected var _player:PlayerVo;
		private var _mask:Sprite;
		private var _coolDownTime:Array = [0, 0, 0, 0, 0];
		private var _nowCoolDownTime:Array = [0, 0, 0, 0, 0];
		private var _buringDown:BaseSequenceActionBind;
		private var _buringRelease:BaseSequenceActionBind;
		private var _buringFull:BaseSequenceActionBind;
		public function BattleToolBar(player:PlayerVo){
			_player = player;
			start();
		}
		
		protected function start() : void{
			layer = AssetsManager.getIns().getAssetObject("BattleToolBar") as Sprite;
			layer.x = 5;
			layer.y = 480;
			
			initUI();
			maskTest();
		}
		
		private var _buringTip:Sprite;
		private function initUI():void{
			setSkillIcon();
			setBuringTip();
			skillLetter.mouseChildren = false;
			skillLetter.mouseEnabled = false;
		}
		
		public function setSkillIcon() : void{
			for each(var item:String in nameList){
				var skillIcon:BaseNativeEntity = new BaseNativeEntity();
				(layer["SkillIcon_" + item] as Sprite).addChild(skillIcon);
				(layer["SkillMask_" + item] as Sprite).visible = false;
				var mask:Sprite = new Sprite();
				(layer["SkillMask_" + item] as Sprite).addChild(mask);
				(layer["SkillMask_" + item] as Sprite).mask = mask;
				mask.x = 34;
				mask.y = -24;
			}
		}
		
		public function setBuringTip() : void{
			_buringTip = new Sprite();
			_buringTip.graphics.beginFill(0xFFFFFF, 0);
			_buringTip.graphics.drawCircle(45, 50, 45);
			_buringTip.graphics.endFill();
			_buringTip.x = 0;
			_buringTip.y = 0;
			layer.addChild(_buringTip);
		}
		
		private function addTip() : void{
			var info:String;
			switch(_player.occupation){
				case OccupationConst.KUANGWU:
					info = "持续霸体，移速加快";
					break;
				case OccupationConst.XIAOYAO:
					info = "伤害加深，闪避提高";
					break;
			}
			info += "\n\n按空格键释放";
			TipsManager.getIns().removeTips(_buringTip);
			TipsManager.getIns().addTips(_buringTip, {title:"怒气爆发", tips:info});
		}
		
		public function onBuringDown() : void{
			if(_buringFull != null && _buringFull.parent != null){
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
				if(_player.skill["skill_" + nameList[i]] == skillID){
					_coolDownTime[i] = time;
					_nowCoolDownTime[i] = time;
					(layer["SkillMask_" + nameList[i]] as Sprite).visible = true;
				}
			}
		}
		
		public function step():void{
			coolDownStep();
		}
		
		public function skillMpSet(input:Array) : void{
			if(layer == null) return;
			var index:int;
			for(var i:int = 0; i < nameList.length; i++){
				index = _player.skill["skill_" + nameList[i]];
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
						drawSector(((layer["SkillMask_" + nameList[i]] as Sprite).mask as Sprite).graphics, 360 * (_nowCoolDownTime[i] / _coolDownTime[i]));
						(layer["SkillMask_" + nameList[i]] as Sprite).visible = true;
					}else{
						(layer["SkillMask_" + nameList[i]] as Sprite).visible = false;
					}
				}
			}
		}
		
		public function resetCoolDownTime() : void{
			_nowCoolDownTime = [0, 0, 0, 0, 0];
		}
		
		public function show() : void{
			initBuring();
			addTip();
			updateScale();
			updateLetter();
			LayerManager.getIns().gameLayer.addChild(layer);
		}
		
		protected function updateLetter() : void{
			skillLetter.gotoAndStop(1);
		}
		
		protected function updateScale() : void{
			if(MapManager.getIns().isTwoPlayerMap){
				if(GameSceneManager.getIns().partnerOperate){
					layer.scaleX = .8;
					layer.scaleY = .8;
					layer.x = 5;
					layer.y = 500;
				}else{
					layer.scaleX = 1;
					layer.scaleY = 1;
					layer.x = 5;
					layer.y = 480;
				}
			}else{
				layer.scaleX = 1;
				layer.scaleY = 1;
				layer.x = 5;
				layer.y = 480;
			}
		}
		
		private function initBuring() : void{
			if(_buringDown == null){
				_buringDown = AnimationEffect.createAnimation(10002, ["BuringDown"], false);
				_buringDown.x = 1;
				_buringDown.y = -8;
				_buringDown.mouseChildren = false;
				_buringDown.mouseEnabled = false;
				_buringDown.scaleX = .9;
				_buringDown.scaleY = .9;
				RenderEntityManager.getIns().removeEntity(_buringDown);
				AnimationManager.getIns().addEntity(_buringDown);
				
				_buringFull = AnimationEffect.createAnimation(10003, ["BuringFull"], false);
				_buringFull.x = -4;
				_buringFull.y = -14;
				_buringFull.mouseChildren = false;
				_buringFull.mouseEnabled = false;
				RenderEntityManager.getIns().removeEntity(_buringFull);
				AnimationManager.getIns().addEntity(_buringFull);
				
				_buringRelease = AnimationEffect.createAnimation(10004, ["BuringRelease"], false);
				_buringRelease.x = -25;
				_buringRelease.y = -23;
				_buringRelease.mouseChildren = false;
				_buringRelease.mouseEnabled = false;
				RenderEntityManager.getIns().removeEntity(_buringRelease);
				AnimationManager.getIns().addEntity(_buringRelease);
			}
		}
		
		public function setShowInfo(config:SkillConfigurationVo) : void{
			var info:Array = SkillManager.getIns().getSkillInfo(_player.occupation);
			for each(var item:String in nameList){
				var bitmapData:BitmapData = AUtils.getNewObj(_player.fodder + "SkillIcon" + _player.skill["skill_" + item]) as BitmapData;
				((layer["SkillIcon_" + item] as Sprite).getChildAt(0) as BaseNativeEntity).data.bitmapData = bitmapData;
				((layer["SkillIcon_" + item] as Sprite).getChildAt(0) as BaseNativeEntity).data.width = 30;
				((layer["SkillIcon_" + item] as Sprite).getChildAt(0) as BaseNativeEntity).data.height = 30;
				
				if(bitmapData == null){
					TipsManager.getIns().removeTips((layer["SkillIcon_" + item] as Sprite));
				}else{
					var index:int = _player.skill["skill_" + item];
					var name:String = info[index - 1].skill_name + getSkillLevel(index);
					var num:Number = PlayerManager.getIns().hasProtect?0.5:1;
					var content:String = "元气消耗：" + (num==1?int(config.mpUseList[index - 1]):0) + "\n冷却时间：" + int(config.skillColdTimeList[index - 1] / 30 * 10 * num) / 10 + "s";
					TipsManager.getIns().addTips((layer["SkillIcon_" + item] as Sprite), {title:name, tips:content});
				}
			}
		}
		
		private function getSkillLevel(index:int) : String{
			var result:String = "";
			if(_player.skillUp != null){
				switch(int(_player.skillUp.skillLevels[index - 1])){
					case 1:
						result = "（固本）";
						break;
					case 2:
						result = "（培元）";
						break;
					case 3:
						result = "（精进）";
						break;
					case 4:
						result = "（突破）";
						break;
					case 5:
						result = "（大成）";
						break;
				}
			}
			return result;
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
		
		public function get skillLetter() : MovieClip{
			return layer["SkillLetter"];
		}
		
		public function get PowerBar():Sprite{
			return layer["PowerBar"];
		}
		
		public function hide() : void{
			if(layer.parent != null){
				layer.parent.removeChild(layer);
			}
			buringClear();
		}
		
		private function drawSector(g:Graphics,lAngle:Number,x:Number = -18, y:Number = 8, radius:Number = 30, sAngle:Number = -90):void{
			g.clear();
			g.beginFill(0xFF0000);
			var sx:Number = radius;
			var sy:Number = 0;
			if (sAngle != 0) {
				sx = Math.cos(sAngle * Math.PI/180) * radius;
				sy = Math.sin(sAngle * Math.PI/180) * radius;
			}
			g.moveTo(x, y);
			g.lineTo(x + sx, y +sy);
			var a:Number =  lAngle * Math.PI / 180 / lAngle;
			var cos:Number = Math.cos(a);
			var sin:Number = Math.sin(a);
			var b:Number = 0;
			for (var i:Number = 0; i < lAngle; i++) {
				var nx:Number = cos * sx - sin * sy;
				var ny:Number = cos * sy + sin * sx;
				sx = nx;
				sy = ny;
				g.lineTo(sx + x, sy + y);
			}
			g.lineTo(x, y);
			g.endFill();
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
		
		public function destroy():void{
			_mask = null;
			TipsManager.getIns().removeTips(_buringTip);
			if(_buringTip.parent != null){
				_buringTip.parent.removeChild(_buringTip);
			}
			_buringTip = null;
			buringClear();
			if(layer.parent != null){
				layer.parent.removeChild(layer);
			}
			layer = null;
		}
		
	}
}