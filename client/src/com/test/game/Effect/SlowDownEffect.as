package com.test.game.Effect
{
	import com.superkaka.game.Const.ActionState;
	import com.test.game.Entitys.CharacterEntity;

	public class SlowDownEffect extends RenderEffect
	{
		private var objList:Array;
		public var callback:Function;
		public var percent:Number = .5;
		public function SlowDownEffect(){
			objList = new Array();
			super();
		}
		
		override public function step():void{
			super.step();
			if(_startSlowDown){
				_slowDownCount++;
				if(_slowDownCount >= 20){
					stop();
				}
			}
		}
		
		public function addObj(obj:Object) : void{
			objList.push(obj);
		}
		
		private var _startSlowDown:Boolean;
		private var _slowDownCount:int;
		public function start() : void{
			_startSlowDown = true;
			_slowDownCount = 0;
			for(var i:int = 0; i < objList.length; i++){
				for each(var item:Object in objList[i]){
					if(item != null){
						item.renderSpeed = percent;
						if(item is CharacterEntity){
							(item as CharacterEntity).speedEntity.renderSpeed = percent;
							if((item as CharacterEntity).curAction == ActionState.RUN){
								(item as CharacterEntity).speedEntity.setRun();
							}else if((item as CharacterEntity).curAction == ActionState.WALK){
								(item as CharacterEntity).speedEntity.setNormal();
							}
						}
					}
				}
			}
		}
		
		public function stop() : void{
			_startSlowDown = false;
			if(objList != null){
				for(var i:int = 0; i < objList.length; i++){
					for each(var item:Object in objList[i]){
						if(item != null){
							item.renderSpeed = 1;
							if(item is CharacterEntity){
								(item as CharacterEntity).speedEntity.renderSpeed = 1;
							}
						}
					}
				}
				if(callback != null){
					callback();
				}
				this.destroy();
			}
		}
		
		override public function destroy():void{
			if(objList){
				objList.length = 0;
				objList = null;
			}
			callback = null;
			super.destroy();
		}
	}
}