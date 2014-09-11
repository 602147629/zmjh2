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
	import com.test.game.Const.EventConst;
	import com.test.game.Const.GuideConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Entitys.Show.BaseAnimationEntity;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.AssistManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Configuration.BossCard;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ChangePage;
	import com.test.game.UI.Grid.AutoGrid;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class AssistTabView extends Sprite
	{
		private var _obj:Sprite;
		
		public var layerName:String;
		
		private var _bossGrid:AutoGrid
		
		private var _bossChangePage:ChangePage;
		
		private var _assistedBossIcon:AssistedDragIcon;
		private var _player:PlayerVo;
		private var _head:BaseNativeEntity;
		
		private var _bossAnimation:Sprite;
		
		private var _assistEffect:BaseSequenceActionBind;
		
		
		public function AssistTabView()
		{
			_obj = AssetsManager.getIns().getAssetObject("assistTabView") as Sprite;
			this.addChild(_obj);
			
			_head = new BaseNativeEntity();
			_head.data.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "_LittleHead") as BitmapData;
			_head.x = 320;
			_head.y = 40;
			this.addChild(_head);
			
			update();
			initEvent();
			initAnimation();
		}
		
		private function initAnimation():void
		{
			_bossAnimation = new Sprite();
			_bossAnimation.x = 45;
			_bossAnimation.y = 260;
			this.addChild(_bossAnimation);
		}		
		
		public function update():void{
			_player = PlayerManager.getIns().player;
			renderBosses();
			setAssistData();
			updateHead();
		}
		
		private function updateHead():void{
			_head.data.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "_LittleHead") as BitmapData;
		}
		
		private function renderBosses():void{
			
			if(!_assistedBossIcon){
				_assistedBossIcon = new AssistedDragIcon();
				this.addChild(_assistedBossIcon);	
			}

			
			if(!_bossChangePage){
				_bossChangePage = new ChangePage();
				_bossChangePage.x = 632;
				_bossChangePage.y = 350;
				this.addChild(_bossChangePage);	
			}
			
			if (!_bossGrid)
			{
				_bossGrid = new AutoGrid(AssistDragIcon,6, 6, 50, 50, 1, 1);
				_bossGrid.x = 515;
				_bossGrid.y = 36;
				this.addChild(_bossGrid);
			}
			_bossGrid.setData(PackManager.getIns().sortByCId(_player.pack.bossUnEquip)
				,_bossChangePage);
			
		}
		
		
		private function setAssistData():void{
			var curAssist:ItemVo = AssistManager.getIns().AssistVo;

			_assistedBossIcon.x = 380;
			_assistedBossIcon.y = 120;
			_assistedBossIcon.setData(curAssist);
			_assistedBossIcon.setOriginalPosition();
			
			if(curAssist){
				atkTxt.text = int(curAssist.bossConfig.atk*curAssist.bossUp.atk_rate).toString();
				atsTxt.text = int(curAssist.bossConfig.ats*curAssist.bossUp.ats_rate).toString();
				
				var skills:Array = curAssist.bossConfig.skill_info.split("|");
				
				if(skills.length >= 2){
					skillName.text = skills[0];
					skillInfo.text = skills[1];
				}
				skillCost.text = "释放消耗"+curAssist.bossConfig.skill_energy+"格能量";
				renderBossAnimation(curAssist);
				
			}else{
				atkTxt.text = "";
				atsTxt.text = "";
				skillName.text = "";
				skillInfo.text = "";
				skillCost.text = "";
				renderBossAnimation(null);
			}
		}
		
		private function renderBossAnimation(input:ItemVo):void{
			if(_bossAnimation == null) return;
			if(input == null){
				clearAnimation();
			}else{
				clearAnimation();
				var name:String = (ConfigurationManager.getIns().getObjectByProperty(AssetsConst.BOSS, "name", input.name) as BossCard).fodder;
				var animation:BaseAnimationEntity = new BaseAnimationEntity(name + "ShowAnimation", _bossAnimation);
				animation.scaleX = .7;
				animation.scaleY = .7;
			}
		}
		
		private function clearAnimation() : void{
			if(_bossAnimation == null) return;
			while(_bossAnimation.numChildren > 0){
				var animation:BaseAnimationEntity = _bossAnimation.getChildAt(0) as BaseAnimationEntity;
				animation.destroy();
				animation = null;
			}
		}
		
		
		private function initEvent():void{
			EventManager.getIns().addEventListener(EventConst.ASSIST_BOSS_STOP_DRAG,onPackBossStopDrag);
			EventManager.getIns().addEventListener(EventConst.ASSISTED_BOSS_STOP_DRAG,onAssistedStopDrag);
		}
		
		private function onAssistedStopDrag(e:CommonEvent):void{
			if(e.data[0].bossImage.x>70){
				if(PackManager.getIns().checkMaxRooM([e.data[1]])){
					AssistManager.getIns().downAssist(e.data[1]);
					update();
					return;
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"背包空间不足！\n请留出空间后再卸下");
				}
			}
			
			e.data[0].setOriginalPosition();
		}
		

		private function onPackBossStopDrag(e:CommonEvent):void{
			if(_assistedBossIcon.hitTestObject(e.data[0])){
				GuideManager.getIns().bossGuideSetting(GuideConst.BOSSASSIST);
				AssistManager.getIns().upAssist(e.data[1]);
				update();
				updateAssist();
				_assistEffect = AnimationEffect.createAnimation(10015,["attachEffect"],false,updateAssist)
				_assistEffect.x = 342;
				_assistEffect.y = 84;
				this.addChild(_assistEffect);
				RenderEntityManager.getIns().removeEntity(_assistEffect);
				AnimationManager.getIns().addEntity(_assistEffect);
				return;
			}
			e.data[0].setOriginalPosition();
		}
		
		private function updateAssist(...args):void{
			if(_assistEffect != null){
				AnimationManager.getIns().removeEntity(_assistEffect);
				_assistEffect.destroy();
				_assistEffect = null;	
			}
		}
		
		
		private function get atkTxt():TextField
		{
			return _obj["atkTxt"];
		}
		
		private function get atsTxt():TextField
		{
			return _obj["atsTxt"];
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
		
		public function destroy() : void{
			if(_bossGrid != null){
				_bossGrid.destroy();
				_bossGrid = null;
			}
			if(_bossChangePage != null){
				_bossChangePage.destroy();
				_bossChangePage = null;
			}
			if(_assistedBossIcon != null){
				_assistedBossIcon.destroy();
				_assistedBossIcon = null;
			}
			if(_head != null){
				_head.destroy();
				_head = null;
			}
			_player = null;
			_obj = null;
		}
	}
}