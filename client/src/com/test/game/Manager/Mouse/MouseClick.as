package com.test.game.Manager.Mouse
{
	import com.superkaka.game.Manager.Keyboard.KeyVo;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class MouseClick
	{
		public static const MOUSEDOWN:uint = 0;//某按键处于按下状态
		public static const MOUSEUP:uint = 1;//某按键处于弹起状态
		public static const JUST_MOUSEDOWN:uint = 2;//某按键刚刚按下
		public static const JUST_MOUSEUP:uint = 3;//某按键刚刚弹起
		public static const DOUBLE_CLICK:uint = 4;//某按键触发双击状态
		
		
		private var MouseDict:Dictionary;
		
		public var doubleClickInterval:uint = 500;//双击判定间隔
		
		public function MouseClick(){
			this.MouseDict = new Dictionary();
		}
		
		public function step():void{
			for each(var mv:MouseVo in this.MouseDict){
				if(mv.isJustMouseUp){
					mv.isJustMouseUp = false;
				}
				if(mv.isJustMouseDown){
					mv.isJustMouseDown = false;
				}
				if(mv.isDoubleClick){
					mv.isDoubleClick = false;
				}
				if(mv.isMouseUp){
					mv.time++;
				}
			}
		}
		
		/**
		 * 按下按键 
		 * @param keycode
		 * 
		 */		
		public function mouseDown(mouseCode:uint):void{
			var mv:MouseVo;
			if(!this.MouseDict[mouseCode]){
				mv = new MouseVo();
				mv.mouseCode = mouseCode;
				this.MouseDict[mouseCode] = mv;
			}else{
				mv = this.MouseDict[mouseCode];
			}
			
			if(!mv.isMouseDown){
				//新一次按下按键，替换按下时间
				mv.lastMouseDownTime = mv.curMouseDownTime;
				mv.curMouseDownTime = getTimer();
				
				
				mv.isDoubleClick = false;
				if(mv.isMouseUp){
					//判定双击
					if(mv.curMouseDownTime - mv.lastMouseDownTime <= this.doubleClickInterval){
						//双击
						mv.isDoubleClick = true;
					}
				}
				mv.time = 1;
				mv.isMouseDown = true;
				mv.isJustMouseDown = true;
				mv.isJustMouseUp = false;
				mv.isMouseUp = false;
			}else{
				mv.time++;	
				mv.isMouseDown = true;
				mv.isJustMouseDown = false;
				mv.isJustMouseUp = false;
				mv.isMouseUp = false;
				mv.isDoubleClick = false;
			}
		}
		
		
		/**
		 * 弹起按键 
		 * @param keycode
		 * 
		 */		
		public function keyUp(keycode:uint):void{
			var kv:KeyVo = this.MouseDict[keycode];
			if(kv){
				kv.time = 1;
				kv.isJustKeyUp = true;
				kv.isKeyDown = false;
				kv.isJustKeyDown = false;
				kv.isDoubleClick = false;
				kv.isKeyUp = true;
			}
		}
		
		
		/**
		 *是否处于按下状态 
		 * @param keycode
		 * @return 
		 * 
		 */		
		public function isKeyDown(keycode:uint):Boolean{
			var kv:KeyVo = this.MouseDict[keycode];
			return kv && kv.isKeyDown;
		}
		
		/**
		 * 是否刚刚按下瞬间 
		 * @param keycode
		 * @return 
		 * 
		 */		
		public function isJustKeyDown(keycode:uint):Boolean{
			var kv:KeyVo = this.MouseDict[keycode];
			return kv && kv.isJustKeyDown;
		}
		
		
		/**
		 * 是否刚刚弹起按键 
		 * @param keycode
		 * 
		 */		
		public function isJustKeyUp(keycode:uint):Boolean{
			var kv:KeyVo = this.MouseDict[keycode];
			return kv && kv.isJustKeyUp;
		}
		
		
		/**
		 * 是否是处于弹起状态 
		 * @param keycode
		 * @return 
		 * 
		 */		
		public function isKeyUp(keycode:uint):Boolean{
			var kv:KeyVo = this.MouseDict[keycode];
			return !kv || (kv && kv.isKeyUp);
		}
		
		/**
		 * 是否双击 
		 * @param keycode
		 * @return 
		 * 
		 */		
		public function isDoubleClick(keycode:uint):Boolean{
			var kv:KeyVo = this.MouseDict[keycode];
			return kv && kv.isDoubleClick;
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		public function destroy():void{
			this.MouseDict = null;
		}
	}
}