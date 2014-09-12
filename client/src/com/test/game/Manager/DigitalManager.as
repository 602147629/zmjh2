package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;

	public class DigitalManager extends Singleton
	{
		public var randomIndex:int = 1;//随机种子
		
		
		public function DigitalManager(){
			super();
		}
		
		public static function getIns():DigitalManager{
			return Singleton.getIns(DigitalManager);
		}
		
		/**
		 * 返回一个随机数 
		 * @return 
		 * 
		 */	
		public function getRandom():Number{
			//伪随机算法
			var random:Number = (randomIndex*29+37)%1000;
			this.randomIndex = random;
			return random/1000;
		}
		
		public function getOneStauts() : int{
			if(Math.random() < .5){
				return -1;
			}else{
				return 1;
			}
		}
	}
}