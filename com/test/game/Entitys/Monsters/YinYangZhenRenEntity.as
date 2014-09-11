package com.test.game.Entitys.Monsters
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseBmdView;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Effect.CircleChangeEffect;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	public class YinYangZhenRenEntity extends BaseMonsterEntity
	{
		public function YinYangZhenRenEntity(charVo:CharacterVo, hasMainAI:Boolean = true){
			super(charVo, hasMainAI);
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT1:
					checkFrameCommon(keyFrame, 1);
					//hitType = 0;
					break;
				case ActionState.SKILL1:
					checkFrameSKill(keyFrame, this.curAction);
					//hitType = 1;
					break;
				case ActionState.SKILL2:
					releaseSkill2(keyFrame);
					break;
				case ActionState.SKILLOVER2:
					if(keyFrame == 3){
						releaseSkillOver2();
					}
					break;
				case ActionState.DEAD:
					if(this.mainAi != null){
						this.mainAi.lock();
					}
					break;
				case ActionState.GROUNDDEAD:
					if(this.mainAi != null){
						this.mainAi.lock();
					}
					if(keyFrame < 6){
						groundDeadMove();
					}
					break;
			}
		}
		
		private function releaseSkillOver2():void{
			var circleChangeEffect:CircleChangeEffect = new CircleChangeEffect(pos);
			var skill:SkillEntity = SkillManager.getIns().createSkill(this, 20103);
			var players:Vector.<PlayerEntity> = SceneManager.getIns().players;
			for(var i:int = 0; i < players.length; i++){
				players[i].hurtBy(skill);
			}
		}
		
		private var _showList:Array;
		private function releaseSkill2(keyFrame:int) : void{
			if(keyFrame == 1){
				_characterControl.setAttackStart();
				var map:BaseView = MapManager.getIns().nowMap;
				var posX:int = map["getCenter"]();
				this.x = posX;
				characterJudge.isInvincible = true;
				characterJudge.inviclbleTime = 80;
			}
			if(keyFrame == 4){
				_showList = new Array();
				map = MapManager.getIns().nowMap;
				var gsv:BaseBmdView = SceneManager.getIns().nowScene;
				var show1:SkillShowEntity = RoleManager.getIns().createSkillShowEntity(2109);
				show1.x = map["getLimitLeft"]();
				show1.y = this.y;
				show1.faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
				show1.setAction(ActionState.SHOW);
				show1.brightValue = -1.8;
				gsv.addChild(show1);
				_showList.push(show1);
				
				var show2:SkillShowEntity = RoleManager.getIns().createSkillShowEntity(2109);
				show2.x = map["getLimitRight"]();
				show2.y = this.y;
				show2.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
				show2.setAction(ActionState.SHOW);
				show2.brightValue = .8;
				gsv.addChild(show2);
				_showList.push(show2);
			}else if(keyFrame > 4){
				if(_showList.length < 2) return;
				map = MapManager.getIns().nowMap;
				var offsetX:int = map["getOffset"]();
				_showList[0].x += offsetX + 1;
				_showList[1].x -= offsetX + 1;
			}
		}
		
		override public function step():void{
			super.step();
		}
		
		override protected function doWhenActionOver(...args) : void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT1:
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.SKILL1:
				case ActionState.SKILLOVER2:
				case ActionState.SKILL3:
					_characterControl.setAttackEnd();
					this.resetSkillParams();
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.SKILL2:
					if(_showList != null && _showList.length > 0){
						if(Math.abs(_showList[0].x - _showList[1].x) < 50 || _showList[0].x > _showList[1].x){
							this.setAction(ActionState.SKILLOVER2);
						}else{
							this.setAction(ActionState.WAIT);
						}
						(_showList[1] as YinYangZhenRenShowEntity).destroy();
						_showList[1] = null;
						(_showList[0] as YinYangZhenRenShowEntity).destroy();
						_showList[0] = null;
						_showList.length = 0;
					}
					break;
				case ActionState.HURT:
					unMoveHurt();
					resetSkillParams();
					isAirHurt();
					break;
				case ActionState.DEAD:
				case ActionState.GROUNDDEAD:
					this.dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_DEAD_EVENT));
					//this.destroy();
					break;
				case ActionState.FALL:
					isAirHurt();
					if(curRenderIndex == 50){
						standUp();
						unMoveHurt();
					}
					break;
				default:
					if(this.curAction == ActionState.NONE)
						this.setAction(ActionState.WAIT);
					this.setAction(this.curAction, true);
					resetShadow();
					break;
			}
		}
	}
}