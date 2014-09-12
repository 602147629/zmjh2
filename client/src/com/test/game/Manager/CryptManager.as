package com.test.game.Manager
{
	import com.hurlant.util.Hex;
	import com.superkaka.Tools.Singleton;
	import com.test.game.DesCrypt.MyCrypt;
	
	import flash.utils.ByteArray;

	public class CryptManager extends Singleton
	{
		public static const keyObj:Object = {
			"108" : "21h2d54ha6w1hy2g3i1469z",
			"109" : "65asdy5q6ru53gk16z45d14",
			"110" : "s5h4f5wruty5ikjh213464s",
			"111" : "asd54gt5j21a35w4cq6w4r9"
		};
		public static const ivObj:Object = {
			"108" : "6ar4g65a465g46a54rg6a4e",
			"109" : "91246742sdgfesrgdfgs3ce",
			"110" : "a3215f5a1efas32d1g5qar1",
			"111" : "7j5uuok131asw5q7we853g8"
		};
			
		public function CryptManager(){
			super();
		}
		
		public static function getIns():CryptManager{
			return Singleton.getIns(CryptManager);
		}
		
		//开始加密
		public function encrypt(data:String, version:int) : String{
			var key:ByteArray = Hex.toArray(keyObj[version]);
			var iv:ByteArray = Hex.toArray(ivObj[version]);
			var aes:MyCrypt = new MyCrypt(key, iv, "aes");
			var byte:ByteArray = aes.encryptString(data);
			var result:String = Hex.fromArray(byte);
			return result;
		}
		
		//开始解密
		public function decrypt(data:String, version:int) : String{
			var key:ByteArray = Hex.toArray(keyObj[version]);
			var iv:ByteArray = Hex.toArray(ivObj[version]);
			var aes:MyCrypt = new MyCrypt(key, iv, "aes");
			var result:String = aes.decryptString(Hex.toArray(data));
			return result;
		}
	}
}