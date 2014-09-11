package com.test.game.Entitys.Ai
{
	import com.superkaka.game.AgreeMent.IStepAble;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.BevTree.BevNode;
	import com.test.game.BevTree.JSONToAI;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	
	public class BaseBev implements IStepAble
	{
		public var entity:MonsterEntity;
		private var target:PlayerEntity;//目标
		private var _bevNode:BevNode;
		
		private var _currentFrameCount:int = 0;
		private var _renderSpeed:Number = 1;
		private var _isStopRender:Boolean;
		
		public function BaseBev(entity:MonsterEntity, aiObj:Object)
		{
			this.entity = entity;
			_bevNode = JSONToAI.AnalysisBevTree(aiObj, entity);
			//RenderEntityManager.getIns().addEntity(this);
		}
		
		public function step():void{
			if(!entity.characterJudge.isUnMoveStatus && !entity.characterControl.jumpStatus)
				_bevNode.step();
		}
		
		public function destroy():void{
			//RenderEntityManager.getIns().removeEntity(this);
			if(_bevNode){
				_bevNode.destroy();
				_bevNode = null;
			}
			this.entity = null;
			this.target = null;
		}
		
		public function get currentFrameCount():int
		{
			return _currentFrameCount;
		}
		
		public function set currentFrameCount(value:int):void
		{
			_currentFrameCount = value;
		}
		
		public function get renderSpeed():Number
		{
			return _renderSpeed;
		}
		
		public function set renderSpeed(value:Number):void
		{
			_renderSpeed = value;
		}
		
		public function get isStopRender():Boolean
		{
			return _isStopRender;
		}
		
		public function set isStopRender(value:Boolean):void
		{
			_isStopRender = value;
		}
		
		public function get bevNode() : BevNode{
			return _bevNode;
		}
		public function set bevNode(value:BevNode) : void{
			_bevNode = value;
		}
	}
}