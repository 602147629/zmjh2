package com.test.game.Modules.MainGame.Escort
{
	import com.greensock.TweenMax;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Effect.ViewTweenEffect;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EscortManager;
	import com.test.game.Manager.ExtraBarManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Mvc.Configuration.VehicleEscort;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class EscortView extends BaseView
	{
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public function EscortView()
		{
			super();
			
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.ESCORTVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = AssetsManager.getIns().getAssetObject("EscortView") as Sprite;
				this.addChild(layer);
				layer.visible = false;
				initUI();
				initParams();
				setParams();
				setCenter();
				initBg();
				openTween();
			}
		}
		
		private function initUI():void{
			startEscortBtn.addEventListener(MouseEvent.CLICK, onStartEscort);
			startLootBtn.addEventListener(MouseEvent.CLICK, onStartLoot);
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			for(var i:int = 1; i <= 3; i++){
				(layer["BiaoCheSelect" + i] as MovieClip).gotoAndStop(1);
				(layer["BiaoChe" + i] as MovieClip).gotoAndStop(1);
				(layer["BiaoChe" + i] as MovieClip).buttonMode = true;
				(layer["BiaoChe" + i] as MovieClip).addEventListener(MouseEvent.CLICK, onSelectBiaoChe);
			}
		}
		
		private function openTween():void{
			var pos:Point = ExtraBarManager.getIns().getBtnPos("Escort");
			ViewTweenEffect.openTween(layer, pos.x, pos.y, centerX, centerY);
		}
		
		private function closeTween():void{
			var pos:Point = ExtraBarManager.getIns().getBtnPos("Escort");
			ViewTweenEffect.closeTween(layer, pos.x, pos.y, hide);
		}
		
		override public function show() : void{
			if(layer == null) return;
			openTween();
			update();
			super.show();
		}
		
		
		protected function onClose(event:MouseEvent):void{
			closeTween();
		}
		
		protected function onSelectBiaoChe(e:MouseEvent):void{
			EscortManager.getIns().nowBiaoChe = e.currentTarget.name.split("BiaoChe")[1];
			updateShow();
		}
		
		private function updateShow():void{
			for(var i:int = 1; i <= 3; i++){
				(layer["BiaoCheSelect" + i] as MovieClip).gotoAndStop(1);
				(layer["BiaoChe" + i] as MovieClip).gotoAndStop(1);
			}
			(layer["BiaoCheSelect" + EscortManager.getIns().nowBiaoChe] as MovieClip).gotoAndStop(2);
			(layer["BiaoChe" + EscortManager.getIns().nowBiaoChe] as MovieClip).gotoAndStop(2);
		}
		
		//点击劫镖选择
		protected function onStartLoot(event:MouseEvent):void{
			EscortManager.getIns().lootCondition();
		}
		
		//开始劫镖匹配
		public function reallyStartLoot() : void{
			ViewFactory.getIns().initView(LootWaitView).show();
			EscortManager.getIns().startLootBattle();
			this.hide();
		}
		
		//点击护镖选择
		protected function onStartEscort(event:MouseEvent):void{
			EscortManager.getIns().escortCondition();
		}
		
		private function initParams():void{
			
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			update();
		}
		
		override public function update() : void{
			updateInfo();
			updateShow();
			updateTime();
			updateBtn();
		}
		
		private function updateBtn():void{
			if(player.mainMissionVo.id > 1008){
				(layer["Loot"] as Sprite).visible = true;
			}else{
				(layer["Loot"] as Sprite).visible = false;
			}
		}
		
		public function updateLootTime(min:int, sec:int) : void{
			if(layer != null && lootColdTime != null){
				lootColdTime.text = "冷却时间：" + min + ":" + sec;
			}
		}
		
		public function updateEscortTime(min:int, sec:int) : void{
			if(layer != null && escortColdTime != null){
				escortColdTime.text = "冷却时间：" + min + ":" + sec;
			}
		}
		
		private function updateTime():void{
			lootTime.text = player.escortInfo.lootCount.toString();
			escortTime.text = player.escortInfo.escortCount.toString();
			lootColdTime.visible = (player.escortInfo.lootCount==0?false:true);
			escortColdTime.visible = (player.escortInfo.escortCount==0?false:true);
			if(EscortManager.getIns().canEscort){
				startEscortBtn.mouseEnabled = true;
				GreyEffect.reset(startEscortBtn);
				escortColdTime.visible = false;
			}else{
				startEscortBtn.mouseEnabled = false;
				GreyEffect.change(startEscortBtn);
				escortColdTime.visible = true;
			}
			if(EscortManager.getIns().canLoot){
				startLootBtn.mouseEnabled = true;
				GreyEffect.reset(startLootBtn);
				lootColdTime.visible = false;
			}else{
				startLootBtn.mouseEnabled = false;
				GreyEffect.change(startLootBtn);
				lootColdTime.visible = true;
			}
		}
		
		private function updateInfo():void{
			EscortManager.getIns().biaoCheInfo = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.VEHICLE_ESCORT, "lv", PlayerManager.getIns().player.character.lv) as VehicleEscort;
			TipsManager.getIns().removeTips(layer["BiaoChe1"]);
			TipsManager.getIns().removeTips(layer["BiaoChe2"]);
			TipsManager.getIns().removeTips(layer["BiaoChe3"]);
			TipsManager.getIns().addTips(layer["BiaoChe1"],{title:"木牛：", tips:"镖车生命上限低，移动速度慢\n使用价格：免费"});
			TipsManager.getIns().addTips(layer["BiaoChe2"],{title:"流马：", tips:"镖车生命上限中等，移动速度中等\n使用价格：" + EscortManager.getIns().biaoCheInfo.money + "金币"});
			TipsManager.getIns().addTips(layer["BiaoChe3"],{title:"金车：", tips:"镖车生命上限高，移动速度高\n使用价格：200点券"});
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		private function get startEscortBtn() : SimpleButton{
			return layer["StartEscortBtn"];
		}
		private function get startLootBtn() : SimpleButton{
			return layer["Loot"]["StartLootBtn"];
		}
		private function get closeBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
		private function get lootTime() : TextField{
			return layer["Loot"]["LootTime"];
		}
		private function get escortTime() : TextField{
			return layer["EscortTime"];
		}
		private function get lootColdTime() : TextField{
			return layer["Loot"]["LootColdTime"];
		}
		private function get escortColdTime() : TextField{
			return layer["EscortColdTime"];
		}
	}
}