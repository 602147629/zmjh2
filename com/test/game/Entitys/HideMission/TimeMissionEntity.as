package com.test.game.Entitys.HideMission
{
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.HideMission.MoZhuHideMissionManager;

	public class TimeMissionEntity extends BaseHideMissionEntity
	{
		private var _costTime:int;
		public var allTime:int = 90;
		public function TimeMissionEntity(fodderArr:Array, collisionSkill:String="")
		{
			super(fodderArr, collisionSkill);
			_costTime = allTime;
		}
		
		override public function step():void{
			if(_costTime > 0){
				if(_target == null){
					seekTarget();
				}else{
					if(Math.abs(_target.shadowPos.x - shadowPos.x) < 100){
						_costTime--;
						if(_costTime == 0){
							MoZhuHideMissionManager.getIns().setHideMissionComplete();
						}
					}else{
						_costTime = allTime;
					}
				}
			}
		}
		
		private var _target:PlayerEntity;
		//获得目标角色
		public function seekTarget() : void{
			if(SceneManager.getIns().nowScene != null){
				_target = SceneManager.getIns().myPlayer;
			}
		}
	}
}