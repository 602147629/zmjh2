package com.test.game.Mvc.Vo
{
	import com.superkaka.mvc.Vo.SequenceVo;
	
	public class SkillVo extends SequenceVo
	{
		private var _isRectCollision:Boolean = true;
		
		public function SkillVo(id:uint, assets:Array, double:Boolean)
		{
			super();
			sequenceId = id;
			assetsArray = assets;
			isDouble = double;
		}
		
		override public function clone():*{
			var sv:SkillVo = new SkillVo(sequenceId,assetsArray,isDouble);
			sv.isCacheData = this.isCacheData;
			sv.isRectCollision = this.isRectCollision;
			return sv;
		}

		public function get isRectCollision():Boolean
		{
			return _isRectCollision;
		}

		public function set isRectCollision(value:Boolean):void
		{
			_isRectCollision = value;
		}

	}
}