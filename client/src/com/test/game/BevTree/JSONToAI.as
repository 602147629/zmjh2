package com.test.game.BevTree
{
	import com.test.game.Entitys.MonsterEntity;

	public class JSONToAI
	{
		
		public function JSONToAI()
		{
		}
		
		public static function AnalysisBevTree(aiObj:Object, entity:MonsterEntity) : BevNode
		{
			var result:BevNode;
			for(var prop:String in aiObj){
				result = new (BevFuncConst.funcStatues[prop])(aiObj[prop].name).setParams(aiObj[prop].params);
			}
			
			result.initData(entity);
			
			addChildNode(result, aiObj[prop]);
			
			return result;
		}
		
		private static function addChildNode(input:BevNode, mainNode:Object) : void
		{
			var result:BevNode;
			for(var prop:String in mainNode)
			{
				if(prop != "id" && prop != "name" && prop != "params" && prop != "callback")
				{
					result = new (BevFuncConst.funcStatues[prop.split("_")[0]])(mainNode[prop].name).setParams(mainNode[prop].params);
					input.addChildAt(result, mainNode[prop].id);
					addChildNode(result, mainNode[prop]);
				}
			}
		}
		
		public static function AnalysisProcess(aiObj:Object, entity:MonsterEntity) : void
		{
			
		}
	}
}