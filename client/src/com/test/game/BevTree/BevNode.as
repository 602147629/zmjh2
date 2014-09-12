package com.test.game.BevTree
{
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Manager.RoleManager;

	public class BevNode extends Object implements IBevTree
	{
		//最大子节点数
		public static const MAX_CHILDREN:int = 16;
		protected var nodeName:String
		protected var children:Vector.<BevNode>;
		protected var parent:BevNode;
		protected var params:Array;
		protected var nowStatus:uint;
		protected var preStatus:uint;
		protected var nowIndex:uint;
		protected var locked:Boolean;
		protected var nowLocked:Boolean;
		
		public var entity:MonsterEntity;
		
		public function BevNode(name:String){
			nodeName = name;
			params = new Array();
		}
		
		public function initData(input:MonsterEntity) : void{
			entity = input;
			RoleManager.getIns().seekTarget(entity);
		}
		
		public function addChild(node:BevNode):BevNode{
			if(!children)
				children = new Vector.<BevNode>;
			
			if(children.length == MAX_CHILDREN)
				throw new Error(this + " overflow, max children number is " + MAX_CHILDREN);
			
			children.push(node);
			node.parent = this;
			return this;
		}
		
		public function addChildAt(node:BevNode, index:int):BevNode{
			if(!children)
				children = new Vector.<BevNode>;
			node.parent = this;
			node.entity = this.entity;
			//node.target = this.target;
			
			if(index < 0)
				index = 0;
			while(index > children.length - 1){
				children.push(new BevNode(""));
			}
			
			children[index] = node;
			
			return this;
		}
		
		public function setParams(...args) : BevNode{
			params = String(args[0]).split("|");
			locked = params[0];
			return this;
		}
		
		//判断是否锁定，只要有一个节点锁定，则所有判断都锁定
		public function checkLock() : Boolean{
			var result:Boolean = false;
			if(nowLocked){
				result = true;
			}else{
				for each(var node:BevNode in children){
					if(node.checkLock()){
						result = true;
						break;
					}
				}
			}
			return result;
		}
		
		private var targetStep:int;
		public function step():void{
			if(checkLock() || target == null){
				entity.isLock = true;
				return;
			}
			
			if(children != null){
				//是否执行该节点的doStart()函数
				if(nowStatus != BevTreeConst.IS_EXECUTE && doJudge()){
					for(var i:int = 0; i < children.length; i++){
						if(i <= nowIndex)
							children[i].doStart();
					}
				}
				
				//是否对该节点的子节点每帧进行判断
				for(var j:int = 0; j < children.length; j++){
					if(j <= nowIndex)
						children[j].step();
				}
			}
			
			//判断节点是否已执行doStart()函数，如果已执行则每帧调用doExecute()函数
			if(nowStatus == BevTreeConst.IS_EXECUTE)
				doExecute();
			
			if(!nowLocked){
				targetStep++;
				if(targetStep == 30){
					targetJudge();
					targetStep = 0;
				}
			}
		}
		
		private function targetJudge():void{
			RoleManager.getIns().seekTarget(entity);
		}
		
		public function doJudge():Boolean{
			return true;
		}
		
		public function doStart():void{
			nowStatus = BevTreeConst.IS_EXECUTE;
			preStatus = BevTreeConst.IS_NONE;
		}
		
		public function doExecute():void{
			if(nowStatus != BevTreeConst.IS_EXECUTE){
				nowStatus = BevTreeConst.IS_EXECUTE;
				preStatus = BevTreeConst.IS_NONE;
			}
		}
		
		public function doEnd():void{
			nowStatus = BevTreeConst.IS_END;
			preStatus = BevTreeConst.IS_EXECUTE;
		}
		
		public function get isExecute() : Boolean{
			if(nowStatus == BevTreeConst.IS_EXECUTE)
				return true;
			else
				return false;
		}
		
		public function get isNowLock() : Boolean{
			return nowLocked;
		}
		public function set isNowLock(value:Boolean) : void{
			nowLocked = value;
		}
		
		
		public function destroy():void{
			parent = null;
			entity = null;
			if(params){
				params.length = 0;
				params = null;
			}
			if(children){
				for(var i:int = 0; i < children.length; i++){
					children[i].destroy();
					children[i] = null;
				}
				children.length = 0;
				children = null;
			}
		}
		
		public function get target() : SequenceActionEntity{
			return RoleManager.getIns().target;
		}
	}
}