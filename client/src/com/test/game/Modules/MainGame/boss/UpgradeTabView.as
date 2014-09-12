package com.test.game.Modules.MainGame.boss
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.GuideConst;
	import com.test.game.Const.NameHelper;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.AssistManager;
	import com.test.game.Manager.AttachManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.TitleManager;
	import com.test.game.Modules.MainGame.Info.InfoView;
	import com.test.game.Mvc.Configuration.BossCardUp;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ChangePage;
	import com.test.game.UI.ItemIcon;
	import com.test.game.UI.NumItemIcon;
	import com.test.game.UI.Grid.AutoGrid;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class UpgradeTabView extends Sprite
	{
		private var _obj:Sprite;
		
		public var layerName:String;
		
		private var _data:ItemVo;
		
		private var _NextData:ItemVo;
		
		private var _materialCardData:ItemVo;

		private var _assistIcon:UpgradeBossIcon;
		
		private var _attachIconArr:Vector.<UpgradeBossIcon>;
		
		
		private var _bossGrid:AutoGrid
		
		private var _bossChangePage:ChangePage;
		
		private var _nextBossUp:BossCardUp;
		
		private var beforeImage:ItemIcon;
		private var afterImage:ItemIcon;
		
		
		private var bossIcon:NumItemIcon;
		
		
		private var _upgradeEnable:Boolean;
		
		
		private var _materialIconArr:Vector.<NumItemIcon>;
		private var _player:PlayerVo;
		private var _bossImage:BaseNativeEntity;
		private var _upgradeEffect:BaseSequenceActionBind;
		
		private var selectData:ItemVo;

		
		public function UpgradeTabView()
		{
			
			_obj = AssetsManager.getIns().getAssetObject("upgradeTabView") as Sprite;
			this.addChild(_obj);
			
			renderView();
			update();
			initEvent();
			
			
		}

		public function update():void{
			_player = PlayerManager.getIns().player;
			PackManager.getIns().sortCidByItemId(_player.pack.bossUnEquip);
			renderBosses();
			selectFirstBoss();
/*			if(PackManager.getIns().pack.boss.length>0){
				setCurBossData(PackManager.getIns().pack.boss[0]);
			}*/
		}
		
		private function initEvent():void{
			EventManager.getIns().addEventListener(EventConst.UPGRADE_BOSS_SELECT_CHANGE,onBossSelect);
			upgradeBtn.addEventListener(MouseEvent.CLICK,onUpgrade);
		}
		
		private function onUpgrade(e:MouseEvent):void
		{
			if(_upgradeEnable){
				_upgradeEnable = false;
				this.mouseChildren = false;
				_upgradeEffect = AnimationEffect.createAnimation(10014,["upgradeEffect"],false,upgrade)
				_upgradeEffect.x = 52;
				_upgradeEffect.y = 12;
				this.addChild(_upgradeEffect);
				RenderEntityManager.getIns().removeEntity(_upgradeEffect);
				AnimationManager.getIns().addEntity(_upgradeEffect);
			}
		}
		
		private function upgrade(...args):void{
			(ViewFactory.getIns().initView(InfoView) as InfoView).setType(5, null, null);
			AnimationManager.getIns().removeEntity(_upgradeEffect);
			AnimationManager.getIns().removeEntity(_upgradeEffect);
			_upgradeEffect.destroy();
			_upgradeEffect = null;
			PackManager.getIns().upgradeBossCard(_data);
			renderBosses();
			setCurBossData(_data);
			TitleManager.getIns().checkGoldBossTitle();
			GuideManager.getIns().bossGuideSetting(GuideConst.BOSSUPGRADE);
			DeformTipManager.getIns().checkBossDeform();
			this.mouseChildren = true;
		}
		
		private function onBossSelect(e:CommonEvent):void{
			setCurBossData(e.data[0] as ItemVo);
			_bossGrid.clearItemArrSelected();
			for(var i:int=0;i<3;i++){
				_attachIconArr[i].hideSelected();
			}
			_assistIcon.hideSelected();
			e.data[1].showSelected();
			selectData = e.data[0];
			GuideManager.getIns().bossTabJudge();
		}
		
		
		//初始默认选择
		private function selectFirstBoss():void{
			_bossGrid.clearItemArrSelected();
			for(var i:int=0;i<3;i++){
				_attachIconArr[i].hideSelected();
			}
			_assistIcon.hideSelected();
			if(_player.pack.bossUnEquip.length == 0){
				setCurBossData(null);
				selectData = null;
			}else{
				setCurBossData(PackManager.getIns().sortByCId(_player.pack.bossUnEquip)[0]);
				_bossGrid.showItemArrSelected(0);
				selectData = _bossGrid.first as ItemVo;
			}
		}
		
		private function rankTraslate(data:BossCardUp):String{
			var name:String;
			switch(data.star){
				case 1:
					name = data.color+"色一星"
					break;
				case 2:
					name = data.color+"色二星"
					break;
				case 3:
					name = data.color+"色三星"
					break;
				
			}
			return name;
		}
		
		
		
		private function renderBosses():void{
			
			if(!_bossChangePage){
				_bossChangePage = new ChangePage();
				_bossChangePage.x = 632;
				_bossChangePage.y = 360;
				this.addChild(_bossChangePage);	
			}
			
			var attachs:Vector.<ItemVo> = AttachManager.getIns().AttachVos;
			if(!_attachIconArr){
				_attachIconArr = new Vector.<UpgradeBossIcon>;
				for (var i:int = 0 ; i<3;i++){
					var itemIcon:UpgradeBossIcon = new UpgradeBossIcon();
					itemIcon.x = 542+i*53;
					itemIcon.y = 22;
					this.addChild(itemIcon);
					_attachIconArr.push(itemIcon);
				}
			}
			
			for (var j:int = 0 ; j<3;j++){
				_attachIconArr[j].setData(attachs[j]);
				_attachIconArr[j].index = -1;
			}
			
			var curAssist:ItemVo = AssistManager.getIns().AssistVo;
			if(!_assistIcon){
				_assistIcon = new UpgradeBossIcon();
				_assistIcon.x = 742;
				_assistIcon.y = 22;
				this.addChild(_assistIcon);
				_assistIcon.index = -1;
			}
			_assistIcon.setData(curAssist);

			
			if (!_bossGrid)
			{
				_bossGrid = new AutoGrid(UpgradeBossIcon,5, 6, 50, 50, 1, 1);
				_bossGrid.x = 514;
				_bossGrid.y = 89;
				this.addChild(_bossGrid);
			}
			_bossGrid.setData(PackManager.getIns().sortByMId(_player.pack.bossUnEquip)
				,_bossChangePage);
			_bossGrid.showIconSelected(selectData);
			
		}
		
		
		private function renderView():void{
			beforeImage  = new ItemIcon();
			beforeImage.x = 263;
			beforeImage.y = 51;
			beforeImage.selectable = false;
			beforeImage.menuable = false;
			this.addChild(beforeImage);
			
			afterImage  = new ItemIcon();
			afterImage.x = 373;
			afterImage.y = 51;
			afterImage.selectable = false;
			afterImage.menuable = false;
			this.addChild(afterImage);
			
			//BOSS图标
			if(!_bossImage){
				_bossImage  = new BaseNativeEntity();
				_bossImage.x= 80;
				_bossImage.y =47;
				this.addChild(_bossImage);
			}
			
			
			_materialIconArr = new Vector.<NumItemIcon>;
			for(var i:int = 0;i<4;i++){
				var numItemIcon:NumItemIcon = new NumItemIcon();
				numItemIcon.x = 94+60*i;
				numItemIcon.y = 293;
				this.addChild(numItemIcon);
				_materialIconArr.push(numItemIcon);
			}
			
			bossIcon  = new NumItemIcon();
			bossIcon.x = 334;
			bossIcon.y = 292;
			this.addChild(bossIcon);
			
			
		}
		
		
		private function setCurBossData(data:ItemVo):void{
			if(!data){
				setAllEmpty();
				return;
			}
			
			_data = data;
			
			if(_data.lv+1 >= 19){
				setAllEmpty();
				return;
			}
			_nextBossUp = ConfigurationManager.getIns().getObjectByID(AssetsConst.BOSS_UP,_data.lv+1) as BossCardUp;
			_NextData = data.copy();
			_NextData.bossUp = _nextBossUp;
			_NextData.lv+=1;
			

			
			
			
			bossName.text = _data.bossConfig.name;
			rank.gotoAndStop(_data.bossUp.color);
			stars.gotoAndStop(_data.bossUp.star);
			
			var _url:String = _data.type+(_data.id - 10000 + 1000).toString();
			_bossImage.data.bitmapData = AUtils.getNewObj(_url) as BitmapData;

			renderProperty();
			renderCost();
			checkButton();
		}
		
		
		private function setAllEmpty():void{
			bossName.text = "";
			_bossImage.data.bitmapData = null;
			
			
			beforeImage.setData(null);
			afterImage.setData(null);
			
			beforeRank.text = "";
			afterRank.text = "";
			beforeAtk.text = "";
			beforeAts.text = "";
			afterAtk.text = "";
			afterAts.text = "";
			propertyName.text = "";
			beforePropertyAdd.text = "";
			afterPropertyAdd.text =  "";
			
			moneyCost.text = "";
			soulCost.text = "";
			curMoney.text = "";
			curSoul.text = "";
			
			for(var i:int = 0;i<4;i++){
				_materialIconArr[i].setData(null,0);
			}
			bossIcon.setData(null,NumberConst.getIns().one);
			
			upgradeBtnEnable(false);

		}
		
		
		private function renderProperty():void{
			
			
			beforeImage.setData(_data);
			afterImage.setData(_NextData);

			beforeRank.text = rankTraslate(_data.bossUp);
			afterRank.text = rankTraslate(_nextBossUp);
			beforeAtk.text = int(_data.bossConfig.atk*_data.bossUp.atk_rate).toString();
			beforeAts.text = int(_data.bossConfig.ats*_data.bossUp.ats_rate).toString();
			afterAtk.text = int(_data.bossConfig.atk*_nextBossUp.atk_rate).toString();
			afterAts.text = int(_data.bossConfig.ats*_nextBossUp.ats_rate).toString();
			propertyName.text = NameHelper.getPropertyName(_data.bossConfig.add_type[0]);
			beforePropertyAdd.text = int(int(_data.bossConfig.add_value[0])*_data.bossUp.add_rate).toString();
			afterPropertyAdd.text =  int(int(_data.bossConfig.add_value[0])*_nextBossUp.add_rate).toString();

			if(_data.bossConfig.add_type.length>1){
				propertyArrow2.visible = true;
				propertyName2.text = NameHelper.getPropertyName(_data.bossConfig.add_type[1]);
				beforePropertyAdd2.text = int(int(_data.bossConfig.add_value[1])*_data.bossUp.add_rate).toString();
				afterPropertyAdd2.text =  int(int(_data.bossConfig.add_value[1])*_nextBossUp.add_rate).toString();

			}else{
				propertyArrow2.visible = false;
				propertyName2.text = "";
				beforePropertyAdd2.text = "";
				afterPropertyAdd2.text =  "";

			}

		}
		
		
		private function renderCost():void{
			moneyCost.text = _data.bossUp.up_money.toString();
			soulCost.text = _data.bossUp.up_soul.toString();
			curMoney.text = NumberConst.numTranslate(_player.money);
			curMoney.textColor = ColorConst.green;
			curSoul.text = NumberConst.numTranslate(_player.soul);
			curSoul.textColor = ColorConst.green;
			
			var materials:Array = _data.bossUp.up_material.split("|");
			var materialNumList:Array = _data.bossUp.up_number.split("|");
			
			for(var i:int = 0;i<4;i++){
				if(i+1>materials.length){
					_materialIconArr[i].setData(null,0);
				}else{
					var itemVo:ItemVo = new ItemVo();
					itemVo = PackManager.getIns().creatItem(materials[i])
					_materialIconArr[i].setData(itemVo,materialNumList[i]);
				}
			}
			
			
			if(_data.bossUp.up_card!=0){
				_materialCardData = _data.copy();
				bossIcon.setData(_materialCardData,NumberConst.getIns().one);
			}else{
				bossIcon.setData(null,NumberConst.getIns().one);
			}
		}
		
		private function checkMaterial():Boolean{
			var result:Boolean;
			
			var materials:Array = _data.bossUp.up_material.split("|");
			var materialNumList:Array = _data.bossUp.up_number.split("|");
			
			for(var i:int = 0;i<materials.length;i++){
				if(PackManager.getIns().searchItemNum(materials[i])>=materialNumList[i]){
					result = true;
				}else{
					result = false;
					break
				}
			}
			return result;
		}
		
		private function checkCard():Boolean
		{
			var result:Boolean;
			if(_data.bossUp.up_card!=0){
				if(PackManager.getIns().searchMaterialBossCard(_data.id,_data.lv)){
					result = true;
				}else{
					result = false;
				}
			}else{
				result = true;
			}
			return result;
		}	
		
		
		//按钮灰化判定
		private function checkButton():void
		{
			var result:Boolean = true;
			
			if(!checkCard()){
				upgradeBtnEnable(false);
				TipsManager.getIns().addTips(upgradeBtn,{title:"卡牌不足",tips:""});
				result = false;
			}
			
			if(!checkMaterial()){
				upgradeBtnEnable(false);
				TipsManager.getIns().addTips(upgradeBtn,{title:"材料不足",tips:""});
				result = false;
			}
			
			if(!PlayerManager.getIns().checkNumber("money",_data.bossUp.up_money)){
				upgradeBtnEnable(false);
				curMoney.textColor = ColorConst.red;
				TipsManager.getIns().addTips(upgradeBtn,{title:"金钱不足",tips:""});
				result = false;
			}
			
			if(!PlayerManager.getIns().checkNumber("soul",_data.bossUp.up_soul)){
				upgradeBtnEnable(false);
				curSoul.textColor = ColorConst.red;
				TipsManager.getIns().addTips(upgradeBtn,{title:"战魂不足",tips:""});
				result = false;
			}
			
			if(_data.lv >= NumberConst.getIns().bossMaxLv && ShopManager.getIns().vipLv<5){
				upgradeBtnEnable(false);
				TipsManager.getIns().addTips(upgradeBtn,{title:"达到VIP5开启合成金卡",tips:""});
				result = false;
			}

			
			if(result ){
				upgradeBtnEnable(true);
				TipsManager.getIns().removeTips(upgradeBtn);
			}
		}	
		
	
		
		private function upgradeBtnEnable(enable:Boolean):void{
			if(enable){
				GreyEffect.reset(upgradeBtn);
				upgradeBtnMc.visible = true;
			}else{
				GreyEffect.change(upgradeBtn);
				upgradeBtnMc.visible = false;
			}
			_upgradeEnable = enable;
		}
		
		private function get bossName():TextField
		{
			return _obj["bossName"];
		}
		
		private function get rank():MovieClip
		{
			return _obj["rank"];
		}
		
		private function get stars():MovieClip
		{
			return _obj["stars"];
		}
		
		private function get beforeRank():TextField
		{
			return _obj["beforeRank"];
		}
		
		private function get afterRank():TextField
		{
			return _obj["afterRank"];
		}
		
		private function get beforeAtk():TextField
		{
			return _obj["beforeAtk"];
		}
		
		private function get afterAtk():TextField
		{
			return _obj["afterAtk"];
		}
		
		private function get beforeAts():TextField
		{
			return _obj["beforeAts"];
		}
		
		private function get afterAts():TextField
		{
			return _obj["afterAts"];
		}
		
		private function get propertyName():TextField
		{
			return _obj["propertyName"];
		}
		
		private function get beforePropertyAdd():TextField
		{
			return _obj["beforePropertyAdd"];
		}
		
		private function get afterPropertyAdd():TextField
		{
			return _obj["afterPropertyAdd"];
		}
		
		private function get propertyArrow2():MovieClip
		{
			return _obj["propertyArrow2"];
		}
		
		private function get propertyName2():TextField
		{
			return _obj["propertyName2"];
		}
		
		private function get beforePropertyAdd2():TextField
		{
			return _obj["beforePropertyAdd2"];
		}
		
		private function get afterPropertyAdd2():TextField
		{
			return _obj["afterPropertyAdd2"];
		}
		
		private function get moneyCost():TextField
		{
			return _obj["moneyCost"];
		}
		
		private function get soulCost():TextField
		{
			return _obj["soulCost"];
		}
		
		private function get curMoney():TextField
		{
			return _obj["curMoney"];
		}
		
		private function get curSoul():TextField
		{
			return _obj["curSoul"];
		}
		
		private function get upgradeBtn():SimpleButton
		{
			return _obj["upgradeBtn"];
		}
		
		private function get upgradeBtnMc():MovieClip
		{
			return _obj["upgradeLightMc"];
		}
		
		
		
		public function destroy() : void{
			EventManager.getIns().removeEventListener(EventConst.UPGRADE_BOSS_SELECT_CHANGE,onBossSelect);
			upgradeBtn.removeEventListener(MouseEvent.CLICK,onUpgrade);
			if(this.parent != null){
				this.parent.removeChild(this);
			}
			_data = null;
			_NextData = null;
			_materialCardData = null;
			_nextBossUp = null;
			_player = null;
			if(_bossGrid != null){
				_bossGrid.destroy();
				_bossGrid = null;
			}
			if(_bossChangePage != null){
				_bossChangePage.destroy();
				_bossChangePage = null;
			}
			if(beforeImage != null){
				beforeImage.destroy();
				beforeImage = null;
			}
			if(afterImage != null){
				afterImage.destroy();
				afterImage = null;
			}
			if(bossIcon != null){
				bossIcon.destroy();
				bossIcon = null;
			}
			if(_materialIconArr != null){
				for(var i:int = 0; i < _materialIconArr.length; i++){
					_materialIconArr[i].destroy();
					_materialIconArr[i] = null;
				}
				_materialIconArr.length = 0;
				_materialIconArr = null;
			}
			if(_bossImage != null){
				_bossImage.destroy();
				_bossImage = null;
			}
			if(_upgradeEffect != null){
				_upgradeEffect.destroy();
				_upgradeEffect = null;
			}
			
			if(_obj != null){
				if(_obj.parent != null){
					_obj.parent.removeChild(_obj);
				}
				_obj = null;
			}
		}

		
	}
}