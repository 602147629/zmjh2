package com.test.game.Manager{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.AgreeMent.IStepAble;
	import com.superkaka.game.Const.GameConst;
	
	public class AnimationManager extends Singleton{
		protected var children:Vector.<IStepAble>;
		public var isStop:Boolean = false;
		
		public function AnimationManager(){
			super();
			this.children = new Vector.<IStepAble>();
		}
		
		public static function getIns():AnimationManager{
			return Singleton.getIns(AnimationManager);
		}
		
		public function step():void{
			if(isStop) return;
			var numObjects:int = this.children.length;
//						trace("AnimationManager->numObjects:"+numObjects)
			var currentIndex:int = 0;
			var i:int;
			
			if (numObjects == 0){
				return;
			}
			
			//对于在遍历时新增的对象不会马上渲染，下一帧再开始渲染
			for (i=0; i<numObjects; i++){
				var isda:IStepAble = this.children[i];
				if (isda){
					//处理被删除的实体，往前移动实体，填补空元素
					if (currentIndex != i) {
						this.children[currentIndex] = isda;
						this.children[i] = null;
					}
					//渲染
					if(isda.renderSpeed != 1){
						if(isda.currentFrameCount > GameConst.stage.frameRate){
							isda.currentFrameCount = 0;
						}
						isda.currentFrameCount ++;
						
						var reRenderFrameInterval:int;
						if(isda.renderSpeed > 1){
							reRenderFrameInterval = (1 - (isda.renderSpeed - Math.abs(isda.renderSpeed)))*GameConst.stage.frameRate;
							//------加速------
							//整倍速的加速渲染
							var repeatCount:int = isda.renderSpeed;
							var flag:Boolean = true;
							while(flag && repeatCount > 0){
								flag = this.render(isda,currentIndex);
								repeatCount--;
							}
							//小于一倍的加速渲染
							if(flag && isda.currentFrameCount % reRenderFrameInterval == 0){
								this.render(isda,currentIndex);
							}
						}else{
							if(isda.renderSpeed != 0){
								reRenderFrameInterval = 1/isda.renderSpeed;
								//减速
								if(isda.currentFrameCount % reRenderFrameInterval == 0){
									this.render(isda,currentIndex);
								}
							}
						}
					}else{
						//正常
						this.render(isda,currentIndex);
					}
					++currentIndex;
				}
			}
			
			//处理新增实体
			if (currentIndex != i){
				numObjects = this.children.length;
				
				while (i < numObjects){
					this.children[int(currentIndex++)] = this.children[int(i++)];
				}
				
				this.children.length = currentIndex;
			}
		}
		
		private function render(isda:IStepAble,currentIndex:int):Boolean{
			if(!isda.isStopRender){
				isda.step();
			}
			return this.children[currentIndex];
		}
		
		public function addEntity(isda:IStepAble):void{
			if(isda && this.children.indexOf(isda) == -1){
				this.children.push(isda);
			}
		}
		
		
		public function numchildren():int{
			return this.children.length;
		}
		
		/**
		 * 移除渲染实体 
		 * @param isda
		 * 
		 */		
		public function removeEntity(isda:IStepAble):void{
			var index:int = this.children.indexOf(isda);
			if (index != -1){
				this.children[index] = null;
			}
		}
		
		
		public function contains(isda:IStepAble):Boolean{
			return this.children.indexOf(isda) != -1;
		}
		
		public function clear():void{
			this.children.length = 0;
		}
		
		public function get childrensList() : Vector.<IStepAble>{
			return this.children;
		}
		
	}
}