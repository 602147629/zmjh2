package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class AttachInfo
	{
		public function AttachInfo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			_attachArr = [-1,-1,-1];
		}
		
		private var _anti:Antiwear;
		
		private var _attachArr:Array;
		public function set attachArr(value:Array) : void
		{
			_attachArr = value;
		}
		public function get attachArr() : Array
		{
			return 	_attachArr;
		}
		
	}
}