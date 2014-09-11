package com.edgarcai.util 
{
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author edgarcai
	 */
	public final class Utils 
	{
		
		public function Utils() 
		{
			
		}
		
		/**
		 * 二进制比较对象是否内容相同（此操作较慢）
		 * 
		 * @param obj1
		 * @param obj2
		 * @return 
		 * 
		 */
		public static function equal(obj1:*,obj2:*):Boolean
		{
			var bytes1:ByteArray = new ByteArray();
			bytes1.writeObject(obj1);
			bytes1.position = 0;
			var bytes2:ByteArray = new ByteArray();
			bytes2.writeObject(obj2);
			bytes2.position = 0;
			if (bytes1.length == bytes2.length)
			{
				while (bytes1.bytesAvailable)
				{
					if (bytes1.readByte() != bytes2.readByte())
						return false;
				}
			}
			else
				return false;
			return true;
		}
		
	}

}