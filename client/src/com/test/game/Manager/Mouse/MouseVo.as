package com.test.game.Manager.Mouse
{
	import com.superkaka.game.Base.BaseVO;
	
	public class MouseVo extends BaseVO
	{
		public var mouseCode:uint = 0;
		public var mGlobalX:Number;//当前鼠标指针坐标
		public var mGlobalY:Number;
		public var mPreviousGlobalX:Number;//较早的鼠标指针坐标
		public var mPreviousGlobalY:Number;
		public var time:uint = 0;//持续时间(分按下和弹起2种状态的持续时间)
		public var lastMouseDownTime:uint = 0;//上一次按下时间
		public var curMouseDownTime:uint = 0;//当前一次按下时间
		public var isJustMouseDown:Boolean = false;//是否第一次按下
		public var isMouseDown:Boolean = false;//是否处于按下状态
		public var isDoubleClick:Boolean = false;//是否持续触发双击事件
		public var isJustMouseUp:Boolean = false;//是否刚弹起
		public var isMouseUp:Boolean = false;//是否是处于弹起状态
		
		public function MouseVo(){
			super();
		}
	}
}