package com.test.game.Entitys.Weather
{
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	import flash.geom.Point;
	
	public class ThunderEntity extends CharacterEntity
	{
		private var _pos:Point = new Point();
		private function get monsters() : Vector.<MonsterEntity>{
			if(SceneManager.getIns().nowScene != null){
				return SceneManager.getIns().monsters;
			}else{
				return null;
			}
		}
		
		private function get players() : Vector.<PlayerEntity>{
			if(SceneManager.getIns().nowScene != null){
				return SceneManager.getIns().players;
			}else{
				return null;
			}
		}
		
		public function ThunderEntity(charVo:CharacterVo){
			super(charVo);
			this.isRectCollision = true;
			this.collisionIndex = CollisionFilterIndexConst.ALL_CHARACTER;
		}
		
		override protected function initSequenceAction():void{
			initShadow();
		}
		
		public function releaseThunder() : void{
			if(monsters.length != 0){
				_pos = monsters[int(monsters.length * Math.random())].pos;
			}else{
				_pos = players[int(players.length * Math.random())].pos;
			}
			SkillManager.getIns().createPosSkill(_pos.x, 40, _pos.y, this, 64);
		}
		public function releaseThunderContinue() : void{
			SkillManager.getIns().createPosSkill(_pos.x, -155, _pos.y, this, 65);
		}
		
		override public function step() : void{
			
		}
		
		private var bodyPosTemp:Point = new Point();
		override public function get bodyPos():Point{
			bodyPosTemp.x = this.x;
			bodyPosTemp.y = this.y;
			return bodyPosTemp;
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}