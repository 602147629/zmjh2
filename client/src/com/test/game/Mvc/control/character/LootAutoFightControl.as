package com.test.game.Mvc.control.character
{
	import com.superkaka.mvc.BmdViewFactory;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Monsters.EscortEntity;
	import com.test.game.Manager.AutoFightManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Mvc.BmdView.EscortSceneView;
	
	public class LootAutoFightControl extends AutoFightControl
	{
		private function get convoys() : Vector.<EscortEntity>{
			if(SceneManager.getIns().sceneType == SceneManager.ESCORT_SCENE){
				return (BmdViewFactory.getIns().getView(EscortSceneView) as EscortSceneView).convoys;
			}else{
				return null;
			}
		}
		
		public function LootAutoFightControl(player:PlayerEntity){
			super(player);
			
			isReleaseBuring = false;
			isReleaseBoss = false;
		}
		
		override protected function get canFightJudge():Boolean{
			var result:Boolean = false;
			var intervalLittle:int = 1000;
			intervalLittle = Math.abs(myPlayer.x - _target.x);
			if(myPlayer.x < _target.x){
				playerDirect =  AutoFightManager.getIns().DIRECT_RIGHT;
			}else{
				playerDirect =  AutoFightManager.getIns().DIRECT_LEFT;
			}
			if(intervalLittle < 150){
				result = true;
			}else{
				result = false;
			}
			return result;
		}
		
		override protected function checkTarget() : void{
			if(convoys != null){
				for(var i:int = 0; i < convoys.length; i++){
					if(convoys[i].charData.useProperty.hp > 0){
						_target = convoys[i];
						break;
					}
				}
			}
		}
	}
}