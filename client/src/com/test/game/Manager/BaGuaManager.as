package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.PublicNoticeType;
	import com.test.game.Mvc.Configuration.EightDiagrams;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class BaGuaManager extends Singleton
	{

		public function BaGuaManager()
		{
			super();
		}
		
		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public static function getIns():BaGuaManager{
			return Singleton.getIns(BaGuaManager);
		}
		
		
		
		//按照物品id排序
		public function sortBaGuaByItemId():void{
			
			var newVector:Vector.<BaGuaPieceVo> = new Vector.<BaGuaPieceVo>;
			newVector=unAttachBaGuaPiece.sort(compare);
			for(var i:int=0;i<newVector.length;i++){
				newVector[i].cid=i;
			}
			
			function compare(x:BaGuaPieceVo,y:BaGuaPieceVo):Number{
				var result:Number;
				if(x.id > y.id){
					result = 1;
				}else if(x.id < y.id){
					result = -1;
				}else{
					if(x.lv > y.lv){
						result = 1;
					}else if(x.lv < y.lv){
						result = -1;
					}else{
						result = 0;
					}
				}
				
				return result;
			}
		}
		
		//boss卡片背包排序
		public function sortByCId(vector:Vector.<BaGuaPieceVo>):Vector.<BaGuaPieceVo>{
			
			var newVector:Vector.<BaGuaPieceVo> = new Vector.<BaGuaPieceVo>;
			newVector=vector.sort(compare);
			for(var i:int=0;i<newVector.length;i++){
				newVector[i].cid=i;
			}
			
			return newVector;
			
			function compare(x:BaGuaPieceVo,y:BaGuaPieceVo):Number{
				var result:Number;
				if(x.cid > y.cid){
					result = 1;
				}else if(x.cid < y.cid){
					result = -1;
				}else{
					result = 0;
				}
				
				return result;
			}
		}
		
		public function get unAttachBaGuaPiece() :Vector.<BaGuaPieceVo>
		{
			var unAttach:Vector.<BaGuaPieceVo> = new Vector.<BaGuaPieceVo>();
			
			for each(var baguaPiece:BaGuaPieceVo in player.baGuaPieces)
			{
				if (baguaPiece.cid>=0){
					unAttach.push(baguaPiece);
				}
			}
			return unAttach;
		}
		
		public function get attachBaGuaPiece() :Vector.<BaGuaPieceVo>
		{
			var attachs:Vector.<BaGuaPieceVo> = new Vector.<BaGuaPieceVo>();
			for each (var bagua:BaGuaPieceVo in player.baGuaPieces){
				if(bagua.cid <0){
					attachs.push(bagua);
				}
			}
			return attachs;
		}
		
		public function get unProtectedBaGuaPiece() :Vector.<BaGuaPieceVo>
		{
			var unProtect:Vector.<BaGuaPieceVo> = new Vector.<BaGuaPieceVo>();
			
			for each(var baguaPiece:BaGuaPieceVo in player.baGuaPieces)
			{
				if (baguaPiece.cid>=0 && baguaPiece.protect == 0){
					unProtect.push(baguaPiece);
				}
			}
			return unProtect;
		}
		
		public function getSuitData():Array{
			var suitArr:Array = new Array();
			for(var i:int = 0;i<attachBaGuaPiece.length;i++){
				var suitNum:int = 1;
				var addNew:Boolean = true;
				var suitId:int = attachBaGuaPiece[i].suitId;
				if(suitArr.length==0){
					suitArr.push({id:suitId,num:suitNum});
				}else{
					for(var j:int = 0;j<suitArr.length;j++){
						if(suitArr[j].id == suitId){
							suitArr[j].num++;
							addNew = false;
						}
					}
					if(addNew){
						suitArr.push({id:suitId,num:suitNum});
					}
				}
			}
			return suitArr;
		}
		
		
		
		/**
		 * 装上八卦牌
		 * @param bagua
		 * 
		 */
		public function upBaGua(upBaGua:BaGuaPieceVo) : void
		{
			var downBaGuaId:int;
			var index:int = upBaGua.index;
			var upCid:int = upBaGua.cid;
			var baGuaAttachs:Array = player.baGuaAttachs;
			downBaGuaId = baGuaAttachs[index];
			
			/// 卸下原有附体
			if (downBaGuaId != -1)
			{
				var downBaGua:BaGuaPieceVo = searchAttachedBaGua(downBaGuaId);
				downBaGua.cid = upCid;
			}
			
			baGuaAttachs[index] = upBaGua.id.toString();
			player.baGuaAttachs = baGuaAttachs;
			upBaGua.cid = -(index+1);
			
			PlayerManager.getIns().updatePropertys();
		}
		
		
		
		/**
		 * 卸下附体八卦牌
		 * @param downBaGua: 卸下的八卦牌
		 * 
		 */		
		public function downAttach(downBaGua:BaGuaPieceVo) : void
		{
			//player.pack.packUsed += 1;
			var baGuaAttachs:Array = player.baGuaAttachs;
			baGuaAttachs[downBaGua.index] = "-1";
			player.baGuaAttachs = baGuaAttachs;
			downBaGua.cid = unAttachBaGuaPiece.length;
			PlayerManager.getIns().updatePropertys();
		}
		
		/**
		 * 合并八卦牌
		 * @param downBaGua: 卸下的八卦牌
		 * 
		 */	
		public  function combineBaGua(giver:BaGuaPieceVo,receiver:BaGuaPieceVo):void
		{
			if(receiver.lv < NumberConst.getIns().baguaMaxLv){
				reduceBaGuaPiece(giver);
				upgradeBaGuaPiece(receiver,giver.exp+giver.baseExp);
				if(giver.exp+giver.baseExp>=10000){
					LogManager.getIns().addMissionLog("bagua_up",giver.exp+giver.baseExp);
				}
			}
		}
		
		/**
		 * 升级八卦牌
		 * 
		 */
		private function upgradeBaGuaPiece(bagua:BaGuaPieceVo,exp:int):void{
			if(bagua.lv>=NumberConst.getIns().baguaMaxLv){
				bagua.lv = NumberConst.getIns().baguaMaxLv;
				bagua.exp = bagua.maxExp;
			}else{
				if(bagua.exp+exp>=bagua.maxExp){
					var needExp:int = bagua.maxExp - bagua.exp;
					var restExp:int = exp - needExp;
					bagua.exp += needExp;
					bagua.lv++;
					upgradeBaGuaPiece(bagua,restExp);
				}else{
					bagua.exp += exp;
				}
			}

		}
	
		/**
		 * 随机添加八卦牌到背包
		 * @param color 
		 *   0绿色   1蓝色   2紫色
		 */
		public function addRandomBaguaPiece(color:int,isSuanGua:Boolean = false):BaGuaPieceVo{
			var id:String = "8";
			//随机套牌
			var deck:String = Math.floor(Math.random()*2).toString();
			//随机八卦方向
			var dir:String = (Math.floor(Math.random()*8)+1).toString();
			switch(color){
				case 0:
					id+=color+"0"+dir;
					break;
				case 1:
					id+=color+deck+dir;
					break;
				case 2:
					id+=color+deck+dir;
					break;
			}
			var vo:BaGuaPieceVo = creatBaGua(int(id));
			addBaGuaIntoPack(vo);
			
			if(color == 2 && isSuanGua){
				addPurplePublicNotice(vo.name);
			}
			
			return vo;
		}
		
		private function addPurplePublicNotice(name:String):void{
			PublicNoticeManager.getIns().sendPublicNotice(PublicNoticeType.PURPLE_BAGUA,name);
		}
		
		public function createBaGuaById(id:int) : void{
			var vo:BaGuaPieceVo = creatBaGua(id);
			vo.cid = unAttachBaGuaPiece.length;
			player.baGuaPieces.push(vo);
		}
		
		public function addBaGuaIntoPack(vo:BaGuaPieceVo) : void{
			vo.cid = unAttachBaGuaPiece.length;
			player.baGuaPieces.push(vo);
		}
		
		/**
		 * 
		 * 生成八卦牌数据
		 * 
		 */
		private  function creatBaGua(id:int) : BaGuaPieceVo
		{
			var baGua:BaGuaPieceVo = new BaGuaPieceVo();
			baGua.eightDiagram = ConfigurationManager.getIns().getObjectByID(AssetsConst.EIGHT_DIAGRAMS,id) as EightDiagrams;
			baGua.type = ItemTypeConst.BAGUA;
			baGua.name = baGua.eightDiagram.name;
			baGua.id = id;
			baGua.lv = NumberConst.getIns().one;
			baGua.exp = NumberConst.getIns().zero;
			return baGua;
		}
		
		/**
		 * 
		 * 生成灵气牌数据
		 * 
		 */
		public  function creatLingQiBaGua(id:int) : BaGuaPieceVo
		{
			var baGua:BaGuaPieceVo = new BaGuaPieceVo();
			baGua.eightDiagram = ConfigurationManager.getIns().getObjectByID(AssetsConst.EIGHT_DIAGRAMS,id) as EightDiagrams;
			baGua.type = ItemTypeConst.BAGUA;
			baGua.name = baGua.eightDiagram.name;
			baGua.id = id;
			baGua.lv = NumberConst.getIns().one;
			baGua.exp = baGua.eightDiagram.exp;
			return baGua;
		}
		

		
		/**
		 * 移除八卦牌
		 * 
		 */
		private function reduceBaGuaPiece(bagua:BaGuaPieceVo):void{
			player.baGuaPieces.splice(
				searchBaGuaIndex(bagua),1);
			bagua = null;
		}
		
		
		private function searchBaGuaIndex(bagua:BaGuaPieceVo) : int
		{
			var index:int = -1;
			
			for (var i:int = 0, len:int = player.baGuaPieces.length; i < len; i++)
			{
				if (player.baGuaPieces[i].cid == bagua.cid)
				{
					index = i;
					break;
				}
			}
			return index;
		}
		
		/**
		 * 搜索附体的八卦牌
		 * @param id
		 * 
		 */		
		public function searchAttachedBaGua(id:int) : BaGuaPieceVo
		{
			var Vo:BaGuaPieceVo;
			for each(var baGua:BaGuaPieceVo in attachBaGuaPiece)
			{
				if (baGua && baGua.id == id)
				{
					Vo = baGua;
					break;
				}
			}
			return Vo;
		}
		
		/**
		 *检查增加的背包格是否大于最大背包格 
		 */	
		public function checkFull(num:int = 1):int{
			//1可以放得下  0刚好满  -1放不下
			var result:int = 0;
			
			if(unAttachBaGuaPiece.length+num<player.baGuaRoomMax){
				result = 1;
			}else if(unAttachBaGuaPiece.length+num==player.baGuaRoomMax){
				result = 0;
			}else{
				result = -1;
			}
			return result;
		}
		
		/**
		 *检查增加的背包格是否大于最大背包格 
		 */	
		public function checkMaxRooM():Boolean{
			var result:Boolean = true;

			if(unAttachBaGuaPiece.length+1>player.baGuaRoomMax){
				result = false;
			}else{
				result = true;
			}
			return result;
		}
		

	}
}