package unit4399{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	/**
	 * @author edgarcai
	 */
	public class YuanChuangInface
	{
		public function YuanChuangInface()
		{
			if (!_canCreate)
			{
				throw(new ArgumentError("create YuanChuangInface error"));
			}
		}
		
		public static function getInstance():YuanChuangInface
		{
			if (_instanc == null)
			{
				_canCreate = true;
				_instanc = new YuanChuangInface();
				_canCreate = false;
			}
			return _instanc;
		}
		
		public function setInterface(stageHolder:Stage, obj:Object, gameId:String):void
		{
			_interface = obj as DisplayObject;
			if (_interface == null)
				return;
			stageHolder.addChild(_interface as DisplayObject);
			var obj:Object = new Object;
			obj["integralMode"] = true;   //提交积分
			obj["gameListMode"] = true;   //游戏列表
			obj["saveMode"] = true;		  //游戏存档
			obj["shopMoney"] = true;
			obj["payMoney"] = true;
			obj["rankListMode"] = true;
			_interface["setStyle"](gameId, obj);
		}
		
		public function isLoadCtrl():Boolean
		{
			if (_interface != null)
			{
				return true;
			}
			return false;
		}
		//
		public function getServeTime() : void
		{
			if (_interface != null)
			{
				_interface["getServerTime"]();
			}
		}
		
		//根据用户uid和存档索引获得数据
		public function getUserData(arg1:String, arg2:uint):void
		{
			if (_interface != null)
			{
				_interface["getUserData"](arg1, arg2);
			}
		}
		
		//提交成绩到排行榜
		public function submitScoreToRankLists(arg1:uint, arg2:Array):void
		{
			if (_interface != null)
			{
				_interface["submitScoreToRankLists"](arg1, arg2);
			}
		}
		
		//根据用户名搜索其在某排行榜下的信息
		public function getOneRankInfo(arg1:uint, arg2:String):void
		{
			if (_interface != null)
			{
				_interface["getOneRankInfo"](arg1, arg2);
			}
		}
		
		//根据自己的排名及范围取排行榜信息
		public function getRankListByOwn(arg1:uint, arg2:uint, arg3:uint):void
		{
			if (_interface != null)
			{
				_interface["getRankListByOwn"](arg1, arg2, arg3);
			}
		}
		
		//根据一页显示多少条及取第几页数据来取排行榜信息
		public function getRankListsData(arg1:uint, arg2:uint, arg3:uint):void
		{
			if (_interface != null)
			{
				_interface["getRankListsData"](arg1, arg2, arg3);
			}
		}
		
		//推荐列表
		public function showGameList():void
		{
			if (_interface != null)
			{
				_interface["showGameList"]();
			}
		}
		
		//打开登录面板
		public function showLogPanel():void
		{
			if (_interface != null)
			{
				_interface["showLogPanel"]();
			}
		}
		
		public function getStoreState() : void
		{
			if(_interface != null)
			{
				_interface["getStoreState"]();
			}
		}
		
		//是否登录
		public function isLogin():Object
		{
			if (_interface != null)
			{
				return _interface["isLog"];
			}
			return null;
		}
		
		//排行榜
		public function openSortWin():void
		{
			if (_interface != null)
			{
				_interface["openSortWin"]();
			}
		}
		
		//4399存档
		/**
		 * @param	_title
		 * @param	_data
		 */
		public function openSaveUI(_title:String, _data:Object):void
		{
			if (_interface != null)
			{
				_interface["openSaveUI"](_title, _data);
			}
		}
		
		//打开4399存档UI
		public function getData(ui:Boolean = true,index:Number =0):void
		{
			if (_interface != null)
			{
				_interface["get"](ui,index);
			}
		}
		
		//保存4399存档
		public function saveData(title:String, saveObj:Object, neeUI:Boolean=true, saveIndex:int=0):void
		{
			if (_interface != null)
			{
				_interface["save"](title,saveObj,neeUI,saveIndex);
			}
		}
		//获取存档列表，无UI
		public function getList():void
		{
			if (_interface != null)
			{
				_interface["getList"]();
			}			
		}
		
		//商城相关，未知
		public function buyProFun(_arg1:String, _arg2:int):void
		{
			if (_interface != null)
			{
				_interface["buyProFun"](_arg1, _arg2);
			}
		}
		
		//商城相关，未知		
		public function consumeItemFun(_arg1:String):void
		{
			if (_interface != null)
			{
				_interface["consumeItemFun"](_arg1);
			}
		}
		
		//商城相关，未知	
		public function removeItemsFun(_arg1:Array):void
		{
			if (_interface != null)
			{
				_interface["removeItemsFun"](_arg1);
			}
		}
		
		//商城相关，未知	
		public function addItemsFun(_arg1:Array):void
		{
			if (_interface != null)
			{
				_interface["addItemsFun"](_arg1);
			}
		}
		
		//商城相关，未知
		public function updateItemProFun(_arg1:Object):void
		{
			if (_interface != null)
			{
				_interface["updateItemProFun"](_arg1);
			}
		}
		
		//增加游戏币
		public function incMoney(money:int):void
		{
			if(_interface != null)
			{
				_interface["incMoney"](money);
			}
		}
		
		//减少游戏币
		public function decMoney(money:int) : void
		{
			if(_interface != null)
			{
				_interface["decMoney"](money);
			}
		}
		
		//获得游戏币的值
		public function getBalance() : int
		{
			var balance:int = 0;
			if(_interface != null)
			{
				balance  = _interface["getBalance"]();
			}
			return balance;
		}
		
		//打开充值链接
		public function payMoney(money:int) : void
		{
			if(_interface != null)
			{
				_interface["payMoney"](money);
			}
		}
		
		//获取累积消费的游戏币
		public function getTotalPaiedFun(dataObj:Object = null) : void
		{
			if(_interface != null)
			{
				_interface["getTotalPaiedFun"](dataObj);
			}
		}
		
		//获取累积充值的游戏币
		public function getTotalRechargedFun(dataObj:Object = null) : void
		{
			if(_interface != null)
			{
				_interface["getTotalRechargedFun"](dataObj);
			}
		}
		
		//用户退出
		public function userLogOut():void
		{
			if (_interface != null)
			{
				_interface["userLogOut"]();
			}
			else
			{
				if (_loginProxy != null)
				{
					_loginProxy.loginOut();
				}
			}
		}
		
		//提交分数
		public function openIntegralWin(score:int):void
		{
			if (_interface != null)
			{
				_interface["openIntegralWin"](score);
			}
		}
		
		//商城
		public function showShopUi():void
		{
			if (_interface != null)
			{
				_interface["ShowShopUi"]();
			}
		}
		
		public function setMenuVisible(tog:Boolean):void
		{
			if (_interface != null)
			{
				_interface["setMenuVisible"](tog);
			}
		}
		
		//保存用户信息
		public function saveUserInfo(data:Object):void
		{
			if (_mySo == null)
			{
				_mySo = SharedObject.getLocal(_soName);
			}
			_mySo.data[_dataName] = data;
			
			var flushStatus:String = null;
			
			try
			{
				flushStatus = _mySo.flush();
			}
			catch (e:Error)
			{
				if (_mySo)
				{
					_mySo.close();
					_mySo = null;
				}
			}
			
			if (flushStatus != null)
			{
				switch (flushStatus)
				{
					case SharedObjectFlushStatus.PENDING: 
						if (_mySo)
							_mySo.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
						break;
					case SharedObjectFlushStatus.FLUSHED: 
						if (_mySo != null)
						{
							_mySo.close();
							_mySo = null;
						}
						break;
				}
			}
		}
		
		private function onFlushStatus(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				case "SharedObject.Flush.Success": 
					break;
				case "SharedObject.Flush.Failed": 
					break;
			}
			if (_mySo != null)
			{
				_mySo.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
				_mySo.close();
				_mySo = null;
			}
		}
		
		//获取用户信息
		public function getUserInfo():Object
		{
			var data:Object;
			
			if (_mySo == null)
			{
				_mySo = SharedObject.getLocal(_soName);
			}
			
			if (_mySo == null)
			{
				return null;
			}
			
			try
			{
				data = _mySo.data[_dataName];
			}
			catch (e:Error)
			{
				return null;
			}
			if (_mySo)
			{
				_mySo.close();
				_mySo = null;
			}
			return data;
		}
		
		public function set loginProxy(obj:Object):void
		{
			_loginProxy = obj;
		}
		
		public function get loginProxy():Object
		{
			return _loginProxy;
		}
		
		private var _soName:String = "com.edgarcai.adm";
		private var _dataName:String = "saveConf";
		private var _mySo:SharedObject;
		private var _interface:Object;
		private static var _canCreate:Boolean = false;
		private static var _instanc:YuanChuangInface;
		private var _loginProxy:Object;
	}
}
