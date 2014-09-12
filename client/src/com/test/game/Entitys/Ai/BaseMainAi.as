package com.test.game.Entitys.Ai
{
	import com.test.game.Entitys.MonsterEntity;

	public class BaseMainAi
	{
		public var processAi:ProcessAi;
		
		public function BaseMainAi(entity:MonsterEntity, aiObj:Object){
			this.processAi = new ProcessAi(entity, aiObj);
		}
		
		public function destroy() : void{
			if(this.processAi){
				this.processAi.destroy();
				this.processAi = null;
			}
		}
		
		public function step() : void{
			this.processAi.step();
		}
		
		public function lock() : void{
			if(this.processAi != null && this.processAi.process.bevAi != null)
				this.processAi.process.bevAi.bevNode.isNowLock = true;
		}
		public function unLock() : void{
			if(this.processAi != null && this.processAi.process.bevAi != null)
				this.processAi.process.bevAi.bevNode.isNowLock = false;
		}
		
	}
}