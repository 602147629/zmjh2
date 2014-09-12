package com.test.game.Modules.MainGame.Strengthen
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.PublicNoticeType;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.EquipedManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.PublicNoticeManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.Info.InfoView;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ItemIcon;
	import com.test.game.UI.NumItemIcon;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ForgeTabView extends BaseSprite
	{

		private var _obj:Sprite;
		
		private var _data:ItemVo;
		

		private var _nextItem:ItemVo;
		
		private var material1:ItemVo;
		
		private var material2:ItemVo;
		
		private var book:ItemVo;
		
		private var selectedEquip:ItemIcon;
		
		private var nextEquip:ItemIcon;
		
		private var materialIcon1:NumItemIcon;
		
		private var materialIcon2:NumItemIcon;
		
		public var layerName:String;
		
		private var _forgeEnable:Boolean;
		private var _forgeEffect1:BaseSequenceActionBind;
		private var _forgeEffect2:BaseSequenceActionBind;
		
		public function ForgeTabView()
		{
			_obj = AssetsManager.getIns().getAssetObject("forgeTabView") as Sprite;
			this.addChild(_obj);
			
			selectedEquip = new ItemIcon();
			selectedEquip.menuable=false;
			selectedEquip.x = 34;
			selectedEquip.y = 19;
			this.addChild(selectedEquip);
			
			nextEquip = new ItemIcon();
			nextEquip.menuable=false;
			nextEquip.x = 34;
			nextEquip.y = 121;
			this.addChild(nextEquip);
			
			materialIcon1 = new NumItemIcon();
			materialIcon1.x = 33;
			materialIcon1.y = 266;
			this.addChild(materialIcon1);
			
			materialIcon2 = new NumItemIcon();
			materialIcon2.x = 91;
			materialIcon2.y = 266;
			this.addChild(materialIcon2);
			
			forgeBtn.addEventListener(MouseEvent.CLICK,onForge);
		}
		
		
		private function onForge(e:MouseEvent):void
		{
			if(_forgeEnable){
				(ViewFactory.getIns().initView(StrengthenView) as StrengthenView).mouseChildren = false;
				_forgeEnable = false;
				_forgeEffect1 = AnimationEffect.createAnimation(10010,["forgeEffect1"],false,addEffect2)
				_forgeEffect1.x = 12;
				_forgeEffect1.y = 10;
				this.addChild(_forgeEffect1);
				RenderEntityManager.getIns().removeEntity(_forgeEffect1);
				AnimationManager.getIns().addEntity(_forgeEffect1);
			}
		}
		
		private function addEffect2(...args):void{
			(ViewFactory.getIns().initView(InfoView) as InfoView).setType(6, null, null);
			AnimationManager.getIns().removeEntity(_forgeEffect1);
			_forgeEffect1.destroy();
			_forgeEffect1 = null;
			
			_forgeEffect2 = AnimationEffect.createAnimation(10011,["forgeEffect2"],false,disposeEffect2)
			_forgeEffect2.x = 0;
			_forgeEffect2.y = 84;
			this.addChild(_forgeEffect2);
			RenderEntityManager.getIns().removeEntity(_forgeEffect2);
			AnimationManager.getIns().addEntity(_forgeEffect2);
		}
		
		private function disposeEffect2(...args):void{
			AnimationManager.getIns().removeEntity(_forgeEffect2);
			_forgeEffect2.destroy();
			_forgeEffect2 = null;
			forge();
		}
		
		private function forge():void
		{
			EquipedManager.getIns().forgeEquip(_data);
			DeformTipManager.getIns().checkStrengthenDeform();
			SaveManager.getIns().onSaveGame();
			setItemData(_data);	
			(ViewFactory.getIns().initView(StrengthenView) as StrengthenView).mouseChildren = true;
			GuideManager.getIns().strengthenGuideSetting();
			checkForgePublicNotice();
		}
		
		private function checkForgePublicNotice():void{
			var num:int;
			for each(var equip:ItemVo in player.pack.equip){
				var dataIdx:int = int(_data.id.toString().slice(2,4));
				var equipIdx:int = int(equip.id.toString().slice(2,4));
				if(equipIdx >= dataIdx){
					num++;
				}
			}
			if(num==6){
				PublicNoticeManager.getIns().sendPublicNotice(PublicNoticeType.EQUIP_SET,_data.name.slice(0,2));
			}
		}
		
		public function setItemData(data:ItemVo):void{
			
			if (!data){
				emptyAll();
				return;
			}
			
			
			//当前最大打造等级
			if(data.id.toString().charAt(3)=="5"){
				emptyAll();
				selectedEquip.setData(data);
				beforeItemName.text = data.equipConfig.name
				beforeItemRank.text = data.strengthen.strengthen_level;
				return;
			}
			
			_data=data;
			
			_nextItem = PackManager.getIns().creatItem(_data.equipConfig.need_equipment);
			_nextItem.lv = _data.lv;
			_nextItem.strengthen = _data.strengthen;
			
			selectedEquip.setData(_data);
			
			nextEquip.setData(_nextItem);
			
			beforeItemName.text = _data.equipConfig.name
			beforeItemRank.text = _data.strengthen.strengthen_level;
			afterItemName.text = _nextItem.equipConfig.name;
			afterItemRank.text = _data.strengthen.strengthen_level;
			
			renderCost();
			checkButton();
		}
		
		
		private function checkCurMaxId(data:ItemVo):void{
			
		}
		
		private function emptyAll():void{
			selectedEquip.setData(null);
			nextEquip.setData(null);
			beforeItemName.text = "";
			beforeItemRank.text = "";
			afterItemName.text = "";
			afterItemRank.text = "";
			soulCost.text = "";
			bookCost.text = "";
			materialIcon1.setData(null,0);
			materialIcon2.setData(null,0);
			forgeBtnEnable(false);
		}
		
		
		//消耗显示
		private function renderCost():void{
			var materials:Array = _data.equipConfig.need_material.split("|");
			var materialNumList:Array = _data.equipConfig.material_number.split("|");
			
			material1 = PackManager.getIns().creatItem(materials[0]);
			material2 = PackManager.getIns().creatItem(materials[1]);
			
			materialIcon1.setData(material1,materialNumList[0]);
			materialIcon2.setData(material2,materialNumList[1]);

			soulCost.text = _data.equipConfig.need_soul.toString();
			
			bookCost.text = ConfigurationManager.getIns().getObjectByID(
				AssetsConst.BOOK,_data.equipConfig.need_book)["name"];
			TipsManager.getIns().addTips(bookCost,PackManager.getIns().creatItem(_data.equipConfig.need_book));	
		}
		
		
		//按钮灰化判定
		private function checkButton():void
		{
			var result:Boolean = true;
			soulCost.textColor = ColorConst.green;
			bookCost.textColor = ColorConst.green;
			
			var materials:Array = _data.equipConfig.need_material.split("|");
			var materialNumList:Array = _data.equipConfig.material_number.split("|");
			
			if(PackManager.getIns().searchItemNum(_data.equipConfig.need_book)==0){
				forgeBtnEnable(false);
				TipsManager.getIns().addTips(forgeBtn,{title:"缺少装备打造书",tips:""});
				bookCost.textColor = ColorConst.red;
				
				result = false;
			}
			
			if(PackManager.getIns().searchItemNum(materials[0])<materialNumList[0]){
				forgeBtnEnable(false);
				TipsManager.getIns().addTips(forgeBtn,{title:"材料不足",tips:""});
				result = false;
			}
			
			if(PackManager.getIns().searchItemNum(materials[1])<materialNumList[1]){
				forgeBtnEnable(false);
				TipsManager.getIns().addTips(forgeBtn,{title:"材料不足",tips:""});
				result = false;
			}
			
			if(!PlayerManager.getIns().checkNumber("soul",_data.equipConfig.need_soul)){
				forgeBtnEnable(false);
				TipsManager.getIns().addTips(forgeBtn,{title:"战魂不足",tips:""});
				soulCost.textColor = ColorConst.red;
				result = false;
			}
			
			if(result){
				forgeBtnEnable(true);
				TipsManager.getIns().removeTips(forgeBtn);
			}
			
			
		}	
		
		
		private function forgeBtnEnable(enable:Boolean):void{
			if(enable){
				GreyEffect.reset(forgeBtn);
				forgeBtnMc.visible = true;
			}else{
				GreyEffect.change(forgeBtn);
				forgeBtnMc.visible = false;
			}
			_forgeEnable = enable;
		}

		
		private function get beforeItemName():TextField
		{
			return _obj["beforeItemName"];
		}
		
		private function get beforeItemRank():TextField
		{
			return _obj["beforeItemRank"];
		}
		
		private function get afterItemName():TextField
		{
			return _obj["afterItemName"];
		}
		
		private function get afterItemRank():TextField
		{
			return _obj["afterItemRank"];
		}
		
		private function get soulCost():TextField
		{
			return _obj["soulCost"];
		}
		
		private function get bookCost():TextField
		{
			return _obj["bookCost"];
		}
		
		private function get forgeBtn():SimpleButton
		{
			return _obj["forgeBtn"];
		}
		
		private function get forgeBtnMc():MovieClip
		{
			return _obj["forgeLightMc"];
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		
		override public function destroy():void{
			if(forgeBtn != null){
				forgeBtn.removeEventListener(MouseEvent.CLICK,onForge);
			}
			_data = null;
			_nextItem = null;
			material1 = null;
			material2 = null;
			book = null;
			removeComponent(_obj);
			if(selectedEquip != null){
				selectedEquip.destroy();
				selectedEquip = null;
			}
			if(nextEquip != null){
				nextEquip.destroy();
				nextEquip = null;
			}
			if(materialIcon1 != null){
				materialIcon1.destroy();
				materialIcon1 = null;
			}
			if(materialIcon2 != null){
				materialIcon2.destroy();
				materialIcon2 = null;
			}
			if(_forgeEffect1 != null){
				_forgeEffect1.destroy();
				_forgeEffect1 = null;
			}
			if(_forgeEffect2 != null){
				_forgeEffect2.destroy();
				_forgeEffect2 = null;
			}
			super.destroy();
		}
	}
}