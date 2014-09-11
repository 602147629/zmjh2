package com.test.game.Modules.MainGame.Strengthen
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.NameHelper;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.EquipedManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ChargeItemIcon extends BaseSprite
	{
		private var _anti:Antiwear;
		private var _obj:Sprite;
		
		private var _data:Object;
		
		
		private var _materialId:int;

		public function get materialId():int
		{
			return _anti["materialId"];
		}
		public function set materialId(value:int):void
		{
			_anti["materialId"] = value;
		}

		private var _lv:int;

		public function get lv():int
		{
			return _anti["lv"];
		}
		public function set lv(value:int):void
		{
			_anti["lv"] = value;
		}

		private var _addValue:Number = 0;

		public function get addValue():Number
		{
			return _anti["addValue"];
		}
		public function set addValue(value:Number):void
		{
			_anti["addValue"] = value;
		}

		
		private var addType:String;
		private var nowValueStr:String;
		private var nextValueStr:String;
		private var tips:String; 
		
		private var material:ItemVo;
		
		private var materialIcon:ItemIcon;
		private var chargeEnable:Boolean;

		
		private var _chargeEffect:BaseSequenceActionBind;
		
		public function ChargeItemIcon()
		{
			
			_anti = new Antiwear(new binaryEncrypt());
			_obj = AssetsManager.getIns().getAssetObject("chargeItemIcon") as Sprite;
			this.addChild(_obj);
			
			materialIcon = new ItemIcon();
			materialIcon.menuable=false;
			materialIcon.x = 0;
			materialIcon.y = 4;
			itemIcon.addChild(materialIcon);
			
			chargeBtn.addEventListener(MouseEvent.CLICK,onCharge);	
		}
		
		protected function onCharge(event:MouseEvent):void
		{
			if(chargeEnable){
					(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
						"是否"+tips+"?\n"+ColorConst.setLightBlue(nowValueStr+" → "+nextValueStr),showEffect);

			}
		}		
		
		private function showEffect():void{
			chargeBtn.mouseEnabled = false;
			(ViewFactory.getIns().initView(StrengthenView) as StrengthenView).mouseChildren = false;
			_chargeEffect = AnimationEffect.createAnimation(10015,["attachEffect"],false,removeEffect)
			_chargeEffect.x = -18;
			_chargeEffect.y = -28;
			this.addChild(_chargeEffect);
			RenderEntityManager.getIns().removeEntity(_chargeEffect);
			AnimationManager.getIns().addEntity(_chargeEffect);
		}
		
		private function removeEffect(...args):void{
			if(_chargeEffect != null){
				AnimationManager.getIns().removeEntity(_chargeEffect);
				_chargeEffect.destroy();
				_chargeEffect = null;
			}
			sureCharge();
		}
		
		private function sureCharge():void
		{
			PlayerManager.getIns().reduceSoul(_data.charge.soul*int(lv+1));
			PackManager.getIns().reduceItem(materialId,int(lv+1));
			EquipedManager.getIns().chargeEquip(_data.equip,_data.index);
			setData(_data);
			(ViewFactory.getIns().initView(StrengthenView) as StrengthenView).mouseChildren = true;
			chargeBtn.mouseEnabled = true;
		}
		
		public function setData(data:Object):void{
			
			if (!data){
				emptyAll();
				return;
			}
			
			_data=data;
			
			materialId = 4510+int(data.index)+1;
			lv  = _data.equip.equipConfig.chargeLvArr[_data.index];
			var needNum:int = lv+1;
			
			addType = _data.charge.type[_data.index];
			addValue = _data.charge.value[_data.index];
			
			
			material = PackManager.getIns().creatItem(materialId);
			materialIcon.setData(material);
			materialIcon.hideNum();
			
			numTxt.text = 
				PackManager.getIns().searchItemNum(materialId) + "/" + needNum;
			rankTxt.text = NameHelper.getChargeName(_data.index)+lv+"级";
			
			var totalValue:Number = 0;
			var totalNextValue:Number = 0;
			
			var percentStr:String = ""; 
			if(addType=="crit" || addType=="evasion" || addType=="hit"|| addType=="toughness" || 
				addType=="hurt_deepen"|| addType=="hurt_reduce"){
				percentStr = "%";
			}

			var num:int = (addValue + addValue*lv)*lv*50;
			var Nextnum:int = (addValue + addValue*(lv+1))*(lv+1)*50;
			totalValue = num/100;
			totalNextValue  = Nextnum/100;
			
			nowValueStr = NameHelper.getPropertyName(addType) + "+" +totalValue + percentStr;
			nextValueStr = NameHelper.getPropertyName(addType) + "+" +totalNextValue + percentStr
			 
			addValueTxt.text = nowValueStr;
			checkCharge();
		}
		
		private function checkCharge():void{
			chargeEnable = true;
			GreyEffect.reset(chargeBtn);
			tips = "消耗"+int(lv+1)+"个"+material.name+"与"+int(_data.charge.soul*int(lv+1))+"战魂提升充能等级";
			TipsManager.getIns().addTips(chargeBtn,
				{title:tips+"\n"+ColorConst.setLightBlue(nowValueStr+" → "+nextValueStr), tips:""});
			if(PackManager.getIns().searchItemNum(materialId)<int(lv+1)){
				chargeEnable = false;
				GreyEffect.change(chargeBtn);
				TipsManager.getIns().addTips(chargeBtn,
					{title:material.name+"不足！\n需要"+int(lv+1)+"个"+material.name, tips:""});
			}
			
			if(PlayerManager.getIns().checkNumber("soul",_data.charge.soul*int(lv+1)) == false){
				chargeEnable = false;
				GreyEffect.change(chargeBtn);
				TipsManager.getIns().addTips(chargeBtn,
					{title:"战魂不足!\n需要"+int(_data.charge.soul*int(lv+1))+"战魂", tips:""});
			}
			
			if(lv==99){
				chargeEnable = false;
				GreyEffect.change(chargeBtn);
				TipsManager.getIns().addTips(chargeBtn,
					{title:"已达到当前最高等级", tips:""});
			}
		}
		
	
		
		private function emptyAll():void{
			materialIcon.setData(null);
			rankTxt.text = "";
			numTxt.text = "";
			addValueTxt.text = "";
			chargeEnable = false;
			GreyEffect.change(chargeBtn);
			TipsManager.getIns().removeTips(chargeBtn);
		}
		
		

		

		private function get chargeBtn():SimpleButton
		{
			return _obj["chargeBtn"];
		}
		
		private function get numTxt():TextField
		{
			return _obj["numTxt"];
		}
		
		private function get rankTxt():TextField
		{
			return _obj["rankTxt"];
		}
		
		private function get addValueTxt():TextField
		{
			return _obj["addValueTxt"];
		}
		
		private function get itemIcon():MovieClip
		{
			return _obj["itemIcon"];
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		
		override public function destroy():void{

			_data = null;
			removeComponent(_obj);
			if(materialIcon != null){
				materialIcon.destroy();
				materialIcon = null;
			}
			super.destroy();
		}
	}
}