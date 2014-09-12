package com.test.game.BevTree
{
	import com.test.game.Entitys.BevAi.BevAttackAirNode;
	import com.test.game.Entitys.BevAi.BevAttackMoveNode;
	import com.test.game.Entitys.BevAi.BevAttackRangeNode;
	import com.test.game.Entitys.BevAi.BevBoardRangeNode;
	import com.test.game.Entitys.BevAi.BevDistanceNode;
	import com.test.game.Entitys.BevAi.BevIntervalTime;
	import com.test.game.Entitys.BevAi.BevIsOnAttackNode;
	import com.test.game.Entitys.BevAi.BevIsStandUpNode;
	import com.test.game.Entitys.BevAi.BevJumpAttackNode;
	import com.test.game.Entitys.BevAi.BevMonsterFight;
	import com.test.game.Entitys.BevAi.BevMonsterLeftMove;
	import com.test.game.Entitys.BevAi.BevMonsterMove;
	import com.test.game.Entitys.BevAi.BevRollAttackNode;
	import com.test.game.Entitys.BevAi.BevContinueAttackNode;
	import com.test.game.Entitys.BevAi.BevStandUpAttackNode;
	import com.test.game.Entitys.BevAi.BevStandUpJumpAttackNode;
	import com.test.game.Entitys.BevAi.BevStartAttackCountNode;
	import com.test.game.Entitys.BevAi.BevStartAttackNode;

	public class BevFuncConst
	{
		public static var funcStatues:Object;
		
		funcStatues = {
			"BevNode" : BevNode,
			"BevSelectorNode" : BevSelectorNode,
			"BevSequenceNode" : BevSequenceNode,
			"BevActionNode" : BevActionNode,
			"BevConditionNode" : BevConditionNode,
			"BevDistanceNode" : BevDistanceNode,
			"BevIntervalTime" : BevIntervalTime,
			"BevMonsterFight" : BevMonsterFight,
			"BevMonsterMove" : BevMonsterMove,
			"BevIsOnAttackNode" : BevIsOnAttackNode,
			"BevMonsterLeftMove" : BevMonsterLeftMove,
			"BevAttackRangeNode" : BevAttackRangeNode,
			"BevAttackMoveNode" : BevAttackMoveNode,
			"BevStartAttackNode" : BevStartAttackNode,
			"BevBoardRangeNode" : BevBoardRangeNode,
			"BevJumpAttackNode" : BevJumpAttackNode,
			"BevRollAttackNode" : BevRollAttackNode,
			"BevIsStandUpNode" : BevIsStandUpNode,
			"BevStandUpAttackNode" : BevStandUpAttackNode,
			"BevStandUpJumpAttackNode" : BevStandUpJumpAttackNode,
			"BevContinueAttackNode" : BevContinueAttackNode,
			"BevAttackAirNode" : BevAttackAirNode,
			"BevStartAttackCountNode" : BevStartAttackCountNode
		}
	}
}