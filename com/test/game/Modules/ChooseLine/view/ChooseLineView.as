package com.test.game.Modules.ChooseLine.view{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.superkaka.mvc.Control.net.SMessage;
	import com.test.game.Mvc.Vo.Line;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	import com.test.game.net.sm.Line.ChooseLine;
	import com.test.game.net.sm.Line.GetLines;
	
	public class ChooseLineView extends BaseView{
		public function ChooseLineView(){
			super();
		}
		
		override public function init():void{
			super.init();
			
			//发送请求线列表
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			var sm:SMessage = new GetLines();
			ssc.send(sm);
		}
		
		
		public function getLineReturn(lines:Vector.<Line>):void{
			var i:uint=0;
			for each(var line:Line in lines){
				this.newBtn(line,i);
				i++;
			}
		}
		
		
		private function newBtn(line:Line,i:uint):void{
			var sl:SingleLine = new SingleLine();
			sl.initWithLine(line);
			sl.x = 100+120*i;
			this.addChild(sl);
			sl.addEventListener(SingleLine.CHOOSE,__chooseLine);
		}
		
		protected function __chooseLine(evt:CommonEvent):void{
			var sp:SingleLine = evt.currentTarget as SingleLine;
			var chooseLine:Line = evt.data as Line;
			//发送选择结果
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			var sm:SMessage = new ChooseLine(chooseLine);
			ssc.send(sm);
		}	
		
		
		
		override public function step():void{
			super.step();
			
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy():void{
			super.destroy();
			
		}
	}
}


