package com.edgarcai.gamelogic 
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.events.CustomEventDispatcher;
	import fl.motion.Animator;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 防ce修改,目前防住了ce5.3,ce5.6，ce5.5，ce6.1
	 * @author edgarcai
	 */
	public class mainDoc extends MovieClip 
	{
		private var _hp:Number = 1010;
		private var _exp:Number = 2010;
		private var _mp:Number = 1110;
		
		public var hpValue:TextField;
		public var expValue:TextField;
		public var mpValue:TextField;
		public var errMsg:TextField;
		public var btnAddHP:addValue;
		public var btnSubHP:subValue;
		public var btnAddExp:addValue;
		public var btnSubExp:subValue;
		public var btnAddMP:addValue;
		public var btnSubMP:subValue;
		
		//加密相关
		private var _binaryEn:binaryEncrypt;
		private var _Antiwear:Antiwear;
		private var _dispatcher:CustomEventDispatcher=new CustomEventDispatcher();
		
		public function mainDoc() 
		{
			if (!stage)
			{
				this.addEventListener(Event.ADDED_TO_STAGE, startup);
			}else {
				startup();
			}
		}
		
		private function startup(e:Event=null):void 
		{
			if (e) {
				removeEventListener(Event.ADDED_TO_STAGE, startup);
			}
			//TODO:添加数据
			//TODO：防修改
			trace("启动防内存修改");
			//防修改初始化
			_binaryEn = new binaryEncrypt();
			_Antiwear = new Antiwear(_binaryEn);
			_Antiwear.hp = _hp;
			_Antiwear.exp = _exp;
			_Antiwear.mp = _mp;
			_dispatcher.addEventListener(CustomEventDispatcher.CHECKDATAERROR, onerrHandler);
			initGame();
		}
		
		private function onerrHandler(e:Event):void 
		{
			errMsg.text = "";
			errMsg.appendText("请文明游戏，勿使用内存修改器修改！   \n 肥菜团队敬上"+new Date().time);
		}
		
		private function initGame():void
		{
			showValue();
			btnAddHP.addEventListener(MouseEvent.CLICK, addHP);
			btnSubHP.addEventListener(MouseEvent.CLICK, subHP);
			btnAddExp.addEventListener(MouseEvent.CLICK, addExp);
			btnSubExp.addEventListener(MouseEvent.CLICK, subExp);
			btnAddMP.addEventListener(MouseEvent.CLICK, addMP);
			btnSubMP.addEventListener(MouseEvent.CLICK, subMP);
		}
		
		private function subMP(e:MouseEvent):void 
		{
			_Antiwear.mp -= 10;
			showValue();
		}
		
		private function addMP(e:MouseEvent):void 
		{
			_Antiwear.mp += 10;
			showValue();
		}
		
		private function subExp(e:MouseEvent):void 
		{
			//_Antiwear.exp -= 10;
			_exp -= 10;
			showValue();
		}
		
		private function addExp(e:MouseEvent):void 
		{
			//_Antiwear.exp += 10;
			_exp += 10;
			showValue();
		}
		
		private function showValue():void
		{
			hpValue.text = String(_Antiwear.hp);
			//expValue.text = String(_Antiwear.exp);
			expValue.text = String(_exp);
			mpValue.text = String(_Antiwear.mp);
		}
		
		private function subHP(e:MouseEvent):void 
		{
			_Antiwear.hp -= 10;
			showValue();
		}
		
		private function addHP(e:MouseEvent):void 
		{
			_Antiwear.hp += 10;
			showValue();
		}		
		
	}

}