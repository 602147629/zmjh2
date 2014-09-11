package com.test.game.Modules.MainGame.MainUI
{
	import com.greensock.TweenLite;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.Extra.DoubleDungeonManager;
	import com.test.game.Manager.Extra.OnlineBonusManager;
	import com.test.game.Modules.MainGame.BagView;
	import com.test.game.Modules.MainGame.DoubleDungeonView;
	import com.test.game.Modules.MainGame.EliteSelectView;
	import com.test.game.Modules.MainGame.Role.RoleDetailView;
	import com.test.game.Modules.MainGame.Activity.ActivityView;
	import com.test.game.Modules.MainGame.Escort.EscortView;
	import com.test.game.Modules.MainGame.PlayerKilling.PlayerKillingFightView;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Utils.AllUtils;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ExtraBar extends BaseView
	{
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		private var iconList:Array = ["Elite","Online", "Double", "PK", "Escort","Activity"];
		private var iconYPos:Array = [10, 19.15, 20.9, 22.2, 17.45, 21.25];
		public function ExtraBar()
		{
			start();
			super();
		}
		
		
		private function start() : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("ExtraBar") as Sprite;
				this.addChild(layer);
				
				initUI();
				initParams();
				setParams();
				update();
			}
		}
		
		private function initUI():void{
			eliteBtn.addEventListener(MouseEvent.CLICK, selectElite);
			doubleBtn.addEventListener(MouseEvent.CLICK, showDoubleView);
			onlineBtn.addEventListener(MouseEvent.CLICK, getOnlineReward);
			pkBtn.addEventListener(MouseEvent.CLICK, onPlayerKilling);
			escortBtn.addEventListener(MouseEvent.CLICK, showEscortView);
			ActivityBtn.addEventListener(MouseEvent.CLICK, onShowActivity);
		}
		
		protected function onShowActivity(e:MouseEvent) : void{
			ViewFactory.getIns().initView(ActivityView).show();
		}
		
		
		protected function showEscortView(event:MouseEvent):void{
			ViewFactory.getIns().initView(EscortView).show();
		}
		
		protected function onPlayerKilling(event:MouseEvent):void{
			ViewFactory.getIns().initView(PlayerKillingFightView).show();
		}
		

		
		private function getOnlineReward(e:MouseEvent) : void{
			if(OnlineBonusManager.getIns().onlineBonusStatus == 1){
				OnlineBonusManager.getIns().getOnlineReward();
				onlineUpdate();
			}
		}
		
		private function showDoubleView(e:MouseEvent) : void{
			ViewFactory.getIns().initView(DoubleDungeonView).show();
		}
		
		
		private function initParams():void{
			renderPosition();
		}
		
		private function selectElite(e:MouseEvent) : void{
			(ViewFactory.getIns().initView(EliteSelectView) as EliteSelectView).show();
			
			if(ViewFactory.getIns().getView(BagView) != null){
				(ViewFactory.getIns().getView(BagView) as BagView).onlyHide();
			}
			if(ViewFactory.getIns().getView(RoleDetailView) != null){
				ViewFactory.getIns().getView(RoleDetailView).hide();
			}
		}
		
		override public function setParams():void{
			if(layer == null) return;
			update();
		}
		
		override public function update():void{
			//精英副本
			if(layer == null) return;
			eliteUpdate();
			giftUpdate();
			onlineUpdate();
			doubleUpdate();
			
			playerKillingUpdate();
			escortUpdate();
		}
		
		private function escortUpdate():void{
			if(player.mainMissionVo.id > 1006){
				(layer["Escort"] as Sprite).visible = true;
			}else{
				(layer["Escort"] as Sprite).visible = false;
			}
		}
		
		private function playerKillingUpdate():void{
			if(player.mainMissionVo.id > 1016){
				(layer["PK"] as Sprite).visible = true;
			}else{
				(layer["PK"] as Sprite).visible = false;
			}
		}
		

		
		public function doubleUpdate():void{
			if(player.mainMissionVo.id > 1013){
				switch(DoubleDungeonManager.getIns().doubleStatus){
					case 1:
						GreyEffect.reset(doubleBtn);
						doubleBtn.mouseEnabled = true;
						doubleTime["Time"].text = "点击开启";
						doubleTime.visible = true;
						break;
					case 2:
						GreyEffect.reset(doubleBtn);
						doubleBtn.mouseEnabled = true;
						doubleTime.visible = true;
						break;
					case 3:
						GreyEffect.change(doubleBtn);
						doubleBtn.mouseEnabled = false;
						doubleTime["Time"].text = "明日刷新";
						doubleTime.visible = true;
						break;
				}
				(layer["Double"] as Sprite).visible = true;
			}else{
				(layer["Double"] as Sprite).visible = false;
			}
		}
		
		private function onlineUpdate():void{
			/*if(player.mainMissionVo.id > 1009){*/
				switch(OnlineBonusManager.getIns().onlineBonusStatus){
					case 1:
						onlineTime["Time"].visible = false;
						onlineTime["OnlineClick"].visible = true;
						onlineBtn.mouseEnabled = true;
						GreyEffect.reset(onlineBtn);
						TipsManager.getIns().removeTips(onlineBtn);
						break;
					case 2:
						onlineTime["Time"].visible = true;
						onlineTime["OnlineClick"].visible = false;
						GreyEffect.change(onlineBtn);
						TipsManager.getIns().addTips(onlineBtn, {title:"等待片刻，将有更多好礼相送！", tips:""});
						break;
					case 3:
						onlineTime["Time"].text = "明日刷新";
						onlineTime["Time"].visible = true;
						onlineTime["OnlineClick"].visible = false;
						onlineBtn.mouseEnabled = false;
						GreyEffect.change(onlineBtn);
						TipsManager.getIns().removeTips(onlineBtn);
						break;
				}
			/*	(layer["Online"] as Sprite).visible = true;
			}else{
				(layer["Online"] as Sprite).visible = false;
			}*/
		}
		
		private function giftUpdate() : void{
			/*if(player.mainMissionVo.id > 1002){
				(layer["Gift"] as Sprite).visible = true;
			}else{
				(layer["Gift"] as Sprite).visible = false;
			}*/
		}
		
		private function eliteUpdate() : void{
			if(PlayerManager.getIns().hasPassDungeonInfo("1_3") && player.mainMissionVo.id > 1003){
				(layer["Elite"] as Sprite).visible = true;
			}else{
				(layer["Elite"] as Sprite).visible = false;
			}
		}
		
		public function moveIcon(name:String) : void{
			(layer[name] as Sprite).visible = true;
			(layer[name] as Sprite).x = 435;
			(layer[name] as Sprite).y = 182;
		}
		
		public function renderPosition(rightNow:Boolean = true) : void{
			update();
			var j:int = 0;
			for(var i:int = 0; i < iconList.length; i++){
				if(rightNow){
					(layer[iconList[i]] as Sprite).x = 860 - j * 70;
					(layer[iconList[i]] as Sprite).y = iconYPos[i];
				}else{
					TweenLite.to(layer[iconList[i]], 1, {x:860 - j * 70, y:iconYPos[i], onComplete:mouseAble});
				}
				if((layer[iconList[i]] as Sprite).visible == true){
					j++;
				}
			}
		}
		
		public function updateDoubleTime(hour:int, minute:int, second:int) : void{
			doubleTime["Time"].text = AllUtils.addPre(minute + hour * 60) + ":" + AllUtils.addPre(second);
		}
		
		public function updateOnlineTime(hour:int, minute:int, second:int) : void{
			onlineTime["Time"].text = AllUtils.addPre(minute + hour * NumberConst.getIns().timeMinute) + ":" + AllUtils.addPre(second);
		}
		public function completeOnlineTime() : void{
			onlineUpdate();
		}
		
		public function mouseEnable() : void{
			layer.mouseChildren = false;
		}
		
		public function mouseAble() : void{
			layer.mouseChildren = true;
		}
		
		public function get eliteBtn() : SimpleButton{
			return layer["Elite"]["Elite"]["EliteBtn"];
		}

		public function get doubleBtn() : SimpleButton{
			return layer["Double"]["Double"]["DoubleBtn"];
		}
		public function get onlineBtn() : SimpleButton{
			return layer["Online"]["Online"]["OnlineBtn"];
		}


		public function get pkBtn() : SimpleButton{
			return layer["PK"]["PK"]["PKBtn"];
		}
		public function get escortBtn() : SimpleButton{
			return layer["Escort"]["Escort"]["EscortBtn"];
		}
		public function get ActivityBtn() : SimpleButton{
			return layer["Activity"]["Activity"]["ActivityBtn"]
		}
		
		

		public function get eliteObj() : Sprite{
			return layer["Elite"]["Elite"];
		}
		public function get doubleObj() : Sprite{
			return layer["Double"]["Double"];
		}
		public function get doubleTime() : Sprite{
			return layer["Double"]["DoubleTimeLayer"];
		}
		public function get onlineTime() : Sprite{
			return layer["Online"]["OnlineLayer"];
		}
		public function get escort() : Sprite{
			return layer["Escort"]["Escort"];
		}

		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy() : void{
			super.destroy();
		}
	}
}