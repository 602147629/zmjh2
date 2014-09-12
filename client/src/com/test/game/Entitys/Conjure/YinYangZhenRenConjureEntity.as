package com.test.game.Entitys.Conjure
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.mvc.Base.BaseBmdView;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Effect.CircleChangeEffect;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Monsters.SkillShowEntity;
	import com.test.game.Entitys.Monsters.YinYangZhenRenShowEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.HideMission.TaiXuHideMissionManager;
	import com.test.game.Manager.HideMission.WanEGuMissionManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	public class YinYangZhenRenConjureEntity extends ConjureEntity
	{
		private function get map() : BaseView{
			return MapManager.getIns().nowMap;
		}
		public function YinYangZhenRenConjureEntity(charVo:CharacterVo, data:Object)
		{
			super(charVo, data);
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.SKILL2:
					releaseSkill2(keyFrame);
					break;
				case ActionState.SKILLOVER2:
					if(keyFrame == 3){
						releaseSkillOver2();
					}
					break;
				case ActionState.WAIT:
					if(keyFrame == 3){
						this.setAction(ActionState.SKILL2);
					}
					break;
			}
		}
		
		private function releaseSkillOver2():void{
			var circleChangeEffect:CircleChangeEffect = new CircleChangeEffect(pos);
			var skill:SkillEntity = SkillManager.getIns().createSkill(this, 20103);
			if(SceneManager.getIns().hasMonsterScene){
				var monsters:Vector.<MonsterEntity> = SceneManager.getIns().monsters;
				if(monsters != null){
					for(var i:int = 0; i < monsters.length; i++){
						monsters[i].hurtBy(skill);
					}
				}
				TaiXuHideMissionManager.getIns().sceneHurtBySkill(skill);
				WanEGuMissionManager.getIns().sceneHurtBySkill(skill);
			}else if(SceneManager.getIns().isPkScene){
				var players:Vector.<PlayerEntity> = SceneManager.getIns().players;
				for(var j:int = 0; j < players.length; j++){
					if(players[j].collisionIndex != this.collisionIndex){
						players[j].hurtBy(skill);
					}
				}
			}
		}
		
		private var _showList:Array;
		private function releaseSkill2(keyFrame:int) : void{
			if(keyFrame == 1){
				var posX:int;
				posX = map["getCenter"]();
				characterJudge.isInvincible = true;
				characterJudge.inviclbleTime = 80;
			}
			if(keyFrame == 4){
				_showList = new Array();
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
				case ActionState.SKILLOVER2:
					resetSkillParams();
					endFrame++;
					this.alpha -= .06;
					if(endFrame >= 15){
						this.setAction(ActionState.WALK);
						this.hideConjure();
						this.alpha = 1;
					}
					break;
				case ActionState.SKILL2:
					if(_showList != null && _showList.length > 0){
						if(Math.abs(_showList[0].x - _showList[1].x) < 50 || _showList[0].x > _showList[1].x){
							this.setAction(ActionState.SKILLOVER2);
						}else{
							this.setAction(ActionState.WALK);
							this.hideConjure();
							this.alpha = 1;
						}
						(_showList[1] as YinYangZhenRenShowEntity).destroy();
						_showList[1] = null;
						(_showList[0] as YinYangZhenRenShowEntity).destroy();
						_showList[0] = null;
						_showList.length = 0;
					}
					break;
				default : 
					this.setAction(this.curAction, true);
					break;
			}
		}
	}
}