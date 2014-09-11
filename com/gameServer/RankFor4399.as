package com.gameServer
{
	import com.superkaka.Tools.DebugArea;
	import com.test.game.Const.DebugConst;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import unit4399.events.RankListEvent;
	
	public class RankFor4399 extends EventDispatcher
	{
		public var serviceHold:*;
		private var _stage:Stage;
		private static var _instance : RankFor4399;
		
		public static function getIns():RankFor4399
		{
			if(_instance == null){
				_instance = new RankFor4399();
			}
			return _instance;
		}
		
		public function RankFor4399(target:IEventDispatcher=null)
		{
			super();
		}
		
		public function get stage() : Stage
		{
			return _stage;
		}
		public function set stage(value:Stage) : void
		{
			_stage = value;
			
			serviceHold = Main.serviceHold;
			//initInfoTxt();
			initEvent();
		}
		
		private function initEvent():void{
			stage.addEventListener(RankListEvent.RANKLIST_ERROR,onRankListErrorHandler);
			stage.addEventListener(RankListEvent.RANKLIST_SUCCESS,onRankListSuccessHandler);
		}
		
		private function onRankListErrorHandler(evt:RankListEvent):void{
			var obj:Object = evt.data;
			var str:String  = "apiFlag:" + obj.apiName +"   errorCode:" + obj.code +"   message:" + obj.message + "\n";
			DebugArea.getIns().showResult(str, DebugConst.NORMAL);
		}
		
		private function onRankListSuccessHandler(evt:RankListEvent):void{
			var obj:Object = evt.data;
			DebugArea.getIns().showResult("apiFlag:" + obj.apiName+ "\n", DebugConst.NORMAL);
			
			var data:* =  obj.data;
			
			switch(obj.apiName){
				case "1":
					//根据用户名搜索其在某排行榜下的信息
				case "2":
					//根据自己的排名及范围取排行榜信息
				case "4":
					//根据一页显示多少条及取第几条数据来取排行榜信息
					decodeRankListInfo(data);
					break;
				case "3":
					//批量提交成绩至对应的排行榜(numMax<=5,extra<=500B)
					decodeSumitScoreInfo(data);
					break;
				case "5":
					//根据用户ID及存档索引获取存档数据
					decodeUserData(data);
					break;
			}
		}
		
		private function decodeUserData(dataObj:Object):void{
			if(dataObj == null){
				DebugArea.getIns().showResult("没有用户数据！\n", DebugConst.NORMAL);
				return;
			}
			var str:String = "存档索引：" + dataObj.index+"\n标题:" + dataObj.title+"\n数据："+dataObj.data+"\n存档时间："+dataObj.datetime+"\n";
			DebugArea.getIns().showResult(str, DebugConst.NORMAL);
		}
		
		private function decodeSumitScoreInfo(dataAry:Array):void{
			if(dataAry == null || dataAry.length == 0){
				DebugArea.getIns().showResult("没有数据,返回结果有问题！\n", DebugConst.NORMAL);
				return;
			}
			
			for(var i:int in dataAry){
				var tmpObj:Object = dataAry[i];
				var str:String = "第" + (i+1) + "条数据。排行榜ID：" + tmpObj.rId + "，信息码值：" +tmpObj.code +"\n";
				//tmpObj.code == "20005" 表示排行榜已被锁定
				if(tmpObj.code == "10000"){
					str += "当前排名:" + tmpObj.curRank+",当前分数："+tmpObj.curScore+",上一局排名："+tmpObj.lastRank+",上一局分数："+tmpObj.lastScore+"\n";
				}else{
					str += "该排行榜提交的分数出问题了。信息："+tmpObj.message+"\n";
				}
				//DebugArea.getIns().showResult(str, DebugConst.NORMAL);
			}
		}
		
		private function decodeRankListInfo(dataAry:Array):void{
			if(dataAry == null || dataAry.length == 0){
				DebugArea.getIns().showResult("没有数据！\n", DebugConst.NORMAL);
				return;
			}
			
			for(var i:int in dataAry){
				var tmpObj:Object = dataAry[i];
				var str:String = "第" + (i+1) + "条数据。存档索引：" + tmpObj.index+",用户id:" + tmpObj.uId+",昵称："+tmpObj.userName+",分数："+tmpObj.score+",排名："+tmpObj.rank+",来自："+tmpObj.area+",扩展信息："+tmpObj.extra+"\n";
				DebugArea.getIns().showResult(str, DebugConst.NORMAL);
			}
		}
		
		/*
		idx 为存档索引
		rankInfoAry 为多个排行榜的集合。里面包含每个排行榜的数据对象，如下：
		obj.rId 为排行榜Id，int类型（必填）
		obj.score 为提交的分数，int类型（必填）
		obj.extra 为扩展信息，object,array,int,string,xml类型，最大不超过500字节（可选）
		*/
		public function submitScoreToRankLists(idx:uint,rankInfoAry:Array) : void{
			if(serviceHold){
				serviceHold.submitScoreToRankLists(idx, rankInfoAry);
			}
		}
	}
}