package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.test.game.Effect.DeformEffect;
	
	import flash.display.DisplayObject;
	
	public class DeformManager extends Singleton
	{
		public function DeformManager()
		{
			super();
		}
		
		public static function getIns():DeformManager{
			return Singleton.getIns(DeformManager);
		}
		
		private var _deformList:Vector.<DeformEffect> = new Vector.<DeformEffect>();
		public function addNewDeform(obj:DisplayObject, name:String) : void{
			//removeDeform(name);
			if(!checkDeform(name)){
				var deform:DeformEffect = new DeformEffect(obj, name);
				deform.play();
				_deformList.push(deform);
			}
		}
		
		public function removeDeform(name:String) : void{
			for(var i:int = _deformList.length - 1; i >=0; i--){
				if(_deformList[i].name == name){
					var deform:DeformEffect = _deformList[i];
					_deformList.splice(i, 1);
					deform.destroy();
					deform = null;
					break;
				}
			}
		}
		
		private function checkDeform(name:String) : Boolean{
			var result:Boolean = false;
			for each(var deform:DeformEffect in _deformList){
				if(deform.name == name){
					result = true;
					break;
				}
			}
			return result;
		}
		
		public function clear() : void{
			for(var i:int = _deformList.length - 1; i >=0; i--){
				var deform:DeformEffect = _deformList[i];
				_deformList.splice(i, 1);
				deform.destroy();
				deform = null;
				break;
			}
		}
	}
}