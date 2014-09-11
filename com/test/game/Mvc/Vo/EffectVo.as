package com.test.game.Mvc.Vo
{
	import com.superkaka.mvc.Vo.SequenceVo;
	
	public class EffectVo extends SequenceVo
	{
		public function EffectVo(id:uint, assets:Array, double:Boolean)
		{
			super();
			sequenceId = id;
			assetsArray = assets;
			isDouble = double;
		}
	}
}