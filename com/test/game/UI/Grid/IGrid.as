package com.test.game.UI.Grid
{
	public interface IGrid
	{
		
		function setData(data:*) : void;
		
		function setLocked() : void;
		
		function set x(value:Number) : void;
		
		function set menuable(value:Boolean) : void;
		
		function set selectable(value:Boolean) : void;
		
		function set index(value:int) : void;
		
		function set y(value:Number) : void;
		
		function  destroy() : void;
	}
}