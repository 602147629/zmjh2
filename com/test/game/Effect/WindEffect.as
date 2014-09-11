package com.test.game.Effect
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Const.GameConst;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Weather.LeafEntity;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.SceneManager;

	public class WindEffect extends BaseEffect
	{
		private static const NORMAL_SPEED:int = 2;
		private static const QUICK_SPEED:int = 4;
		public var windForward:uint;
		private var _nowSpeed:int = NORMAL_SPEED;
		private var _stepCount:int;
		private var _isStart:Boolean;
		private var _leafList:Vector.<LeafEntity> = new Vector.<LeafEntity>();
		public function get isStart() : Boolean{
			return _isStart;
		}
		private function get monsters() : Vector.<MonsterEntity>{
			if(SceneManager.getIns().nowScene != null){
				return SceneManager.getIns().nowScene["monsters"];
			}else{
				return null;
			}
		}
		
		private function get players() : Vector.<PlayerEntity>{
			if(SceneManager.getIns().nowScene != null){
				return SceneManager.getIns().nowScene["players"];
			}else{
				return null;
			}
		}
		
		public function WindEffect(){
			super();
			init();
			AnimationManager.getIns().removeEntity(this);
		}
		
		private function init():void{
			
		}
		
		public function start() : void{
			_isStart = true;
		}
		
		public function stop() : void{
			_isStart = false;
		}
		
		override public function step() : void{
			if(_isStart){
				characterMove();
				leafMove();
				if(_stepCount > 200 && _stepCount < 250){
					leafQuick();
					if(_stepCount % 6 == 0){
						addLeaf();
						_nowSpeed = NORMAL_SPEED;
					}
				}else{
					if(_stepCount % 10 == 0){
						addLeaf();
						_nowSpeed = NORMAL_SPEED;
					}
				}
				_stepCount++;
				if(_stepCount >= 450){
					windForward++;
					if(windForward > DirectConst.DIRECT_RIGHT){
						windForward = DirectConst.DIRECT_LEFT;
					}
					_stepCount = 0;
				}
			}else{
				clearAllLeaf();
			}
		}
		
		private function leafQuick():void{
			for(var i:int = 0; i < _leafList.length; i++){
				if(_leafList[i] != null){
					_leafList[i].speedX = 80;
					_leafList[i].speedY = 40;
				}
			}
		}
		
		private function clearAllLeaf() : void{
			for(var i:int = 0; i < _leafList.length; i++){
				var face:int = (windForward==DirectConst.DIRECT_LEFT?-1:1)
				_leafList[i].x += (face * _leafList[i].speedX);
				_leafList[i].y += _leafList[i].speedY;
				_leafList[i].setFodder(face);
				if(_leafList[i].y >= GameConst.stage.stageHeight){
					SceneManager.getIns().nowScene["popTop"](_leafList[i]);
					_leafList[i].destroy();
					_leafList[i] = null;
				}
			}
			for(var j:int = _leafList.length - 1; j >= 0; j--){
				if(_leafList[j] == null){
					_leafList.splice(j, 1);
				}
			}
		}
		
		private function addLeaf():void{
			var newLeaf:LeafEntity = new LeafEntity("WeatherLeaf_" + (int(Math.random() * 10) + 1), 16 + Math.random() * 8, 12 + Math.random() * 6);
			if(windForward==DirectConst.DIRECT_LEFT){
				newLeaf.x = Math.random() * (GameConst.stage.stageWidth) - SceneManager.getIns().nowScene.x + 1000;
			}else{
				newLeaf.x = Math.random() * (GameConst.stage.stageWidth) - SceneManager.getIns().nowScene.x - 1000;
			}
			newLeaf.y = -Math.random() * GameConst.stage.stageHeight;
			_leafList.push(newLeaf);
			SceneManager.getIns().nowScene["pushTop"](newLeaf);
		}
		
		private function leafMove():void{
			var face:int = (windForward==DirectConst.DIRECT_LEFT?-1:1)
			for(var i:int = 0; i < _leafList.length; i++){
				_leafList[i].x += (face * _leafList[i].speedX);
				_leafList[i].y += _leafList[i].speedY;
				_leafList[i].setFodder(face);
				if(_leafList[i].y >= GameConst.stage.stageHeight){
					SceneManager.getIns().nowScene["popTop"](_leafList[i]);
					_leafList[i].destroy();
					_leafList[i] = null;
				}
			}
			for(var j:int = _leafList.length - 1; j >= 0; j--){
				if(_leafList[j] == null){
					_leafList.splice(j, 1);
				}
			}
		}
		
		private function characterMove() : void{
			if(monsters != null){
				for(var i:int = 0; i < monsters.length; i++){
					if(monsters[i].curAction == ActionState.WAIT
						|| monsters[i].curAction == ActionState.WALK
						|| monsters[i].curAction == ActionState.RUN
						|| monsters[i].curAction == ActionState.JUMP
						|| monsters[i].curAction == ActionState.HURT){
						switch(windForward){
							case DirectConst.DIRECT_LEFT:
								monsters[i].x -= _nowSpeed;
								break;
							case DirectConst.DIRECT_RIGHT:
								monsters[i].x += _nowSpeed;
								break;
							case DirectConst.DIRECT_UP:
								monsters[i].y -= _nowSpeed * .5;
								break;
							case DirectConst.DIRECT_DOWN:
								monsters[i].y += _nowSpeed * .5;
								break;
						}
					}
				}
			}
			if(players != null){
				for(var j:int = 0; j < players.length; j++){
					if(players[j].curAction == ActionState.WAIT
						|| players[j].curAction == ActionState.WALK
						|| players[j].curAction == ActionState.RUN
						|| players[j].curAction == ActionState.JUMP
						|| players[j].curAction == ActionState.JUMPDOWN
						|| players[j].curAction == ActionState.DOUBLEJUMP
						|| players[j].curAction == ActionState.HURT
						|| players[j].curAction == ActionState.HURTDOWN
						|| players[j].curAction == ActionState.STAND){
						switch(windForward){
							case DirectConst.DIRECT_LEFT:
								players[j].x -= _nowSpeed;
								break;
							case DirectConst.DIRECT_RIGHT:
								players[j].x += _nowSpeed;
								break;
							case DirectConst.DIRECT_UP:
								players[j].y -= _nowSpeed * .5;
								break;
							case DirectConst.DIRECT_DOWN:
								players[j].y += _nowSpeed * .5;
								break;
						}
					}
				}
			}
		}
		
		public function clear() : void{
			
		}
		
		override public function destroy():void{
			for(var i:int = 0; i < _leafList.length; i++){
				if(_leafList[i] != null){
					_leafList[i].destroy();
					_leafList[i] = null;
				}
			}
			_leafList.length = 0;
			_leafList = null;
			super.destroy();
		}
	}
}