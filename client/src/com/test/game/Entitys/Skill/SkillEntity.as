package com.test.game.Entitys.Skill{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.game.ResourceOperation.BitmapDataPool;
	import com.superkaka.game.ResourceOperation.SequenceBmdObject;
	import com.superkaka.mvc.ControlFactory;
	import com.test.game.AgreeMent.Battle.IAttackAble;
	import com.test.game.AgreeMent.Battle.IBeHurtAble;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.RoleFollowSkillConst;
	import com.test.game.Const.SkillHandConst;
	import com.test.game.Const.SkillMoveConst;
	import com.test.game.Const.SkillType;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Conjure.ConjureEntity;
	import com.test.game.Event.SkillEvent;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Configuration.SkillUp;
	import com.test.game.Mvc.Vo.SkillVo;
	import com.test.game.Mvc.control.View.GameSceneControl;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class SkillEntity extends SequenceActionEntity implements IHurtAble, IBeHurtAble{
		private var _lastBeHurtSource:IHurtAble;//最后一次被攻击的伤害来源
		private static var ID:uint = 0;
		protected var _hurtSource:IAttackAble;//攻击来源
		private var _beAttackedIdVec:Vector.<int> = new Vector.<int>;//被攻击过的id数组(防止重复攻击用)
		private var _skillId:uint;
		private var _skillVo:SkillVo;
		private var _attackId:int;
		private var _repeatCount:int = 0;
		private var _allStep:int = 0;
		protected var _canDestroy:Boolean;
		protected var _skillConfiguration:Object;
		private var _spendFrame:int;
		private var _lock:Boolean;
		
		public var shadow:BaseNativeEntity;
		//技能移动数组
		protected var skillMoveList:Array = new Array();
		//技能位置数组
		private var positionList:Array = new Array();
		//技能释放者移动数组
		private var roleMoveList:Array = new Array();
		private var handMoveList:Array = new Array();
		//击飞向量（为空不击飞）
		private var _attackBackAxis:Array = new Array();
		
		public var isHurt:Boolean = true;
		private var appointFrame:Array = new Array();
		private var appointSkill:Array = new Array();
		private var _locateDistanceX:int;
		private var _locateDistanceY:int;
		private var _locateDistanceBodyY:int;
		
		public function SkillEntity(skillVo:SkillVo, source:IAttackAble, skillData:Object){
			this._skillVo = skillVo;
			this._hurtSource = source;
			this.initSkillConfiguration(skillData);
			this.isRectCollision = this._skillVo.isRectCollision;
			
			super();
			
			_skillId = getID();
			_attackId = _skillId * 1000;
			
			RenderEntityManager.getIns().addEntity(this);
		}
		
		protected function initSkillConfiguration(skillData:Object):void
		{
			_skillConfiguration = skillData.copy();
			
			var skillPos:Point;
			var obj:CharacterEntity = (_hurtSource as CharacterEntity);
			var offset:int = (obj.shadow.y - 50);
			if(obj.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
				skillPos = new Point(obj.shadowPos.x - _skillConfiguration.xPos, obj.bodyPos.y + _skillConfiguration.zPos + offset);
			}else  if((_hurtSource as CharacterEntity).faceHorizontalDirect == DirectConst.DIRECT_RIGHT){
				skillPos = new Point(obj.shadowPos.x + _skillConfiguration.xPos, obj.bodyPos.y + _skillConfiguration.zPos + offset);
			}else{
				skillPos = new Point(obj.shadowPos.x + _skillConfiguration.xPos, obj.bodyPos.y + _skillConfiguration.zPos + offset);
			}
			pos = skillPos;
			
			if((_hurtSource as CharacterEntity).faceHorizontalDirect == DirectConst.DIRECT_LEFT){
				_attackBackAxis = [-_skillConfiguration.hurtMoveX, -_skillConfiguration.hurtMoveY, -_skillConfiguration.hurtMoveZ];
			}else if((_hurtSource as CharacterEntity).faceHorizontalDirect == DirectConst.DIRECT_RIGHT){
				_attackBackAxis = [_skillConfiguration.hurtMoveX, -_skillConfiguration.hurtMoveY, -_skillConfiguration.hurtMoveZ];
			}else{
				_attackBackAxis = [_skillConfiguration.hurtMoveX, -_skillConfiguration.hurtMoveY, -_skillConfiguration.hurtMoveZ];
			}
			
			skillMoveList = [_skillConfiguration.skillMoveX, _skillConfiguration.skillMoveY, _skillConfiguration.skillMoveZ];
			roleMoveList = [_skillConfiguration.roleMoveX, _skillConfiguration.roleMoveY, _skillConfiguration.roleMoveZ];
			handMoveList = [_skillConfiguration.handX, _skillConfiguration.handY, _skillConfiguration.handX];
			
			this.setSkillUpConfiguration();
			//buff
			var buffTypeList:Array = skillConfiguration.buff_type.split("|");
			var buffValueList:Array = skillConfiguration.buff_value.split("|");
			
			for(var i:int = 0; i < buffTypeList.length; i++){
				if(int(buffTypeList[i]) != 0){
					if(obj is ConjureEntity){
						SceneManager.getIns().addConBuff(obj as ConjureEntity, buffTypeList[i], buffValueList[i]);
					}else{
						obj.charData.addBuff(buffTypeList[i], buffValueList[i]);
					}
				}
			}
			
			appointFrame = skillConfiguration.appoint_frame.split("|");
			appointSkill = skillConfiguration.appoint_skill.split("|");
			
			if(_skillConfiguration.shake != 0){
				(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).shakeLayer(durationFrame, .2);
			}
			/*if(_skillConfiguration.shake == 1){
				(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).shakeLayer(durationFrame, .4);
			}else if(_skillConfiguration.shake == 2){
				(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).shakeLayer(durationFrame);
			}else if(_skillConfiguration.shake == 3){
				(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).shakeLayer(durationFrame, .2);
			}*/
		}
		
		private function setSkillUpConfiguration():void{
			var obj:PlayerEntity = (_hurtSource as PlayerEntity);
			if(obj is PlayerEntity){
				var arr:Array = _skillVo.assetsArray[0].split("_");
				var str1:String = obj.player.fodder + "Skill";
				var str2:String = arr[0];
				var id:int = int(str2.substr(str1.length));
				if(str2 == "Sword"){
					id = 1;
				}
				if(obj.player.skillUp != null){
					if(obj.player.skillUp.skillLevels[id - 1] > 0){
						var index:int = (obj.player.occupation * 1000 + int((id - 1) / 5) * 100 + (obj.player.skillUp.skillLevels[id - 1]) * 10 + (id - 1) % 5 + 1);
						var skillUp:SkillUp = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SKILL_UP, "id", index) as SkillUp;
						if(arr.length >= 2){
							if(_skillConfiguration.atk_rate != 0){
								_skillConfiguration.atk_rate = Number(skillUp.atk_rate.split("|")[int(arr[1]) - 1]);
							}
							if(_skillConfiguration.ats_rate != 0){
								_skillConfiguration.ats_rate = Number(skillUp.ats_rate.split("|")[int(arr[1]) - 1]);
							}
							_skillConfiguration.attackIntervalFrame = int(skillUp.attackIntervalFrame.split("|")[int(arr[1]) - 1]);
							_skillConfiguration.collisionRange = int(skillUp.collisionRange.split("|")[int(arr[1]) - 1]);
						}else{
							_skillConfiguration.atk_rate = Number(skillUp.atk_rate);
							_skillConfiguration.ats_rate = Number(skillUp.ats_rate);
							_skillConfiguration.attackIntervalFrame = int(skillUp.attackIntervalFrame);
							_skillConfiguration.collisionRange = int(skillUp.collisionRange);
						}
						if(_skillConfiguration.buff_type != 0){
							_skillConfiguration.buff_type = skillUp.buff_type;
							_skillConfiguration.buff_value = skillUp.buff_value;
						}
					}
				}
			}
		}
		
		public static function getID() : uint
		{
			ID++;
			if(ID > 99999)
				ID = 0;
			return ID;
		}
		
		protected var _hit:BaseSequenceActionBind;
		override protected function initSequenceAction():void{
			if(!this._skillVo.assetsArray){
				throw new Error("技能素材不能为空！");
			}
			
			this.bodyAction = new BaseSequenceActionBind(this._skillVo);
			this.bodyAction.y = _skillConfiguration.yPos;
			this.setAction(ActionState.HIT);
			
			super.initSequenceAction();
			
			this.initCollision();
		}
		
		override protected function initCallBack():void{
			super.initCallBack();
			
			this.initShadow();
		}
		
		private var _hitName:String;
		public function get hitName() : String{
			return _hitName;
		}
		private function initCollision() : void{
			//return;
			//if(hurtSource is PlayerEntity){
				//添加碰撞层
				var hitVo:SkillVo = this._skillVo.clone();
				hitVo.isCacheData = !hitVo.isRectCollision;
				var hitName:String = "Collision" + (hitVo.assetsArray[0] as String).split("Fashion")[0];
				//var ai:AssetsItem = AssetsManager.getIns().getAssetsItem(AssetsUrl.SKILL_COLLISION);
				//var cc:MovieClip = ai.getAssetObject(hitName) as MovieClip;
				//注册碰撞素材
				BitmapDataPool.registerData(hitName, hitVo.isDouble,hitVo.isCacheData);
				_hitName = hitName;
				//初始化碰撞对象
				hitVo.assetsArray = [hitName];
				this._hit = new BaseSequenceActionBind(hitVo);
				this._hit.setAction(ActionState.HIT);
				this._hit.direct = (_hurtSource as CharacterEntity).faceHorizontalDirect;
				this._hit.y = _skillConfiguration.yPos;
				this.addChild(this._hit);
				
				if(!hitVo.isCacheData){
					//矩形碰撞
					this.collisionBody = new BaseNativeEntity();
					this.collisionBody.y = this.bodyAction.y;
					this.addChild(this.collisionBody);
					this.renderHit();
				}else{
					//精确碰撞
					this.collisionBody = this._hit.getActionByIndex(0);
				}
				//this.collisionBody.visible = false;
			//}
		}
		
		/**
		 * 每帧计算碰撞区域 
		 * 
		 */		
		private function renderHit():void{
			if(this._hit){
				if(this._hit.dataVo && this._hit.dataVo.isCacheData){
					return;
				}
			}else{
				return;
			}
			var sbo:SequenceBmdObject = this._hit.getActionByIndex(0).currentSequenceBmdObject;
			if(sbo && sbo.width > 10 && sbo.height > 10){
				this.collisionBody.registerPoint = sbo.registerPoint.clone();
				if(!this.collisionBody.data.bitmapData){
					this.collisionBody.data.bitmapData = new BitmapData(sbo.width,sbo.height,true,0xff0000);
				}else{
					if(this.collisionBody.data.bitmapData.rect.width != sbo.width
						|| this.collisionBody.data.bitmapData.rect.height != sbo.height){
						this.collisionBody.data.bitmapData = new BitmapData(sbo.width,sbo.height,true,0xff0000);
					}
				}
			}
		}
		
		public function setBodyPosition(posX:int, posY:int, posZ:int) : void{
			this.x = posX;
			this.bodyAction.x = 0;
			this.bodyAction.y = posY;
			this.y = posZ;
			if(this.collisionBody != null){
				this.collisionBody.x = 0;
				this.collisionBody.y = posY;
			}
		}
		
		/**
		 * 初始化影子 
		 * 
		 */	
		protected function initShadow():void{
			this.shadow = new BaseNativeEntity();
			this.shadow.data.bitmapData = AUtils.getNewObj("shadow") as BitmapData;
			this.shadow.registerPoint = new Point(this.shadow.data.width * .5, this.shadow.data.height * .5);
			this.shadow.y = 50 + (hurtSource as CharacterEntity).y - (hurtSource as CharacterEntity).bodyPos.y;
			this.addChildAt(this.shadow, 0);
			this.shadow.visible = false;
		}
		
		public function setConfiguration() : void{
			setSkillCamp();
			setSkillLocation();
			setSkillFace();
			setSkillRotation();
			setSkillProperty();
		}
		
		private function setSkillProperty():void{
			if(_skillConfiguration.skillProperty == SkillType.REPLACE && (hurtSource as CharacterEntity) is ConjureEntity){
				RoleManager.getIns().createReplacePlayer(this.x, this.y);
			}
		}
		
		private function setSkillRotation():void{
			this.bodyAction.rotationValue = _skillConfiguration.rotation * (this.faceHorizontalDirect==DirectConst.DIRECT_LEFT?-1:1);
		}
		
		private function setSkillFace():void{
			if((_hurtSource as CharacterEntity).faceHorizontalDirect == DirectConst.DIRECT_NONE){
				faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
				moveHorizontalDirect = DirectConst.DIRECT_RIGHT;
			}else{
				faceHorizontalDirect = (_hurtSource as CharacterEntity).faceHorizontalDirect;
				moveHorizontalDirect = (_hurtSource as CharacterEntity).faceHorizontalDirect;
			}
		}
		
		//定位技能
		private function setSkillLocation():void{
			var hurtEntity:CharacterEntity = hurtSource as CharacterEntity;
			if(_skillConfiguration.hurtMoveType == RoleFollowSkillConst.LOCATION){
				if(hurtEntity is PlayerEntity){
					seekSkillTarget();
				}else if(hurtEntity is MonsterEntity){
					seekPlayerTarget();
				}else if(hurtEntity is ConjureEntity){
					seekSkillTarget();
				}
				if(_target != null){
					this.x = _target.x;
					this.y = _target.y;
				}
			}else if(_skillConfiguration.hurtMoveType == RoleFollowSkillConst.ALL_LOCATION){
				if(hurtEntity is PlayerEntity){
					seekSkillTarget();
				}else if(hurtEntity is MonsterEntity){
					seekPlayerTarget();
				}else if(hurtEntity is ConjureEntity){
					seekSkillTarget();
				}
				if(_target != null){
					var lastDistance:int = (_target.x>hurtEntity.x?-_skillConfiguration.locate_distance:_skillConfiguration.locate_distance);
					this.x = _target.x + lastDistance;
					this.y = _target.y;
					hurtEntity.x = _target.x + lastDistance;
					hurtEntity.y = _target.y;
					hurtEntity.bodyAction.y = 0;
				}
			}else if(_skillConfiguration.hurtMoveType == RoleFollowSkillConst.ALL_LOCATION_BY_MOVE){
				if(hurtEntity is PlayerEntity){
					seekSkillTarget();
				}else if(hurtEntity is MonsterEntity){
					seekPlayerTarget();
				}else if(hurtEntity is ConjureEntity){
					seekSkillTarget();
				}
				if(_target != null){
					var distanceX:int = Math.abs(_target.x - hurtEntity.x);
					if(_target.x > (hurtSource as CharacterEntity).x){
						_locateDistanceX = distanceX/_skillConfiguration.locate_frame;
					}else{
						_locateDistanceX = -distanceX/_skillConfiguration.locate_frame;
					}
					var distanceY:int = Math.abs(_target.y - hurtEntity.y);
					if(_target.y > hurtEntity.y){
						_locateDistanceY = distanceY/_skillConfiguration.locate_frame;
					}else{
						_locateDistanceY = -distanceY/_skillConfiguration.locate_frame;
					}
					var distanceZ:int = Math.abs(hurtEntity.bodyAction.y);
					_locateDistanceBodyY = distanceZ/_skillConfiguration.locate_frame;
				}
			}else if(_skillConfiguration.hurtMoveType == RoleFollowSkillConst.TARGET_LOCATION){
				if(_skillConfiguration.xPos != 0){
					hurtEntity.x += (hurtEntity.faceHorizontalDirect==DirectConst.DIRECT_RIGHT?1:-1)*_skillConfiguration.xPos;
				}
				
				if(_skillConfiguration.zPos != 0){
					hurtEntity.y += _skillConfiguration.zPos;
					hurtEntity.y -= 5;
				}
			}
		}
		
		private var _target:SequenceActionEntity;
		//获得目标角色
		public function seekPlayerTarget() : void{
			_target = RoleManager.getIns().target;
		}
		
		public function seekSkillTarget() : void{
			_target = null;
			if(SceneManager.getIns().hasMonsterScene){
				var targets:Vector.<MonsterEntity> = SceneManager.getIns().monsters;
				if(targets.length > 0){
					_target = targets[0];
				}
			}else{
				var char:CharacterEntity = (hurtSource as CharacterEntity);
				if(char.collisionIndex == CollisionFilterIndexConst.CAMP_1){
					_target = SceneManager.getIns().nowScene["otherPlayer"];
				}else if(char.collisionIndex == CollisionFilterIndexConst.CAMP_2){
					_target = SceneManager.getIns().myPlayer;
				}else if(char.collisionIndex == CollisionFilterIndexConst.PLAYER){
					_target = SceneManager.getIns().nowScene["otherPlayer"];
				}else if(char.collisionIndex == CollisionFilterIndexConst.MONSTER){
					_target = SceneManager.getIns().myPlayer;
				}
			}
		}
		
		public function setSkillCamp():void{
			if(hurtSource != null){
				var character:CharacterEntity = hurtSource as CharacterEntity;
				switch(character.collisionIndex){
					case CollisionFilterIndexConst.CAMP_1:
						judgeSkillCamp(CollisionFilterIndexConst.CAMP_SKILL_1, [CollisionFilterIndexConst.CAMP_2], [CollisionFilterIndexConst.CAMP_SKILL_2]);
						break;
					case CollisionFilterIndexConst.CAMP_2:
						judgeSkillCamp(CollisionFilterIndexConst.CAMP_SKILL_2, [CollisionFilterIndexConst.CAMP_1], [CollisionFilterIndexConst.CAMP_SKILL_1]);
						break;
					case CollisionFilterIndexConst.MONSTER:
						judgeSkillCamp(CollisionFilterIndexConst.MONSTER_SKILL, [CollisionFilterIndexConst.PLAYER], [CollisionFilterIndexConst.PLAYER_SKILL]);
						break;
					case CollisionFilterIndexConst.ALL_CHARACTER:
						judgeSkillCamp(CollisionFilterIndexConst.ALL_SKILL, [CollisionFilterIndexConst.PLAYER, CollisionFilterIndexConst.MONSTER], []);
						break;
					case CollisionFilterIndexConst.PLAYER:
						judgeSkillCamp(CollisionFilterIndexConst.PLAYER_SKILL, [CollisionFilterIndexConst.MONSTER], [CollisionFilterIndexConst.MONSTER_SKILL]);
						break;
					default:
						break;
				}
			}
		}
		
		private function judgeSkillCamp(belong:int, listener1:Array, listener2:Array) : void{
			this.collisionIndex = belong;
			switch(_skillConfiguration.attackType){
				case 0:
					this.collisionListeners = listener1.concat(CollisionFilterIndexConst.MONSTER_SPECIAL);
					break;
				case 1:
					this.collisionListeners = listener2.concat(CollisionFilterIndexConst.MONSTER_SPECIAL);
					break;
				case 2:
					this.collisionListeners = listener1.concat(listener2, CollisionFilterIndexConst.MONSTER_SPECIAL);
					break;
				case 3:
					break;
				default:
					break;
			}
		}
		
		
		public function isYourFather():Boolean{
			return false;
		}
		
		//技能属性：0、无   1、雷属性  2、水属性  3、火属性  4、冰属性	5、档属性
		public function hurtBy(ih:IHurtAble):void{
			if(ih is SkillEntity){
				var hurtSkillProperty:int = (ih as SkillEntity).skillProperty;
				if(this.skillProperty == SkillType.NONE || hurtSkillProperty == SkillType.NONE) return;
				var attackId:int = ih.getAttackId();
				if(_beAttackedIdVec.indexOf(attackId) == -1){
					_beAttackedIdVec.push(attackId);
					//雷——水
					if(hurtSkillProperty == SkillType.THUNDER && this.skillProperty == SkillType.WATER){
						_canDestroy = true;
					}else if(hurtSkillProperty == SkillType.WATER && this.skillProperty == SkillType.THUNDER){
						(ih as SkillEntity).canDestroy = true;
					}
					//水——火
					if(hurtSkillProperty == SkillType.WATER && this.skillProperty == SkillType.FIRE){
						_canDestroy = true;
					}else if(hurtSkillProperty == SkillType.FIRE && this.skillProperty == SkillType.WATER){
						(ih as SkillEntity).canDestroy = true;
					}
					//火——冰
					if(hurtSkillProperty == SkillType.FIRE && this.skillProperty == SkillType.ICE){
						_canDestroy = true;
					}else if(hurtSkillProperty == SkillType.ICE && this.skillProperty == SkillType.FIRE){
						(ih as SkillEntity).canDestroy = true;
					}
				}
			}
		}
		
		public function getAttackId():int{
			return _attackId;
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			changeAttackId(curRenderIndex);
		}
		
		override protected function doWhenActionOver(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT:
					this.setAction(ActionState.HIT, true);
					_repeatCount++;
					changeAttackId(curRenderIndex);
					if(_skillConfiguration.isRepeat == 1){
						if(this._hit != null){
							this._hit.destroy();
							this._hit = null;
						}
						initCollision();
						setSkillLocation();
					}
					break;
			}
		}
		
		private function changeAttackId(curRenderIndex:int) : void{
			if(isHurt){
				_allStep++;
				if(_allStep % _skillConfiguration.attackIntervalFrame == 1){
					_attackId = _skillId * 1000 + curRenderIndex * (_repeatCount + 1);
				}
			}
		}
		
		override public function step():void{
			super.step();
			_spendFrame++;
			if(!_lock){
				roleFollowJudge();
				skillMoveJudge();
				handMoveJudge();
				locateMoveJudge();
				skillLimit();
			}
			destroyJudge();
			this.renderSkill();
			this.renderHit();
		}
		
		private function locateMoveJudge():void{
			if(_skillConfiguration.hurtMoveType == RoleFollowSkillConst.ALL_LOCATION_BY_MOVE){
				if(_spendFrame <= _skillConfiguration.locate_frame){
					this.x += _locateDistanceX;
					this.y += _locateDistanceY;
					this.bodyAction.y += _locateDistanceBodyY;
					(hurtSource as CharacterEntity).x += _locateDistanceX;
					(hurtSource as CharacterEntity).y += _locateDistanceY;
					(hurtSource as CharacterEntity).bodyAction.y += _locateDistanceBodyY;
					if((hurtSource as CharacterEntity).bodyAction.y > 0){
						(hurtSource as CharacterEntity).bodyAction.y = 0;
					}
				}
			}
		}
		
		private function renderSkill():void{
			if(_skillConfiguration != null && _skillConfiguration.appoint_frame != "0"){
				for(var i:int = 0; i < appointFrame.length; i++){
					if(_spendFrame == appointFrame[i]){
						SkillManager.getIns().createSkill(hurtSource as CharacterEntity, appointSkill[i]);
					}
				}
			}
		}
		
		private function skillLimit():void{
			var role:CharacterEntity = _hurtSource as CharacterEntity;
			if(role is PlayerEntity && role.characterControl != null){
				if(this.x > role.characterControl.limitRightX + this.width * .5){
					this.x = role.characterControl.limitRightX + this.width * .5;
				}
			}
		}
		
		private function destroyJudge() : void{
			if(_spendFrame > durationFrame || _canDestroy){
				SkillManager.getIns().destroySkill(this);
			}
		}
		
		//技能释放过程中手动控制技能方向
		private function handMoveJudge():void{
			var role:CharacterEntity = _hurtSource as CharacterEntity;

			if(role is PlayerEntity){
				var status:uint = (role as PlayerEntity).skillMove;
				if(status == SkillHandConst.HAND_MOVE_NONE) return;
				switch(status){
					case SkillHandConst.HAND_MOVE_LEFT:
						this.x -= handMoveList[0];
						role.x -= handMoveList[0];
						break;
					case SkillHandConst.HAND_MOVE_RIGHT:
						this.x += handMoveList[0];
						role.x += handMoveList[0];
						break;
					case SkillHandConst.HAND_MOVE_DOWN:
						this.bodyAction.y += handMoveList[1];
						role.bodyAction.y += handMoveList[1];
						if(this.collisionBody != null)
							this.collisionBody.y += handMoveList[1];
						break;
					case SkillHandConst.HAND_MOVE_UP:
						this.bodyAction.y -= handMoveList[1];
						this.bodyAction.y -= handMoveList[1];
						if(this.collisionBody != null)
							this.collisionBody.y -= handMoveList[1];
						break;
					case SkillHandConst.HAND_MOVE_Z_DOWN:
						this.y += handMoveList[2];
						role.y += handMoveList[2];
						break;
					case SkillHandConst.HAND_MOVE_Z_UP:
						this.y -= handMoveList[2];
						role.y -= handMoveList[2];
						break;
				}
			}
		}
		
		/**
		 * 释放技能的角色跟随技能移动
		 * 
		 */		
		private function roleFollowJudge() : void{
			var role:CharacterEntity = _hurtSource as CharacterEntity;
			if(roleMoveList[0] != 0){
				if(role.faceHorizontalDirect == DirectConst.DIRECT_LEFT)
					role.x -= roleMoveList[0];
				else if(role.faceHorizontalDirect == DirectConst.DIRECT_RIGHT)
					role.x += roleMoveList[0];
			}
			if(roleMoveList[1] != 0){
				role.bodyAction.y += roleMoveList[1];
			}
			if(roleMoveList[2] != 0){
				role.z += roleMoveList[2];
			}
		}
		
		/**
		 *	技能本身移动方式
		 * 
		 */
		private function skillMoveJudge() : void
		{
			if((_hurtSource as CharacterEntity).bodyAction == null) return;
			switch(_skillConfiguration.skillMoveType)
			{
				case SkillMoveConst.MOVE_ONLY_X:
					if(this.moveHorizontalDirect == DirectConst.DIRECT_LEFT){
						this.x -= skillMoveList[0];
					}else if(this.moveHorizontalDirect == DirectConst.DIRECT_RIGHT){
						this.x += skillMoveList[0];
					}
					break;
				case SkillMoveConst.MOVE_ONLY_Y:
					if((_hurtSource as CharacterEntity).bodyAction.y < 0){
						this.bodyAction.y += skillMoveList[1];
						if(this.collisionBody != null)
							this.collisionBody.y += skillMoveList[1];
					}else{
						if(_hurtSource is PlayerEntity){
							_canDestroy = true;
						}else{
							this.bodyAction.y += skillMoveList[1];
							if(this.collisionBody != null)
								this.collisionBody.y += skillMoveList[1];
						}
					}
					break;
				case SkillMoveConst.MOVE_ONLY_Z:
					this.y += skillMoveList[2];
					break;
				case SkillMoveConst.MOVE_X_AND_Y:
					if(this.moveHorizontalDirect == DirectConst.DIRECT_LEFT){
						this.x -= skillMoveList[0];
					}else if(this.moveHorizontalDirect == DirectConst.DIRECT_RIGHT){
						this.x += skillMoveList[0];
					}
					if((_hurtSource as CharacterEntity).bodyAction.y < 0){
						this.bodyAction.y += skillMoveList[1];
						if(this.collisionBody != null)
							this.collisionBody.y += skillMoveList[1];
					}else{
						if(_hurtSource is PlayerEntity){
							_canDestroy = true;
						}else{
							this.bodyAction.y += skillMoveList[1];
							if(this.collisionBody != null)
								this.collisionBody.y += skillMoveList[1];
						}
					}
					break;
				case SkillMoveConst.MOVE_X_AND_Z:
					if(this.moveHorizontalDirect == DirectConst.DIRECT_LEFT){
						this.x -= skillMoveList[0];
					}else if(this.moveHorizontalDirect == DirectConst.DIRECT_RIGHT){
						this.x += skillMoveList[0];
					}
					this.y += skillMoveList[2];
					break;
				case SkillMoveConst.MOVE_ROLE:
					var role:CharacterEntity = _hurtSource as CharacterEntity;
					this.x = role.x;
					this.y = role.y + _skillConfiguration.zPos + _skillConfiguration.yPos;
					if(role.bodyAction != null){
						this.bodyAction.y = role.bodyAction.y;
						this.shadow.y = 50 + role.shadow.y + role.y - role.shadowPos.y;
					}
					break;
			}
		}
		
		/**
		 * 技能释放结束需要做的事情
		 * 1、该技能造成的Buff结束
		 * 2、该技能的持续技能
		 */
		private function destroyEvent() : void{
			var obj:CharacterEntity = (_hurtSource as CharacterEntity);
			if(_skillConfiguration != null
				&& obj.charData != null){
				var buffTypeList:Array = _skillConfiguration.buff_type.split("|");
				var buffValueList:Array = _skillConfiguration.buff_value.split("|");
				for(var i:int = 0; i < buffTypeList.length; i++){
					if(buffTypeList[i] != 0){
						if(obj is ConjureEntity){
							SceneManager.getIns().removeConBuff(obj as ConjureEntity, buffTypeList[i], buffValueList[i]);
						}else{
							obj.charData.removeBuff(buffTypeList[i], buffValueList[i]);
						}
					}
				}
			}
			if(_skillConfiguration != null
				&& int(_skillConfiguration.continue_skill) != 0
				&& int(_skillConfiguration.continue_skill) != -1
				&& int(_skillConfiguration.continue_skill) != -2
				&&　obj.charData != null){
				var continueSkill:Array = _skillConfiguration.continue_skill.split("|");
				var continuePosX:Array = _skillConfiguration.continue_pos_x.split("|");
				var continuePosY:Array = _skillConfiguration.continue_pos_y.split("|");
				var continuePosZ:Array = _skillConfiguration.continue_pos_z.split("|");
				for(var j:int = 0; j < continueSkill.length; j++){
					if(obj.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
						SkillManager.getIns().createPosSkill(this.x - int(continuePosX[j]), int(continuePosY[j]), this.y + int(continuePosZ[j]), obj, int(continueSkill[j]));
					}else  if((_hurtSource as CharacterEntity).faceHorizontalDirect == DirectConst.DIRECT_RIGHT){
						SkillManager.getIns().createPosSkill(this.x + int(continuePosX[j]), int(continuePosY[j]), this.y + int(continuePosZ[j]), obj, int(continueSkill[j]));
					}
				}
			}
			if(_skillConfiguration.skillProperty == SkillType.REPLACE 
				&& (hurtSource as CharacterEntity) is ConjureEntity){
				RoleManager.getIns().destroyReplacePlayer();
			}
		}
		
		override public function destroy():void{
			destroyEvent();
			this._hurtSource = null;
			this._skillVo = null;
			this._skillConfiguration = null;
			this.skillMoveList = null;
			this.attackBackAxis = null;
			this.positionList = null;
			if(this._hit != null){
				this._hit.destroy();
				this._hit = null;
			}
			
			if(this.hasEventListener(SkillEvent.SKILL_DESTROY)){
				this.dispatchEvent(new SkillEvent(SkillEvent.SKILL_DESTROY));
			}
			
			super.destroy();
		}
		
		private var shadowPosTemp:Point = new Point();
		/**
		 * 返回影子区域坐标
		 * @return 
		 * 
		 */		
		public function get shadowPos():Point{
			shadowPosTemp.x = this.x + this.shadow.x;
			shadowPosTemp.y = this.y + this.shadow.y;
			return shadowPosTemp;
		}

		public function get hurtSource():IAttackAble{
			return _hurtSource;
		}

		public function set hurtSource(value:IAttackAble):void{
			_hurtSource = value;
		}

		public function get hurt():int{
			return _skillConfiguration.hurt;
		}

		public function set hurt(value:int):void{
			_skillConfiguration.hurt = value;
		}

		public function get attackBackAxis():Array{
			return _attackBackAxis;
		}

		public function set attackBackAxis(value:Array):void{
			_attackBackAxis = value;
		}

		public function get skillVo():SkillVo{
			return _skillVo;
		}

		public function set skillVo(value:SkillVo):void{
			_skillVo = value;
		}

		public function get durationFrame() : uint{
			return _skillConfiguration.durationFrame;
		}
		
		public function get attackId() : int{
			return _attackId;
		}
		public function set attackId(value:int) : void{
			_attackId = value;
		}
		
		public function get skillMoveType() : int{
			return _skillConfiguration.skillMoveType;
		}
		
		public function get unActionFrame() : int{
			return _skillConfiguration.unActionFrame;
		}
		
		public function get collisionRange() : int{
			return _skillConfiguration.collisionRange;
		}
		
		public function get fallDownHurt() : int{
			return _skillConfiguration.fallDownHurt;
		}
		
		public function get hurtMoveType() : int{
			return _skillConfiguration.hurtMoveType;
		}
		
		public function get skillProperty() : int{
			if(_skillConfiguration == null){
				return 0;
			}else{
				return _skillConfiguration.skillProperty;
			}
		}
		
		public function get skillConfiguration() : Object{
			return _skillConfiguration;
		}
		
		override public function get collisionPos():int{
			return (this.shadow.y + this.y);
		}
		
		public function get lastBeHurtSource():IHurtAble{
			return _lastBeHurtSource;
		}
		
		public function set lastBeHurtSource(value:IHurtAble):void{
			_lastBeHurtSource = value;
		}
		
		public function get beAttackedIdVec():Vector.<int>{
			return _beAttackedIdVec;
		}
		
		public function set beAttackedIdVec(value:Vector.<int>):void{
			_beAttackedIdVec = value;
		}
		
		public function get canDestroy() : Boolean{
			return _canDestroy;
		}
		
		public function set canDestroy(value:Boolean) : void{
			_canDestroy = value;
		}
	}
}