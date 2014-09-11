package com.test.game.Utils
{
	import flash.utils.ByteArray;

	public class AllUtils
	{
		public function AllUtils()
		{
		}
		
		
		//获得字符串中的数字
		public static function getNumFromString(str:String) : int{
			var r:RegExp = /\d/igx; 
			return int(str.match(r).join(""));
		}
		
		//取数字后面remian位
		public static function getLastNum(input:int, remain:int) : String{
			var result:String;
			var str:String = input.toString();
			result = str.substr(str.length - remain, remain);
			return result;
		}
		
		public static function getStringBytesLength(str:String,charSet:String):int{   
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(str, charSet);
			bytes.position = 0;
			return bytes.length;
		}   
		
		//返回base的count次方
		public static function getSquareNum(count:int, base:int = 2) : int{
			var result:int = 1;
			while(count > 0){
				result = result * base;
				count--;
			}
			return result;
		}
		
		//删除数组中重复的数据
		public static function getUnique(arr:Array) : Array{
			var tempArr:Array=[];
			var l:uint=arr.length;
			for (var i:uint=0;i<l;i++) {
				if (tempArr.indexOf(arr[i])==-1) {  
					//在新的数组里搜索是否存在相同元素,如果不存在加进新的数组里
					tempArr.push(arr[i]);
				}
			}
			return tempArr;
		}

		//不足两位数前面加0
		public static function addPre(count:Number) : String{
			var result:String = "";
			if(count < 10)
				result = "0" + count;
			else
				result = count.toString();
			
			return result
		}
		
	}
}