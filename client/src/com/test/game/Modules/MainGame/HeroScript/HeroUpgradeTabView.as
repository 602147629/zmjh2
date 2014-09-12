package com.test.game.Modules.MainGame.HeroScript
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NameHelper;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.Layer.AnimationLayerManager;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.BmdView.OtherEntityView;
	import com.test.game.Mvc.Vo.BasePropertyVo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ChangePage;
	import com.test.game.UI.Grid.AutoGrid;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class HeroUpgradeTabView extends BaseSprite
	{
		public var layerName:String;
		private var _obj:Sprite;
		
		private var _bossGrid:AutoGrid;
		
		private var _bossChangePage:ChangePage;
		
		private var _iconArr:Array;
		
		private var _selectedBossVec:Vector.<ItemVo>;
		
		private var _addProperty:BasePropertyVo;
		
		private var _afterLvArr:Array;
		
		private var _effect:BaseSequenceActionBind;
		
		private var _anti:Antiwear;
		
		private function get costSoul():int
		{
			return _anti["curSoul"];
		}
		
		private function set costSoul(value:int):void
		{
			_anti["curSoul"] = value;
		}
		
		public function HeroUpgradeTabView()
		{
			_anti = new Antiwear(new binaryEncrypt());
			_obj = AssetsManager.getIns().getAssetObject("HeroUpgradeTabView") as Sprite;
			_obj.x = 186;
			_obj.y = 120;
			this.addChild(_obj);
			update();
			initEvent();
		}		
		public function update():void{
			renderPlayerAssets();
			//heroMc.gotoAndStop(player.occupation==1?player.occupation+1:player.occupation-1);
			GreyEffect.change(upgradeBtn);
			upgradeBtn.mouseEnabled = false;
			_afterLvArr = new Array();
			_selectedBossVec = new Vector.<ItemVo>;
			renderBoss();
			renderProperties();
			costTxt.text = NumberConst.getIns().zero.toString();
			curTxt.text = player.soul.toString();
			fightPowerTxt.text = PlayerManager.getIns().heroBattlePower.toString();
		}
		
		private function renderPlayerAssets() : void{
			(BmdViewFactory.getIns().initView(OtherEntityView) as OtherEntityView).setEntity(player.occupation==1?2:1, PlayerManager.getIns().getPartnerEquipped());
			AnimationLayerManager.getIns().setOtherPosition(200, 165);
			this.addChild(AnimationLayerManager.getIns().otherEntityLayer);
		}
		
		private function renderProperties():void
		{
			if(!_iconArr){
				_iconArr = new Array();
				for(var i:int = 0; i<player.heroScriptVo.addValueArr.length;i++){
					var addIcon:HeroAddValueIcon = new HeroAddValueIcon();
					addIcon.x = 343;
					addIcon.y = 132+i*40;
					addIcon.layerName = translateAddName(i);
					this.addChild(addIcon);
					
					_iconArr.push(addIcon);
				}
			}
			for (var j:int = 0; j<player.heroScriptVo.addValueArr.length;j++){
				_iconArr[j].setData(player.heroScriptVo.addValueArr[j]);
			}
		}
		
		private function renderBoss():void{
			
			
			if(!_bossChangePage){
				_bossChangePage = new ChangePage();
				_bossChangePage.x = 672;
				_bossChangePage.y = 440;
				this.addChild(_bossChangePage);	
			}
			
			if (!_bossGrid)
			{
				_bossGrid = new AutoGrid(HeroUpgradeBossIcon,6, 6, 50, 50, 1, 1);
				_bossGrid.x = 555;
				_bossGrid.y = 133;
				this.addChild(_bossGrid);
			}
			_bossGrid.setData(PackManager.getIns().sortByMId(player.pack.bossUnEquip)
				,_bossChangePage);
		}
		
		
		private function initEvent():void
		{
			upgradeBtn.addEventListener(MouseEvent.CLICK,onUpgrade);
			EventManager.getIns().addEventListener(EventConst.HERO_UPGRADE_BOSS_SELECT,onSelectBoss)
		}		
		
		protected function onUpgrade(e:MouseEvent):void
		{
			if(!checkLv()){
				return;
			}
			
			if(!checkDiffer()){
				return;
			}
			
			if(player.soul < costSoul){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"战魂不足！");
				return;
			}
			
			(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
				"是否消耗选定卡牌与"+costSoul+"战魂提升伙伴对应属性？",
				showEffect
			);

		}
		

		
		private function sureUpgrade():void{
			
			var heroAddArr:Array = player.heroScriptVo.addValueArr;
			for(var i:int = 0; i<player.heroScriptVo.addValueArr.length;i++){
				heroAddArr[i]+=_addProperty[translateAddName(i)];
			}
			player.heroScriptVo.addValueArr = heroAddArr;
			
			for each(var boss:ItemVo in _selectedBossVec){
				PackManager.getIns().reduceItemByItemVo(boss,1);
			}
			PlayerManager.getIns().reduceSoul(costSoul);
			update();	
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).renderPartner();
			
		}
		
		private function showEffect():void{
			upgradeBtn.mouseEnabled = false;
			_effect = AnimationEffect.createAnimation(10015,["attachEffect"],false,removeEffect);
			_effect.x = 210;
			_effect.y = 182;
			this.addChild(_effect);
			RenderEntityManager.getIns().removeEntity(_effect);
			AnimationManager.getIns().addEntity(_effect);
		}
		
		private function removeEffect(...args):void{
			if(_effect != null){
				AnimationManager.getIns().removeEntity(_effect);
				_effect.destroy();
				_effect = null;
			}
			sureUpgrade();
		}
		
		private function checkLv():Boolean{
			var result:Boolean = true;

			for(var i:int=0;i<player.heroScriptVo.addValueArr.length;i++){
				if(player.character.lv<_afterLvArr[i]*10 && ShopManager.getIns().vipLv<5){
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						NameHelper.getPropertyName(translateAddName(i))
						+"属性需要达到"+_afterLvArr[i]*10+"级才能传功到"+_afterLvArr[i]+"阶");
					result = false;
				}
				if(_afterLvArr[i]>=10){
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"已达到当前最高等级！");
					result = false;
				}
			}
			return result;
		}
		
		private function checkDiffer():Boolean
		{
			var result:Boolean = true;
			var minLv:int = 10;
			var maxLv:int = 0;
			var index:int = 0;
			for(var i:int=0;i<player.heroScriptVo.addValueArr.length;i++){
				minLv = Math.min(minLv,_iconArr[i].lv);
				if(_iconArr[i].lv<minLv){
					minLv= _iconArr[i].lv;
				}
				
				if(_afterLvArr[i]>maxLv){
					maxLv = _afterLvArr[i];
					index = i;
				}
			}
			if(maxLv-minLv>=2){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"其他属性还未达到"+int(minLv+1)+"阶，"+NameHelper.getPropertyName(translateAddName(index))+"属性不能继续传功提升");
				result = false;
			}
			return result;
		}
		
		protected function onSelectBoss(e:CommonEvent):void
		{	
			costSoul = 0;
			_addProperty = new BasePropertyVo();
			_afterLvArr = new Array();
			var costArr:Array = [0,0,0,0,0,0];
			if(e.data[1].isSelected){
				e.data[1].hideSelected();
				_selectedBossVec.splice(_selectedBossVec.indexOf(e.data[0]),1);
			}else{
				e.data[1].showSelected();
				_selectedBossVec.push(e.data[0]);
			}
			
			for each(var boss:ItemVo in _selectedBossVec){
				for(var i:int=0;i<boss.bossConfig.add_type.length;i++){
					_addProperty[boss.bossConfig.add_type[i]] += int(boss.bossConfig.add_value[i]*boss.bossUp.add_rate*0.1);
					costArr[translateAddIndex(boss.bossConfig.add_type[i])] += boss.bossUp.pass_soul;
				}	
			}
			

			for(var j:int = 0; j<player.heroScriptVo.addValueArr.length;j++){
				var lv:int = _iconArr[j].setUpgradeValue(_addProperty[translateAddName(j)]);
				_afterLvArr.push(lv);
				costSoul += costArr[j]*lv;
			}
			
			if(_selectedBossVec.length>0){
				GreyEffect.reset(upgradeBtn);
				upgradeBtn.mouseEnabled = true;
			}else{
				GreyEffect.change(upgradeBtn);
				upgradeBtn.mouseEnabled = false;
			}
			
			costTxt.text = costSoul.toString();

		}	
		

		
		private function get upgradeBtn():SimpleButton{
			return _obj["upgradeBtn"];
		}
		
		private function get fightPowerTxt():TextField{
			return _obj["fightPowerTxt"];
		}
		
		private function get costTxt():TextField{
			return _obj["costTxt"];
		}
		
		private function get curTxt():TextField{
			return _obj["curTxt"];
		}

		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		private function translateAddName(i:int):String{
			var name:String;
			switch(i){
				case 0:
					name = "hp";
					break;
				case 1:
					name = "mp";
					break;
				case 2:
					name = "atk";
					break;
				case 3:
					name = "def";
					break;
				case 4:
					name = "ats";
					break;
				case 5:
					name = "adf";
					break;
			}
			return name;
		}
		
		private function translateAddIndex(name:String):int{
			var index:int;
			switch(name){
				case "hp":
					index = 0;
					break;
				case "mp":
					index = 1;
					break;
				case "atk":
					index = 2;
					break;
				case "def":
					index = 3;
					break;
				case "ats":
					index = 4;
					break;
				case "adf":
					index = 5;
					break;
			}
			return index;
		}
		
		public function hide() : void{
			AnimationLayerManager.getIns().removeFromParentByOther();
			if(BmdViewFactory.getIns().getView(OtherEntityView) != null){
				BmdViewFactory.getIns().destroyView(OtherEntityView);
			}
		}
		
		override public function destroy() : void{
			
			for each(var icon:HeroAddValueIcon in _iconArr){
				icon.destroy();
				icon = null;
			}
			_iconArr = null;
			
			while(_selectedBossVec.length>0){
				_selectedBossVec.splice(0,1);
			}
			_selectedBossVec = null;
			
			removeComponent(_obj);
			
			if(_bossGrid != null){
				_bossGrid.destroy();
				_bossGrid = null;
			}
			if(_bossChangePage != null){
				_bossChangePage.destroy();
				_bossChangePage = null;
			}
			super.destroy();
		}
	}
}