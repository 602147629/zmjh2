package com.test.game.Manager.Effect
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.SequenceConst;
	import com.test.game.Const.HurtHpConst;
	import com.test.game.Effect.AnimationHurtEffect;
	import com.test.game.Effect.CritEffect;
	import com.test.game.Effect.EvasionEffect;
	import com.test.game.Effect.HurtEffect;
	import com.test.game.Effect.ScoreEffect;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Entitys.Effect.EffectEntity;
	import com.test.game.Entitys.Effect.ExtraEffectEntity;
	import com.test.game.Entitys.Effect.SwordEntity;
	import com.test.game.Entitys.Roles.XiaoYaoEntity;
	import com.test.game.Manager.GameSettingManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Mvc.Vo.EffectVo;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class EffectManager extends Singleton
	{
		private var _effects:Vector.<BaseNativeEntity>= new Vector.<BaseNativeEntity>();
		private var _blur:Vector.<BaseNativeEntity> = new Vector.<BaseNativeEntity>();
		private var _swordRole:Vector.<CharacterEntity> = new Vector.<CharacterEntity>();
		private var _hurt:Vector.<BaseNativeEntity> = new Vector.<BaseNativeEntity>();
		public var scoreDigital:Dictionary = new Dictionary();
		public var atkHps:Vector.<BitmapData> = new Vector.<BitmapData>();
		public var atsHps:Vector.<BitmapData> = new Vector.<BitmapData>();
		public var chaosHps:Vector.<BitmapData> = new Vector.<BitmapData>();
		public var regainHps:Vector.<BitmapData> = new Vector.<BitmapData>();
		public var littleAtkHps:Vector.<BitmapData> = new Vector.<BitmapData>();
		public var littleAtsHps:Vector.<BitmapData> = new Vector.<BitmapData>();
		public var littleChaosHps:Vector.<BitmapData> = new Vector.<BitmapData>();
		public var littleRegainHps:Vector.<BitmapData> = new Vector.<BitmapData>();
		public var hurtCount:int = 0;
		private static const MAX_HURT_COUNT:int = 100;
		
		public function EffectManager()
		{
			super();
			init();
		}
		
		private function init():void{
			for(var i:int = 0; i < 10; i++){
				atkHps.push(AUtils.getNewObj("AtkHp" + i) as BitmapData);
				atsHps.push(AUtils.getNewObj("AtsHp" + i) as BitmapData);
				chaosHps.push(AUtils.getNewObj("ChaosHp" + i) as BitmapData);
				regainHps.push(AUtils.getNewObj("RegainHp" + i) as BitmapData);
				littleAtkHps.push(AUtils.getNewObj("LittleAtkHp" + i) as BitmapData);
				littleAtsHps.push(AUtils.getNewObj("LittleAtsHp" + i) as BitmapData);
				littleChaosHps.push(AUtils.getNewObj("LittleChaosHp" + i) as BitmapData);
				littleRegainHps.push(AUtils.getNewObj("LittleRegainHp" + i) as BitmapData);
			}
		}
		
		public static function getIns():EffectManager{
			return Singleton.getIns(EffectManager);
		}
		
		public function step() : void{
			tweenAlpha();
			swordPos();
		}
		
		public function createDigital(count:int, layer:Sprite, mark:String) : void{
			var score:ScoreEffect = new ScoreEffect();
			scoreDigital[mark] = score.createScore(count, layer);
		}
		
		public function setLastDigital() : void{
			for each(var item:Object in scoreDigital){   
				item.setLast();
			}
		}
		
		public function clearDigital() : void{
			for each(var item:Object in scoreDigital){   
				item.destroy();
			}
			scoreDigital = new Dictionary();
		}
		
		public function createHurtNum(count:int, pos:Point, type:int) : void{
			if(count == 0) return;
			if(hurtCount < MAX_HURT_COUNT){
				hurtCount++;
				if(GameSettingManager.getIns().stageQuality > 2 && RoleManager.getIns().fightType == 0){
					var animationHurtNum:AnimationHurtEffect = new AnimationHurtEffect(type, count, pos);
				}else{
					var hurtNum:HurtEffect = new HurtEffect(type, count, pos);
				}
			}
		}
		
		public function getHurtSource(type:int) : Vector.<BitmapData> {
			if(GameSettingManager.getIns().stageQuality > 2 && RoleManager.getIns().fightType == 0){
				switch(type){
					case HurtHpConst.ATK_HP:
						return atkHps;
						break;
					case HurtHpConst.ATS_HP:
						return atsHps;
						break;
					case HurtHpConst.CHAOS_HP:
						return chaosHps;
						break;
					case HurtHpConst.REGAIN_HP:
						return regainHps;
						break;
					default:
						return atkHps;
						break;
				}
			}else{
				switch(type){
					case HurtHpConst.ATK_HP:
						return littleAtkHps;
						break;
					case HurtHpConst.ATS_HP:
						return littleAtsHps;
						break;
					case HurtHpConst.CHAOS_HP:
						return littleChaosHps;
						break;
					case HurtHpConst.REGAIN_HP:
						return littleRegainHps;
						break;
					default:
						return littleAtkHps;
						break;
				}
			}
		}
		
		public function createCrit(pos:Point) : void{
			var critEffect:CritEffect = new CritEffect(pos);
		}
		
		public function createEvasion(pos:Point) : void{
			var evasionEffect:EvasionEffect = new EvasionEffect(pos);
		}
		
		//逍遥剑气跟随
		public function createSwordEffect(role:CharacterEntity) : Vector.<BaseNativeEntity>{
			var swordVo:EffectVo = new EffectVo(SequenceConst.SWORD, ["Sword"], true);
			
			var _sword:Vector.<BaseNativeEntity> = new Vector.<BaseNativeEntity>();
			for(var j:int = 0; j < _sword.length; j++){
				(_sword[j] as SwordEntity).destroy();
			}
			_sword.length = 0;
			
			for(var i:int = 0; i < 4; i++){
				var sword:SwordEntity = new SwordEntity(swordVo, role, ActionState.HIT);
				if(SceneManager.getIns().nowScene != null){
					SceneManager.getIns().nowScene.addChild(sword);
				}
				_sword.push(sword);
			}
			if(this._swordRole.indexOf(role) == -1){
				this._swordRole.push(role);
			}
			return _sword;
		}
		
		//剑气位置
		private function swordPos() : void{
			for(var i:int = 0; i < _swordRole.length; i++){
				(_swordRole[i] as XiaoYaoEntity).swordPos();
			}
		}
		
		//创建残影		
		public function createBlurEffect(body:BaseSequenceActionBind, pos:Point) : void{
			var action:Vector.<BaseNativeEntity> = body.getTotalChildEntitys();
			var bp:BaseNativeEntity = new BaseNativeEntity();
			var register:Point = new Point();
			var offsetPoint:Point = new Point();
			for each(var bn:BaseNativeEntity in action){
				if(bn.visible && bn.data.bitmapData != null && bn.name != "PlayerNameTip"){
					if(bn.registerPoint.x != 0 && bn.registerPoint.y != 0){
						offsetPoint.x = (offsetPoint.x < bn.registerPoint.x?bn.registerPoint.x:offsetPoint.x);
						offsetPoint.y = (offsetPoint.y < bn.registerPoint.y?bn.registerPoint.y:offsetPoint.y);
					}
				}
			}
			
			bp.data.bitmapData = new BitmapData(body.width, body.height, true, 0x00FFFFFF);
			for each(var baseNative:BaseNativeEntity in action){
				if(baseNative.visible && baseNative.data.bitmapData != null && baseNative.name != "PlayerNameTip"){
					register = new Point(-baseNative.registerPoint.x + offsetPoint.x, -baseNative.registerPoint.y + offsetPoint.y);
					bp.data.bitmapData.copyPixels(baseNative.data.bitmapData, baseNative.data.bitmapData.rect, register,null,null,true);
				}
			}
			bp.pos = new Point(pos.x - offsetPoint.x, pos.y - offsetPoint.y);
			bp.alpha = .8;
			if(SceneManager.getIns().nowScene != null){
				SceneManager.getIns().nowScene.addChildAt(bp, 0);
			}
			this._blur.push(bp);
		}
		
		//残影消失
		private function tweenAlpha() : void{
			for each(var bp:BaseNativeEntity in _blur){
				bp.alpha -= .05;
				if(bp.alpha <= 0){
					destroyBlur(bp);
				}
			}
		}
		
		//伤害效果
		public function createHitEffect(role:CharacterEntity) : void
		{
			var effectVo:EffectVo = new EffectVo(SequenceConst.HIT_EFFECT, ["HitEffect"], false);
			
			var effect1:EffectEntity = new EffectEntity(effectVo, role, ActionState.HIT1);
			effect1.name = "HitEffect";
			addEffect(effect1);
			var effect:EffectEntity = new EffectEntity(effectVo, role, ActionState.HIT);
			effect.name = "HitEffect";
			addEffect(effect);
		}
		
		public function createInvincible(role:CharacterEntity) : void{
			var effectVo:EffectVo = new EffectVo(SequenceConst.HIT_EFFECT, ["HitEffect"], false);
			
			var effect:EffectEntity = new EffectEntity(effectVo, role, ActionState.HIT);
			effect.name = "HitEffect";
			addEffect(effect);
		}
		
		public function createUnMove(pos:Point) : void{
			var effectVo:EffectVo = new EffectVo(SequenceConst.HIT_EFFECT, ["HitEffect"], false);
			var effect1:ExtraEffectEntity = new ExtraEffectEntity(effectVo, pos, ActionState.HIT1);
			effect1.name = "HitEffect";
			addEffect(effect1);
			var effect:ExtraEffectEntity = new ExtraEffectEntity(effectVo, pos, ActionState.HIT);
			effect.name = "HitEffect";
			addEffect(effect);
		}
		
		private function addEffect(effect:BaseNativeEntity) : void{
			if(SceneManager.getIns().nowScene != null){
				SceneManager.getIns().nowScene.addChild(effect);
			}
			this._effects.push(effect);
		}
		
		public function destroyEffect(effect:BaseNativeEntity):void{
			var idx:int = this._effects.indexOf(effect);
			if(idx != -1){
				if(effect.parent != null){
					effect.parent.removeChild(effect);
				}
				effect.destroy();
				this._effects.splice(idx,1);
			}
		}
		
		public function destroyBlur(blur:BaseNativeEntity):void{
			var idx:int = this._blur.indexOf(blur);
			if(idx != -1){
				if(blur.parent != null){
					blur.parent.removeChild(blur);
				}
				blur.destroy();
				this._blur.splice(idx,1);
			}
		}
		
		public function clear():void{
			var effects:Vector.<BaseNativeEntity> = this._effects.concat();
			for each(var effect:BaseNativeEntity in effects){
				destroyEffect(effect);
			}
			effects.length = 0;
			effects = null;
			
			var blurs:Vector.<BaseNativeEntity> = this._blur.concat();
			for each(var blur:BaseNativeEntity in blurs){
				destroyBlur(blur);
			}
			blurs.length = 0;
			blurs = null;
			
			_swordRole.length = 0;
			
			_effects.length = 0;
			_blur.length = 0;
			hurtCount = 0;
		}
	}
}