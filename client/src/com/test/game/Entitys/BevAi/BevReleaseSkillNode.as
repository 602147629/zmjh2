package com.test.game.Entitys.BevAi
{
	import com.test.game.BevTree.BevActionNode;
	import com.test.game.Entitys.MonsterEntity;
	
	public class BevReleaseSkillNode extends BevActionNode
	{
		public function BevReleaseSkillNode(name:String, inputEntity:MonsterEntity)
		{
			super(name, inputEntity);
		}
	}
}