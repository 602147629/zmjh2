 package com.test.game.Modules.MainGame.Strengthen
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.EquipedManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.Info.InfoView;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Mvc.Configuration.Strengthen;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class StrengthenTabView extends BaseSprite
	{
		private var _obj:Sprite;
		
		private var _data:ItemVo;
		
		private var _strengthenEnable:Boolean;
		
		private var _player:PlayerVo;
		
		private var _nextStrengthenData:Strengthen;
		
		private var selectedEquip:ItemIcon;
		private var materialIcon:ItemIcon;
		
		private var _strengthenEffect:BaseSequenceActionBind;
		
		public var layerName:String;
		
		private var _strengthenBtnMc:MovieClip;
		
		
		public function StrengthenTabView()
		{
			_obj = AssetsManager.getIns().getAssetObject("strengthenTabView") as Sprite;
			this.addChild(_obj);

			selectedEquip = new ItemIcon();
			selectedEquip.menuable = false;
			selectedEquip.x = 69;
			selectedEquip.y = 38;
			this.addChild(selectedEquip);
			
			materialIcon = new ItemIcon();
			materialIcon.num = false;
			materialIcon.menuable = false;
			materialIcon.x = 18;
			materialIcon.y = 264;
			this.addChild(materialIcon);
			
			strengthenBtn.addEventListener(MouseEvent.CLICK,onStrengthen);
			
		}
		
		
		//强化响应
		private function onStrengthen(e:MouseEvent):void
		{
			if(_strengthenEnable){
				(ViewFactory.getIns().initView(StrengthenView) as StrengthenView).mouseChildren = false;
				_strengthenEnable = false;
				_strengthenEffect = AnimationEffect.createAnimation(10009,["strengthenEffect"],false,strengthen)
				_strengthenEffect.x = 42;
				_strengthenEffect.y = 12;
				this.addChild(_strengthenEffect);
				RenderEntityManager.getIns().removeEntity(_strengthenEffect);
				AnimationManager.getIns().addEntity(_strengthenEffect);

			}
		}
		
		private function strengthen(...args):void
		{
			AnimationManager.getIns().removeEntity(_strengthenEffect);
			_strengthenEffect.destroy();
			_strengthenEffect = null;
			(ViewFactory.getIns().initView(InfoView) as InfoView).setType(7, null, 
				function () : void{
					GuideManager.getIns().strengthenGuideSetting();
					EquipedManager.getIns().strengtnenEquip(_data);
					DeformTipManager.getIns().checkStrengthenDeform();
					setItemData(_data);	
					(ViewFactory.getIns().initView(StrengthenView) as StrengthenView).mouseChildren = true;
					(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).update()
				}
			);
		}
		
		public function setItemData(data:ItemVo):void{
			
			if (!data){
				emptyAll();
				return;
			}
			
			_data=data;
			
			_player = PlayerManager.getIns().player;

			_nextStrengthenData=ConfigurationManager.getIns().getObjectByID(AssetsConst.STRENGTHEN,_data.lv+1) as Strengthen
			
			selectedEquip.setData(_data);
			
			itemName.text = _data.name;
			itemRank.text = _data.strengthen.strengthen_level;
			
			renderProperty();
			renderCost();
			checkButton();
		}
		
		
		private function emptyAll():void{
			selectedEquip.setData(null);
			materialIcon.setData(null);
			itemName.text = "";
			itemRank.text = "";
			beforeStrengthenTxt.text = "";
			afterStrengthenTxt.text = "";
			moneyCost.text = "";
			materialCost.text = "";
			curNum.text = "";
			strengthenBtnEnable(false)
		}
	
	
		
		//属性数据显示
		private function renderProperty():void{
			var name:String = EquipedManager.getIns().getPropertyName(_data)[0];
			
			beforeStrengthenTxt.text = (_data.equipConfig[name]+_data.lv*_player.strengthenUp[name]).toString();
			
			afterStrengthenTxt.text = (_data.equipConfig[name]+(_data.lv+1)*_player.strengthenUp[name]).toString();

			propertyName.gotoAndStop(name);
		
		}
		
		//消耗数据显示
		private function renderCost():void
		{
			moneyCost.text = _nextStrengthenData.money_add.toString();
			
			var stoneData:ItemVo = PackManager.getIns().creatItem(_nextStrengthenData.stoneId);
			
			var _url:String = ItemTypeConst.MATERIAL+_nextStrengthenData.stoneId.toString();
			
			materialIcon.setData(stoneData);
			
			materialCost.text = stoneData.name + "x" + _nextStrengthenData.stoneNum.toString();
			
			curNum.text = PackManager.getIns().searchItemNum(_nextStrengthenData.stoneId).toString();
			
		}	
		
		//按钮灰化判定
		private function checkButton():void
		{
			var result:Boolean = true;
			
			moneyCost.textColor = ColorConst.green;
			curNum.textColor = ColorConst.green;
			
			if(_data.lv+1>PlayerManager.getIns().player.character.lv){
				strengthenBtnEnable(false);
				TipsManager.getIns().addTips(strengthenBtn,{title:"需要等级提升至"+int(_data.lv+1)+"级",tips:""});
				result = false;
			}
			
			if(PackManager.getIns().searchItemNum(_nextStrengthenData.stoneId)<_nextStrengthenData.stoneNum){
				strengthenBtnEnable(false);
				TipsManager.getIns().addTips(strengthenBtn,{title:"强化石不足",tips:""});
				curNum.textColor = ColorConst.red;
				result = false;
			}
			
			if(!PlayerManager.getIns().checkNumber("money",_nextStrengthenData.money_add)){
				strengthenBtnEnable(false);
				TipsManager.getIns().addTips(strengthenBtn,{title:"金钱不足",tips:""});
				moneyCost.textColor = ColorConst.red;
				result = false;
			}
			
			if(result){
				strengthenBtnEnable(true);
				TipsManager.getIns().removeTips(strengthenBtn);
			}
		}	
		
		
		

		private function strengthenBtnEnable(enable:Boolean):void{
			if(enable){
				GreyEffect.reset(strengthenBtn);
				strengthenBtnMc.visible = true;
			}else{
				GreyEffect.change(strengthenBtn);
				strengthenBtnMc.visible = false;
			}
			_strengthenEnable = enable;
		}

		
		
		private function get itemName():TextField
		{
			return _obj["itemName"];
		}
		
		private function get itemRank():TextField
		{
			return _obj["itemRank"];
		}
		
		private function get propertyName():MovieClip
		{
			return _obj["propertyName"];
		}
		
		private function get beforeStrengthenTxt():TextField
		{
			return _obj["beforeStrengthenTxt"];
		}
		
		private function get afterStrengthenTxt():TextField
		{
			return _obj["afterStrengthenTxt"];
		}
		
		private function get moneyCost():TextField
		{
			return _obj["moneyCost"];
		}
		
		private function get materialCost():TextField
		{
			return _obj["materialCost"];
		}
		
		private function get curNum():TextField
		{
			return _obj["curNum"];
		}
		
		private function get strengthenBtn():SimpleButton
		{
			return _obj["strengthenBtn"];
		}
		
		private function get strengthenBtnMc():MovieClip
		{
			return _obj["strengthenLightMc"];
		}
		
		override public function destroy():void{
			if(strengthenBtn != null){
				strengthenBtn.removeEventListener(MouseEvent.CLICK,onStrengthen);
			}
			_data = null;
			_player = null;
			_nextStrengthenData = null;
			removeComponent(_obj);
			if(selectedEquip != null){
				selectedEquip.destroy();
				selectedEquip = null;
			}
			if(materialIcon != null){
				materialIcon.destroy();
				materialIcon = null;
			}
			if(_strengthenEffect != null){
				_strengthenEffect.destroy();
				_strengthenEffect = null;
			}
			super.destroy();
		}
		
	}
}