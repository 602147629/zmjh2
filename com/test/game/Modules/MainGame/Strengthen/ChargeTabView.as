package com.test.game.Modules.MainGame.Strengthen
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Configuration.Charge;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ChargeTabView extends BaseSprite
	{

		private var _obj:Sprite;
		
		private var _data:ItemVo;
		
		private var selectedEquip:ItemIcon;
		
		private var itemIconArr:Vector.<ChargeItemIcon>;
		
		public var layerName:String;
		
		private var ChargeData:Charge;
		
		public function ChargeTabView()
		{
			_obj = AssetsManager.getIns().getAssetObject("chargeTabView") as Sprite;
			this.addChild(_obj);
			
			selectedEquip = new ItemIcon();
			selectedEquip.menuable=false;
			selectedEquip.x = 34;
			selectedEquip.y = 10;
			this.addChild(selectedEquip);
			
			itemIconArr = new Vector.<ChargeItemIcon>;
			for(var i:int = 0;i<4;i++){
				var icon:ChargeItemIcon = new ChargeItemIcon();
				icon.x = 13;
				icon.y = 60 + 77*i;
				this.addChild(icon);
				itemIconArr.push(icon);
			}
		}
		

		
		public function setItemData(data:ItemVo):void{
			
			if (!data){
				emptyAll();
				return;
			}
			
			_data=data;
			selectedEquip.setData(_data);

			nameTF.text = _data.equipConfig.name
			rank.text = _data.strengthen.strengthen_level;
			
			ChargeData = ConfigurationManager.getIns().getObjectByProperty(
				AssetsConst.CHARGE,"name",_data.equipConfig.type) as Charge;
			
			for(var i:int =0;i<itemIconArr.length;i++){
				var equipdata:Object = {
					equip:_data,
					index:i,
					charge:ChargeData
				};
				itemIconArr[i].setData(equipdata);
			}

		}
		
	
		
		private function emptyAll():void{
			selectedEquip.setData(null);
			nameTF.text = "";
			rank.text = "";
			for(var i:int =0;i<itemIconArr.length;i++){
				itemIconArr[i].setData(null);
			}

		}
		

		
		private function get nameTF():TextField
		{
			return _obj["nameTxt"];
		}
		
		private function get rank():TextField
		{
			return _obj["rankTxt"];
		}

		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		
		override public function destroy():void{

			_data = null;
			removeComponent(_obj);
			if(selectedEquip != null){
				this.removeChild(selectedEquip);
				selectedEquip.destroy();
				selectedEquip = null;
			}
			
			for(var i:int=0;i<itemIconArr.length;i++){
				if(itemIconArr[i]){
					this.removeChild(itemIconArr[i]);
					itemIconArr[i].destroy();
					itemIconArr[i] = null;
				}
			}
			super.destroy();
		}
	}
}