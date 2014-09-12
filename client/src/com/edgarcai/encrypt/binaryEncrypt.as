package com.edgarcai.encrypt 
{
	import com.test.game.Manager.DigitalManager;
	
	import flash.utils.ByteArray;

	/**
	 * 二进制加密 
	 * @author edgarcai
	 */
	public class binaryEncrypt implements IEncrypt 
	{
		/**
		 * 加密逻辑
		 * @param	v
		 * @return
		 */
		private var _ran:Number = DigitalManager.getIns().getRandom() * 10000;
		private var _max:Number = 655360;
		protected function encodeCommand(v:Number):Number
		{
			var v1:Number = v ^ _ran;
			return v1>>_max;
		}
		/**
		 * 解密逻辑
		 * @param	v
		 * @return
		 */
		protected function decodeCommand(v:Number):Number
		{			
			var v1:Number = v << _max;
			var v2:Number = v1 ^ _ran;
			return v2;
		}
		/**
		 * 加密
		 * @param	data
		 * @return
		 */
		public function encode(data:*):*
		{
				var bytes:ByteArray = new ByteArray();
				bytes.writeObject(data);
				bytes.position = 0;
				var rBytes:ByteArray = new ByteArray();
				while (bytes.bytesAvailable)
				{
					rBytes.writeInt(encodeCommand(bytes.readByte()))
				}
				return rBytes;
		}
		
		/**
		 * 解密
		 * @param	data
		 * @return
		 */
		public function decode(data:*):*
		{
			if (data is ByteArray)
			{
				var bytes:ByteArray = data as ByteArray;
				bytes.position = 0;
				var rBytes:ByteArray = new ByteArray();
				while (bytes.bytesAvailable)
				{
					rBytes.writeByte(decodeCommand(bytes.readInt()))
				}
				rBytes.position = 0;
				return rBytes.readObject();
			}
			else
			{
				//throw new Error("数据类型不正确");
				return null;
			}
		}
	}

}