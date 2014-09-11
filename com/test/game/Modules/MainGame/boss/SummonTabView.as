package com.test.game.Modules.MainGame.boss
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.NameHelper;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.DigitalEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.Info.GetSpecialView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.ChangePage;
	import com.test.game.UI.Grid.AutoGrid;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SummonTabView extends Sprite
	{
		
		private var _obj:Sprite;
		
		public var layerName:String;
		
		private var _curBossData:ItemVo;
		
		private var _curBossCard:SummonBossIcon;
		
		private var _summonCardGrid:AutoGrid;
		
		private var _cardChangePage:ChangePage;
		
		private var _summonEnable:Boolean;
		private var _summonEffect:BaseSequenceActionBind;
		
		private var selectIndex:int;
		
		public function SummonTabView()
		{
			_obj = AssetsManager.getIns().getAssetObject("summonTabView") as Sprite;
			this.addChild(_obj);
			
			renderPage();
			update();
			initEvent();
		}
		
		private var _battlePowerCount:Sprite;
		private function setDigital():void{
			if(_battlePowerCount != null && _battlePowerCount.parent != null){
				_obj.removeChild(_battlePowerCount);
				_battlePowerCount = null;
			}
			_battlePowerCount = DigitalEffect.createDigital("AtkHp", _curBossData.bossConfig.atk+_curBossData.bossConfig.ats);
			_battlePowerCount.x = 725;
			_battlePowerCount.y = 100;
			_battlePowerCount.scaleX = .5;
			_battlePowerCount.scaleY = .5;
			if(_battlePowerCount.parent == null){
				_obj.addChild(_battlePowerCount);
			}
		}		
		
		private function renderPage():void{
			
			_cardChangePage = new ChangePage();
			_cardChangePage.x = 230;
			_cardChangePage.y = 416;
			this.addChild(_cardChangePage);
		}
		
		private function renderBoss():void{
			if(!_summonCardGrid){
				_summonCardGrid = new AutoGrid(SummonBossIcon,2, 3, 152, 185,  10, 0);
				_summonCardGrid.x = 33;
				_summonCardGrid.y = 44;
				this.addChild(_summonCardGrid);
			}
			_summonCardGrid.setData(
				PackManager.getIns().sortMidByItemId(PackManager.getIns().curBossCardData),_cardChangePage);
			//_summonCardGrid.showItemArrSelected(selectIndex);
			_summonCardGrid.checkSummonEnableMc();
			if(!_curBossCard){
				_curBossCard = new SummonBossIcon();
				_curBossCard.x = 550;
				_curBossCard.y = 65;
				_curBossCard.selectable = false;
				this.addChild(_curBossCard);
			}
			
		}
		
		
		public function update(selectFirst:Boolean = true):void{
			summonBtn.visible = false;
			renderBoss();
/*			if(PackManager.getIns().curBossCardData.length>0){
				setCurBossData(PackManager.getIns().sortByItemId(PackManager.getIns().curBossCardData)[0]);
				
			}*/
			wanNengNum.text = "万能碎片数量： "+PackManager.getIns().searchItemNum(NumberConst.getIns().wanNengId).toString();
			if(selectFirst){
				selectFirstEquip();	
			}
			
		}
		
		private function initEvent():void{
			EventManager.getIns().addEventListener(EventConst.SUMMON_BOSS_SELECT_CHANGE,onBossSelect);
			summonBtn.addEventListener(MouseEvent.CLICK,onSummonBoss);
		}
		
		/**
		 * 
		 * 召唤boss按键响应
		 * 
		 */
		protected function onSummonBoss(e:MouseEvent):void
		{

			if(_summonEnable){
				var pieceId:int = _curBossData.id - 10000 + 9000;
				if(PackManager.getIns().searchItemNum(pieceId) < NumberConst.getIns().summonBossCost){
					var wanNengCost:int = NumberConst.getIns().summonBossCost - PackManager.getIns().searchItemNum(pieceId);
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice(
						"是否确认消耗"+wanNengCost.toString()+"万能碎片进行召唤？",summon);
				}else{
					summon();
				}
			}
		}
		
		/**
		 *召唤boss效果添加
		 * 
		 */
		private function summon():void{
			if(PackManager.getIns().checkMaxRooM([_curBossData])){
				_summonEnable = false;
				this.mouseChildren = false;
				_summonEffect = AnimationEffect.createAnimation(10012,["summonEffect"],false,finalSummon)
				_summonEffect.x = 530;
				_summonEffect.y = 44;
				this.addChild(_summonEffect);
				RenderEntityManager.getIns().removeEntity(_summonEffect);
				AnimationManager.getIns().addEntity(_summonEffect);
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"背包空间不足！\n请留出空间后再召唤");
			}

		}
		
		/**
		 *召唤boss逻辑
		 * 
		 */
		private function finalSummon(...args):void{
			GuideManager.getIns().bossGuideSetting();
			(ViewFactory.getIns().initView(GetSpecialView) as GetSpecialView).setSpecial(_curBossData, _curBossData.name, function () : void{GuideManager.getIns().bossGuideSetting();});
			(ViewFactory.getIns().initView(GetSpecialView) as GetSpecialView).show();
			PackManager.getIns().summonBossCard(_curBossData);
			setCurBossData(_curBossData.copy());
			DeformTipManager.getIns().checkBossDeform();
			PlayerManager.getIns().checkFirstBossAchieve();
			AnimationManager.getIns().removeEntity(_summonEffect);
			_summonEffect.destroy();
			_summonEffect = null;
			this.mouseChildren = true;
		}
		
		private function onBossSelect(e:CommonEvent):void{
			setCurBossData(e.data[0] as ItemVo);
			_summonCardGrid.clearItemArrSelected();
			e.data[1].showSelected();
			selectIndex = e.data[1].index;
			if(e.data[0].id == 10002){
				GuideManager.getIns().bossTabJudge();
			}
		}

		
		
		
		private function selectFirstEquip():void{
			var _boss:Vector.<ItemVo> = PackManager.getIns().sortByMId(PackManager.getIns().curBossCardData);
			_summonCardGrid.clearItemArrSelected();
			if(_boss.length == 0){
				setCurBossData(null);
				selectIndex = -1;
			}else{
				setCurBossData(_boss[0]);
				selectIndex = 0;
				_summonCardGrid.showItemArrSelected(0);
			}
			
		}
		
		
		/**
		 *显示选定BOSS信息 
		 * @param data
		 * 
		 */		
		private function setCurBossData(data:ItemVo):void{
			if(!data){
				return;	
			}
			summonBtn.visible = true;
			_curBossData = data;
			_curBossCard.setData(_curBossData);
			atkTxt.text = _curBossData.bossConfig.atk.toString();
			atsTxt.text = _curBossData.bossConfig.ats.toString();
			setDigital();
			//battlePowerTxt.text = (_curBossData.bossConfig.atk+_curBossData.bossConfig.ats).toString();

			propertyAdd.text = ""; 
			for(var i:int =0 ; i<_curBossData.bossConfig.add_type.length;i++){
				propertyAdd.text += NameHelper.getPropertyName(_curBossData.bossConfig.add_type[i]) + 
					" +" + _curBossData.bossConfig.add_value[i] + "\n";
				
			}
			var skills:Array = _curBossData.bossConfig.skill_info.split("|");
			
			skillName.text = skills[0];
			skillInfo.text = skills[1];
			skillCost.text = "释放消耗"+_curBossData.bossConfig.skill_energy+"格能量";
			
			checkButton();
		}
		
		
		//按钮灰化判定
		private function checkButton():void
		{
			var result:Boolean = true;
			
			var pieceId:int = _curBossData.id - 10000 + 9000;

			if(PackManager.getIns().searchItemNum(pieceId) 
				+ PackManager.getIns().searchItemNum(NumberConst.getIns().wanNengId) 
				< NumberConst.getIns().summonBossCost){
				summonBtnEnable(false);
				TipsManager.getIns().addTips(summonBtn,{title:"碎片不足",tips:""});
				
				result = false;
			}

			if(result){
				summonBtnEnable(true);
				TipsManager.getIns().removeTips(summonBtn);
			}
		}	
		
		
		private function summonBtnEnable(enable:Boolean):void{
			if(enable){
				GreyEffect.reset(summonBtn);
				summonBtnMc.visible = true;
			}else{
				GreyEffect.change(summonBtn);
				summonBtnMc.visible = false;
			}
			_summonEnable = enable;
		}
		
		private function get battlePowerTxt():TextField
		{
			return _obj["battlePowerTxt"];
		}
		
		private function get atkTxt():TextField
		{
			return _obj["atkTxt"];
		}
		
		private function get atsTxt():TextField
		{
			return _obj["atsTxt"];
		}

		
		
		private function get propertyAdd():TextField
		{
			return _obj["propertyAdd"];
		}

		
		
		private function get skillName():TextField
		{
			return _obj["skillName"];
		}
		
		private function get skillInfo():TextField
		{
			return _obj["skillInfo"];
		}
		
		private function get skillCost():TextField
		{
			return _obj["skillCost"];
		}
		
		private function get wanNengNum():TextField
		{
			return _obj["wanNengNum"];
		}
		
		private function get summonBtn():SimpleButton
		{
			return _obj["summonBtn"];
		}
		
		private function get summonBtnMc():MovieClip
		{
			return _obj["summonLightMc"];
		}
		
		
		
		public function destroy() : void{
			if(this.parent != null){
				this.parent.removeChild(this);
			}
			if(_battlePowerCount != null){
				if(_battlePowerCount.parent != null){
					_battlePowerCount.parent.removeChild(_battlePowerCount);
				}
				_battlePowerCount = null;
			}
			if(_cardChangePage != null){
				_cardChangePage.destroy();
				_cardChangePage = null;
			}
			if(_curBossCard != null){
				_curBossCard.destroy();
				_curBossCard = null;
			}
			if(_summonCardGrid != null){
				_summonCardGrid.destroy();
				_summonCardGrid = null;
			}
			if(_summonEffect != null){
				_summonEffect.destroy();
				_summonEffect = null;
			}
			
			_curBossData = null;
			if(_obj != null){
				if(_obj.parent != null){
					_obj.parent.removeChild(_obj);
				}
				_obj = null;
			}
		}

	}
}