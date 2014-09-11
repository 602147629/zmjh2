package com.test.game.Mvc.control.character
{
	import com.superkaka.mvc.BmdViewFactory;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.AutoFightManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Mvc.BmdView.AutoPKSceneView;
	
	public class PKAceAutoFightControl extends AutoFightControl
	{
		override protected function get monsters() : Vector.<MonsterEntity>{
			return null;
		}
		
		public function PKAceAutoFightControl(player:PlayerEntity)
		{
			super(player);
			
			isReleaseBuring = false;
			isReleaseBoss = false;
		}
		
		private function get targetPlayer() : PlayerEntity{
			if(SceneManager.getIns().sceneType == SceneManager.AUTO_PK_SCENE){
				return (BmdViewFactory.getIns().getView(AutoPKSceneView) as AutoPKSceneView).myPlayer;
			}else{
				return null;
			}
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
			if(targetPlayer != null){
				if(targetPlayer.charData.useProperty.hp > 0){
					_target = targetPlayer;
				}
			}
		}
	}
}