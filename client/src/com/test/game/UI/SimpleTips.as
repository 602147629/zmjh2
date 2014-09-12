package com.test.game.UI
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Const.NameHelper;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.StringConst;
	import com.test.game.Manager.BaGuaManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EquipedManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Manager.TitleManager;
	import com.test.game.Mvc.Configuration.Charge;
	import com.test.game.Mvc.Configuration.EightDiagramSuits;
	import com.test.game.Mvc.Configuration.Title;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.Mvc.Vo.ItemVo;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;


	
	public class SimpleTips extends BaseView
	{
		private var _bg:Scale9GridDisplayObject;
		private static const LEFT_GAP:Number=10;
		private static const TOP_GAP:Number=10;
		private static const INTERVAL:Number = 8;
		
		public function SimpleTips()
		{
			initUi();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameTipLayer;	
		}
		
		private var _line:Sprite;
		private var _title:TipTextField;
		private var _info:TipTextField;

		
		protected function initUi() : void
		{
			// 底图
			_bg = new Scale9GridDisplayObject(AssetsManager.getIns().getAssetObject("tipBg")
				,new Rectangle(5,5,33,38));
			_bg.alpha = 1;
			this.addChild(_bg);
			
			var format:TextFormat = new TextFormat();
			format.leading = 3;
			
			//tip标题
			_title = createTextField(140);
			_title.x = LEFT_GAP;
			_title.wordWrap = true;
			_title.multiline = true;
			_title.defaultTextFormat = format;
			this.addChild(_title);
			
			//横线
			_line = AssetsManager.getIns().getAssetObject("line") as Sprite;
			this.addChild(_line);
			_line.x= LEFT_GAP;
			


			
			//tip内容
			_info = createTextField(140);
			_info.x = LEFT_GAP;
			_info.multiline = true;
			_info.wordWrap = true;
			_info.defaultTextFormat = format;
			this.addChild(_info);
			
			
			
	
			
		}


		private function getEquipTipTitle(data:ItemVo):String{
			var tip:String;
			tip = setColorName(data.equipConfig.color,data.name);
			tip += "<br>" + ItemTypeConst.getTypeName(data.type) + "           " + data.equipConfig.type;
			return tip;
		}
		
		private function getFashionTipTitle(data:ItemVo):String{
			var tip:String;
			tip = ColorConst.setDarkGreen(data.name);
			tip += "<br>" + getEquipOccName(int(data.id.toString().substr(1,1))+1) +ItemTypeConst.getTypeName(data.type);
			return tip;
		}
		
		private function getBaGuaTipTitle(data:BaGuaPieceVo):String{
			var tip:String;
			tip = setColorName(data.eightDiagram.color,data.name);
			//八卦牌类型
			tip += "<br>" + ItemTypeConst.getTypeName(data.type);
			//背包id cid
			//tip += "  " + data.cid;
			return tip;
		}
		
		private function setColorName(color:String,name:String):String{
			var tip:String
			switch(color){
				case "白":
					tip = "<font color='#ffffff'>"+name+"</font>";
					break;
				case "绿":
					tip = "<font color='#00ff00'>"+name+"</font>";
					break;
				case "蓝":
					tip = "<font color='#23caf2'>"+name+"</font>";
					break;
				case "紫":
					tip = "<font color='#ff00ff'>"+name+"</font>";
					break;
				case "橙":
					tip = "<font color='#ffcc00'>"+name+"</font>";
					break;
			}
			return tip;
		}
		
		private function getItemTipTitle(data:*):String{
			var tip:String;
			tip = ColorConst.setDarkGreen(data.name)+"<br>";
			switch(data.type){
				case ItemTypeConst.MATERIAL:
					tip += data.materialConfig.type;
					break;
				case ItemTypeConst.SPECIAL:
					if(data.id == NumberConst.getIns().wanNengId){
						tip = ColorConst.setPurple(data.name)+"<br>";
					}
					tip += data.specialConfig.type;
					break;
				case ItemTypeConst.BOOK:
					tip += ItemTypeConst.getTypeName(data.type);
					break;
				case ItemTypeConst.PROP:
					tip += data.propConfig.type;
					break;
				case ItemTypeConst.BOSS:
					tip += ItemTypeConst.getTypeName(data.type);
					break;
				case ItemTypeConst.BAGUA:
					tip += ItemTypeConst.getTypeName(data.type);
					break;
				case ItemTypeConst.FASHION:
					tip += ItemTypeConst.getTypeName(data.type);
					break;
			}
			
			//显示mid
			//tip+= data.mid
			return tip;
		}
		
		private function getEquipOccName(occ:int):String{
			var name:String;
			var str:String = occ.toString().charAt(0);
			switch(str){
				case "1":
					name = StringConst.ROLE_KUANGWU;
					break;
				case "2":
					name = StringConst.ROLE_XIAOYAO;
					break;
			}
			return name;
		}
		
		private function getEquipTipInfo(data:ItemVo):String{
			var tip:String;
			var propertyArr:Array = EquipedManager.getIns().getPropertyName(data); 
			var property:String = propertyArr[1] + "+" + data.equipConfig[propertyArr[0]].toString();
			var strengthen:String = "";
			if(data.lv>0){
				strengthen = "(+" + (data.lv*PlayerManager.getIns().player.strengthenUp[propertyArr[0]]).toString() +")";
			}
			tip = getEquipOccName(data.id) + "装备      " 
				+"<font color='#23caf2'>" + data.strengthen.strengthen_level + "</font><br>" 
				+"基础属性<br>    "
				+ property + " "+ColorConst.setGreen(strengthen)+"<br>";
			
			var chargeData:Charge = ConfigurationManager.getIns().getObjectByProperty(
				AssetsConst.CHARGE,"name",data.equipConfig.type) as Charge;
			for(var i:int = 0;i<4;i++){
				var lv:int = data.equipConfig.chargeLvArr[i];
				if(lv>0){
					var totalValue:Number = 0;
					
					var percentStr:String = ""; 
					if(chargeData.type[i]=="crit" || chargeData.type[i]=="evasion" || chargeData.type[i]=="hit"|| 
						chargeData.type[i]=="toughness" || chargeData.type[i]=="hurt_deepen"|| chargeData.type[i]=="hurt_reduce")
					{
						percentStr = "%";
					}
					
					var num:int = chargeData.value[i]*(1+lv)*lv/2*100;
					totalValue = num/100;
					
					tip += NameHelper.getColorChargeName(NameHelper.getChargeName(i)+lv+"级") +"<br>    "
					+ ColorConst.setGreen(NameHelper.getPropertyName(chargeData.type[i])+"+"+totalValue +percentStr)+"<br>";
				}
			}
			return tip;
		}
		
		private function getFashionTipInfo(data:ItemVo):String{
			var tip:String;
			tip = data.fashionConfig.message + "<br>增加属性<br>";
			
			for(var i:int=0;i<data.fashionConfig.add_type.length;i++){
				var property:String = "    "+NameHelper.getPropertyName(data.fashionConfig.add_type[i]) 
					+ "<font color='#23caf2'>+" + data.fashionConfig.add_value[i] +"</font><br>";
				tip += property;

				//"<font color='#23caf2'>""</font>" 
				//"<font color='#00ff00'>""</font>";

			}
			var time:int = TimeManager.getIns().disDayNum(data.time,TimeManager.getIns().curTimeStr);
			if(data.fashionConfig.time==0){
				tip += "剩余时间：永久";
			}else{
				tip += "剩余时间："+ (data.fashionConfig.time -time) +"天";
			}
			
	
			return tip;
		}
		
		
		private function getBaGuaTipInfo(data:BaGuaPieceVo):String{
			var tip:String;
			var typeArr:Array = data.eightDiagram.add_type;
			var valueArr:Array = data.eightDiagram.add_value;
			tip = data.eightDiagram.info+"<br>";
			if(typeArr[0]!="0"){
				for(var i:int =0;i<typeArr.length;i++){
					var percentStr:String = ""; 
					if(typeArr[i]=="crit" || typeArr[i]=="evasion" || typeArr[i]=="hit"|| 
						typeArr[i]=="toughness" || typeArr[i]=="hurt_deepen"|| typeArr[i]=="hurt_reduce"){
						percentStr = "%";
					}
					tip+="<font color='#00ff00'>"+NameHelper.getPropertyName(typeArr[i])+
						" +"+Number(valueArr[i])*data.lv+percentStr+"</font><br>";
				}	
			}
			tip+="<font color='#23caf2'>"+ data.lv + "级  灵气："+
				data.exp+"/"+data.maxExp+"</font><br>";
			

			if(data.suitId!=0 && data.suitId!=90){
				var attachSuitData:Array = BaGuaManager.getIns().getSuitData();
				var suitData:EightDiagramSuits = ConfigurationManager.getIns().getObjectByID(AssetsConst.EIGHT_DIAGRAM_SUITS,data.suitId) as EightDiagramSuits;
				
				if(data.cid>=0){
					tip+="三件  "+setSuitText(NameHelper.getPropertyName(suitData.first_add[0])+
						" +"+Number(suitData.first_add[1]))+
						"五件  "+setSuitText(NameHelper.getPropertyName(suitData.second_add[0])+
						" +"+Number(suitData.second_add[1]))+
						"八件  "+setSuitText(NameHelper.getPropertyName(suitData.third_add[0])+
						" +"+Number(suitData.third_add[1]));
				}else{
					for(var x:int =0;x<attachSuitData.length;x++){
						if(data.suitId == attachSuitData[x].id){
							var first:Boolean;
							var second:Boolean;
							var third:Boolean;
							if(attachSuitData[x].num>=3 ){
								first = true;
							}
							if(attachSuitData[x].num>=5){
								second = true;
							}
							if(attachSuitData[x].num==8){
								third = true;
							}
							tip+="三件  "+setSuitText(NameHelper.getPropertyName(suitData.first_add[0])+
								" +"+Number(suitData.first_add[1]),first);
							tip+="五件  "+setSuitText(NameHelper.getPropertyName(suitData.second_add[0])+
								" +"+Number(suitData.second_add[1]),second);
							tip+="八件  "+setSuitText(NameHelper.getPropertyName(suitData.third_add[0])+
								" +"+Number(suitData.third_add[1]),third);
						}
					}


				}

			}

			
			return tip;
		}
		
		
		private function setSuitText(str:String,show:Boolean = false):String{
			var result:String;
			if(show){
				result = " <font color='#00ff00'>"+str+"</font><br>";
			}else{
				result = " <font color='#545454'>"+str+"</font><br>";
			}
			return result;
		}
		

		
		public function setData(data:*):void{

			switch(data.type){
				case ItemTypeConst.EQUIP:
					_line.visible = true;
					_title.htmlText = getEquipTipTitle(data);
					_info.htmlText = getEquipTipInfo(data);
					
					break;
				case ItemTypeConst.MATERIAL:
					var materialTip:Array = data.materialConfig.message.split("\n");
					_line.visible = true;
					_title.htmlText = getItemTipTitle(data);
					_info.htmlText = materialTip[0]+"<br>"+ ColorConst.setDarkGreen(materialTip[1]);
					if(data.isPriceShow){
						_info.htmlText += "<br>"+ColorConst.setGold("卖出价："+data.sale_money);
					}
					break;
				case ItemTypeConst.BOOK:
					_line.visible = true;
					_title.htmlText = getItemTipTitle(data);
					_info.htmlText = data.bookConfig.message+"<br>"+ ColorConst.setDarkGreen(data.bookConfig.location+"掉落");
					if(data.isPriceShow){
						_info.htmlText += "<br>"+ColorConst.setGold("卖出价："+data.sale_money);
					}
					
					break;
				case ItemTypeConst.PROP:
					_line.visible = true;
					_title.htmlText = getItemTipTitle(data);
					_info.text = data.propConfig.message;
	
					break;
				case ItemTypeConst.SPECIAL:
					_line.visible = true;
					_title.htmlText = getItemTipTitle(data);
					_info.htmlText = data.specialConfig.message;
					if(data.isPriceShow){
						_info.htmlText += "<br>"+ColorConst.setGold("卖出价："+data.sale_money);
					}
					break;
				case ItemTypeConst.BOSS:
					_line.visible = true;
					var bossInfoArr:Array = data.specialConfig.message.split("|");
					var bossTips:String = bossInfoArr[0]+"<br>"
					+ColorConst.setLightBlue(bossInfoArr[1])+"<br>"
					+ColorConst.setDarkGreen(bossInfoArr[2]);
					
					_title.htmlText = getItemTipTitle(data);
					_info.htmlText = bossTips;
					if(data.isPriceShow){
						_info.htmlText += "<br>"+ColorConst.setGold("卖出价："+(data.sale_money+(data.lv-1)*NumberConst.getIns().bossUpPrice));
					}
					break;
				case ItemTypeConst.BAGUA:
					_line.visible = true;
					_title.htmlText = getBaGuaTipTitle(data);
					_info.htmlText = getBaGuaTipInfo(data);
					break;
				case ItemTypeConst.FASHION:
					_line.visible = true;
					_title.htmlText = getFashionTipTitle(data);
					_info.htmlText = getFashionTipInfo(data);
					break;
				case ItemTypeConst.TITLE:
					_line.visible = true;
					_title.htmlText = getTitleTipInfo(data)[0];
					_info.htmlText = getTitleTipInfo(data)[1];
					break;
				default:
					_line.visible = false;
					_title.htmlText = data.title;
					_info.htmlText = data.tips;

				}
			
			setVerticalPos();
		}
		
		
		private function getTitleTipInfo(data:*):Array{
			var arr:Array = [];
			var titleName:String;
			var titleInfo:String;
			var title:Title = ConfigurationManager.getIns().getObjectByID(AssetsConst.TITLE,data.id) as Title;
			if(title.id == NumberConst.getIns().title_10 && TitleManager.getIns().checkTitleGet(title.id)==false){
				titleName = "????";
				titleInfo = "????<br>" ;
			}else{
				titleName = ColorConst.setDarkGreen(title.name)+"<br>"+ ItemTypeConst.getTypeName(data.type);
				titleInfo = title.message + "<br>" ;
			}
			 
			for(var i:int =0;i<title.add_type.length;i++){
				var percentStr:String = ""; 
				if(title.add_type[i]=="crit" || title.add_type[i]=="evasion" || title.add_type[i]=="hit"|| 
					title.add_type[i]=="toughness" || title.add_type[i]=="hurt_deepen"|| title.add_type[i]=="hurt_reduce"){
					percentStr = "%";
				}
				titleInfo+="<font color='#00ff00'>"+NameHelper.getPropertyName(title.add_type[i])+
					" +"+Number(title.add_value[i])+percentStr+"</font><br>";
			}
			arr.push(titleName);
			arr.push(titleInfo);
			return arr;
		}
		
		
		
		protected function setVerticalPos():void{
			
			_title.height = _title.textHeight+5;
			_info.height = _info.textHeight+5;
			
			_title.y = TOP_GAP;
			_line.y = _title.y + _title.height + 5;
			if(_line.visible){
				_info.y = _line.y + 10;
			}else{
				_info.y = _title.y + 15;
			}


			_bg.width = Math.max(_title.x+_title.textWidth,_info.x+_info.textWidth)+10;
			_bg.height = Math.max(_title.y+_title.height,_info.y+_info.height)+INTERVAL;
			_line.width = _bg.width -20;

		}

		
		protected function createTextField(W:int=90, H:int=19, Col:Number=0Xffffff, Str:String='', Size:uint=12) : TipTextField
		{
			var mytext:TipTextField=new TipTextField(W,H,Str,"宋体",Size,Col);
			return mytext;
		}

		override public function destroy() : void{
			if(_bg != null){
				if(_bg.parent != null){
					_bg.parent.removeChild(_bg);
					_bg = null;
				}
			}
			if(_line != null){
				if(_line.parent != null){
					_line.parent.removeChild(_line);
					_line = null;
				}
			}
			if(_title != null){
				if(_title.parent != null){
					_title.parent.removeChild(_title);
					_title = null;
				}
			}
			if(_info != null){
				if(_info.parent != null){
					_info.parent.removeChild(_info);
					_info = null;
				}
			}
			super.destroy();
		}
		
		
	}
}