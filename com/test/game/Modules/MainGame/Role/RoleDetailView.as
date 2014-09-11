package com.test.game.Modules.MainGame.Role
{

	import com.Open4399Tools.Open4399Tools;
	import com.greensock.TweenMax;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.Show.ShowRoleEntity;
	import com.test.game.Manager.EquipedManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.Layer.AnimationLayerManager;
	import com.test.game.Modules.MainGame.BagView;
	import com.test.game.Modules.MainGame.Guide.RoleDetailGuideView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Mvc.BmdView.RoleEntityView;
	import com.test.game.Mvc.Vo.BasePropertyVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.data.DataControl;
	import com.test.game.UI.ItemIcon;
	import com.test.game.UI.Grid.EquipedGrid;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class RoleDetailView extends BaseView
	{
		private var _propertyTitles:Vector.<Sprite>;
		
		private var _equippedEquipGrid:EquipedGrid;
		
		private var _fashionIcon:ItemIcon;
		
		private var _titleIcon:ItemIcon;
		
		public var callBack:Function;
		public function RoleDetailView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.ROLEDETAILVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function renderView(...args):void{
			LoadManager.getIns().hideProgress();
			layer = AssetsManager.getIns().getAssetObject(AssetsConst.ROLEDETAILVIEW.split("/")[1]) as Sprite;
			this.addChild(layer);
			layer.visible = false;
			this.isClose =true;
			
			partnerBtn.visible = false;
			
			initUI();
			renderTips();
			renderData();
			renderEquips();
			renderFashion();
			renderTitle();
			
			initEvent();
			
			if(callBack!=null){
				callBack();
			}
			show();

		}
		
		private var _roleEntity:ShowRoleEntity
		private function initUI():void{
			(layer["helpBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onShowHelp);
			
			BmdViewFactory.getIns().initView(RoleEntityView).show();
		}
		
		private function onShowHelp(e:MouseEvent) : void{
			ViewFactory.getIns().initView(RoleDetailGuideView).show();
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		private function renderTips():void{
			
			var _propertyTipsJson:Object=DataControl.getPropertyTipsJson()["PropertyTips"];

			_propertyTitles = new Vector.<Sprite>();
			_propertyTitles.push(HpTitle);
			_propertyTitles.push(MpTitle);
			_propertyTitles.push(AtkTitle);
			_propertyTitles.push(DefTitle);
			_propertyTitles.push(AtsTitle);
			_propertyTitles.push(AdfTitle);
			
			//添加tips信息
			for(var i:int = 0; i < _propertyTitles.length; i++)
			{
				TipsManager.getIns().addTips(_propertyTitles[i],{title:_propertyTipsJson[i]["name"], tips:_propertyTipsJson[i]["tips"]});
			}
			
		}
		
		
		private function renderData():void{
			
			playerName.text = player.name;
			battlePower.text = PlayerManager.getIns().battlePower.toString();
			
			var totalProperty:BasePropertyVo = player.character.totalProperty;
			HP.text = totalProperty.hp.toString();
			MP.text = totalProperty.mp.toString();
			ATK.text = totalProperty.atk.toString();
			DEF.text = totalProperty.def.toString();
			ATS.text = totalProperty.ats.toString();
			ADF.text = totalProperty.adf.toString();
			
			var morePropertyStr:String = 
				"暴击 + "+(totalProperty.crit*100).toFixed(2)+"%  韧性 + "+(totalProperty.toughness*100).toFixed(2)+"%\n"
				+"命中 + "+(totalProperty.hit*100).toFixed(2)+"%  闪避 + "+(totalProperty.evasion*100).toFixed(2)+"%"
				+"\n伤害加深 + "+(totalProperty.hurt_deepen*100).toFixed(2)+"% \n伤害减免 + "+(totalProperty.hurt_reduce*100).toFixed(2)+"%"
				+"\n体力回复 + "+totalProperty.hp_regain+"  \n元气回复 + "+totalProperty.mp_regain;
			
			TipsManager.getIns().addTips(moreProperty,{title:morePropertyStr, tips:""});
			
			renderUI();
		}
		
		private function renderUI():void{
			if(player.character.lv < 10){
				layer["Lv_1"].x = 77;
				(layer["Lv_1"] as MovieClip).gotoAndStop(player.character.lv + 1);
				(layer["Lv_2"] as MovieClip).visible = false;
				(layer["Lv_2"] as MovieClip).stop();
			}else{
				layer["Lv_1"].x = 72;
				(layer["Lv_1"] as MovieClip).gotoAndStop(int(player.character.lv / 10 + 1));
				(layer["Lv_2"] as MovieClip).visible = true;
				(layer["Lv_2"] as MovieClip).gotoAndStop(int(player.character.lv % 10 + 1));
			}
			
			var arr:Array =	PlayerManager.getIns().getLevelInfo(player.exp);
			if(player.character.lv == NumberConst.getIns().maxLv){
				(layer["ExpBar"] as Sprite).width = 202;
			}else{
				(layer["ExpBar"] as Sprite).width = (player.exp - arr[0]) / (arr[1] - arr[0]) * 202;
			}
			(layer["ExpTF"] as TextField).text = player.exp - arr[0] + "/" + (arr[1] - arr[0]);
		}
		
		
		private function renderEquips():void{

			if (!_equippedEquipGrid)
			{
				_equippedEquipGrid = new EquipedGrid(ItemIcon,3, 2, 45, 45, 160, 7);
				_equippedEquipGrid.x = 62;
				_equippedEquipGrid.y = 90;
				layer.addChild(_equippedEquipGrid);
			}
			_equippedEquipGrid.selectable = false;
			_equippedEquipGrid.setData(EquipedManager.getIns().EquipedVos);
		}
		
		private function renderFashion():void{
			if (!_fashionIcon)
			{
				_fashionIcon = new ItemIcon();
				_fashionIcon.x = 78;
				_fashionIcon.y = 248;
				layer.addChild(_fashionIcon);
			}
			_fashionIcon.selectable = false;
			_fashionIcon.setData(EquipedManager.getIns().EquipedFashionVo);
			if(EquipedManager.getIns().EquipedFashionVo){
				showFashion.visible = true;
			}else{
				showFashion.visible = false;
			}
		}
		
		private function renderTitle():void{
			if (!_titleIcon)
			{
				_titleIcon = new ItemIcon();
				_titleIcon.x = 135;
				_titleIcon.y = 248;
				layer.addChild(_titleIcon);
			}
			_titleIcon.selectable = false;
			if(player.titleInfo.titleNow!= -1){
				_titleIcon.setData(PackManager.getIns().creatItem(player.titleInfo.titleNow));
			}else{
				_titleIcon.setData(null);
			}
			

		}
		
		// 刷新
		override public function update() : void
		{
			renderData();
			renderEquips();
			renderFashion();
			renderTitle();
			(BmdViewFactory.getIns().initView(RoleEntityView) as RoleEntityView).update();
			showFashion.gotoAndStop(player.fashionInfo.showFashion+1);
		}

		private function initEvent():void{
			moveBar.addEventListener(MouseEvent.MOUSE_DOWN,moveView);
			moveBar.addEventListener(MouseEvent.MOUSE_UP,putView);
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			showFashion.addEventListener(MouseEvent.CLICK, onShowFashion);
			partnerBtn.addEventListener(MouseEvent.CLICK,onShowPartner);
		}
		
		protected function onShowPartner(event:MouseEvent):void
		{
			ViewFactory.getIns().initView(PartnerDetailView).show();
			tweenLiteLeft();
		}
		
		protected function onShowFashion(event:MouseEvent):void
		{
			if(player.fashionInfo.showFashion==0){
				player.fashionInfo.showFashion=1;
			}else{
				player.fashionInfo.showFashion=0;
			}
			showFashion.gotoAndStop(player.fashionInfo.showFashion+1);
			(BmdViewFactory.getIns().initView(RoleEntityView) as RoleEntityView).update();
		}		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		override public function tweenLiteLeft():void{
			TweenMax.fromTo(this,0.3,{x:300},{x:100});
			GuideManager.getIns().tweenLiteGuidePosition();
		}
		
		override public function tweenLiteCenter():void{
			TweenMax.fromTo(this,0.3,{x:100},{x:300});
		}
		
		
		override public function show():void{
			if(layer == null) return;
			if(!ViewFactory.getIns().getView(BagView) || ViewFactory.getIns().getView(BagView).isClose){
				this.x = 300;
			}else if(this.isClose){
				tweenLiteLeft();
				ViewFactory.getIns().getView(BagView).tweenLiteRight();
			}
			this.y=40;
			openTween();
			update();
			
			AnimationLayerManager.getIns().roleEntityLayer.x = 115;
			AnimationLayerManager.getIns().roleEntityLayer.y = 78;
			layer.addChild(AnimationLayerManager.getIns().roleEntityLayer);
			
			super.show();
			
		}
		
		private function openTween():void{
			layer.scaleX = layer.scaleY = 0;
			layer.visible = true;
			TweenMax.fromTo(layer,0.4,{scaleX:0,scaleY:0,x:pos.x,y:pos.y},{scaleX:1,scaleY:1,x:this.centerX,y:this.centerY});			
		}
		
		private function closeTween():void{
			TweenMax.to(layer,0.4,{scaleX:0,scaleY:0,x:pos.x,y:pos.y,onComplete:hide});			
		}
		
		private function get pos():Point{
			var p:Point = new Point();
			p.x = ViewFactory.getIns().getView(MainToolBar).layer["role"].x + 25  - this.x;
			p.y = ViewFactory.getIns().getView(MainToolBar).layer["role"].y + 25 - this.y;
			return p;
		}
		
		private function close(e:MouseEvent):void{
			if(ViewFactory.getIns().getView(BagView) && !ViewFactory.getIns().getView(BagView).isClose){
				ViewFactory.getIns().getView(BagView).tweenLiteCenter();
			}
			
			closeTween();
			
			if(AnimationLayerManager.getIns().roleEntityLayer.parent != null){
				AnimationLayerManager.getIns().roleEntityLayer.parent.removeChild(AnimationLayerManager.getIns().roleEntityLayer);
			}
			//BmdViewFactory.getIns().initView(RoleEntityView).hide();
		}
		
		private function moveView(e:MouseEvent):void{
			this.startDrag();
		}
		
		private function putView(e:MouseEvent):void{
			this.stopDrag();
		}
		
		
		public function guideShowInfo() : void{
			GuideManager.getIns().showRoleDetailGuide();
		}

		public function get playerName():TextField
		{
			return layer["playerName"];
		}
		
		public function get battlePower():TextField
		{
			return layer["battlePower"];
		}
		
		public function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		public function get moveBar():Sprite
		{
			return layer["moveBar"];
		}
		
		
		
		public function get ExpNum():TextField
		{
			return layer["ExpNum"];
		}
		
		public function get ExpBar():Sprite
		{
			return layer["ExpBar"];
		}
		
		public function get HP():TextField
		{
			return layer["HP"];
		}
		public function get MP():TextField
		{
			return layer["MP"];
		}
		public function get ATK():TextField
		{
			return layer["ATK"];
		}
		public function get DEF():TextField
		{
			return layer["DEF"];
		}
		public function get ATS():TextField
		{
			return layer["ATS"];
		}
		public function get ADF():TextField
		{
			return layer["ADF"];
		}
		
		public function get HpTitle():Sprite
		{
			return layer["HpTitle"];
		}
		
		public function get MpTitle():Sprite
		{
			return layer["MpTitle"];
		}
		public function get AtkTitle():Sprite
		{
			return layer["AtkTitle"];
		}
		public function get DefTitle():Sprite
		{
			return layer["DefTitle"];
		}
		public function get AtsTitle():Sprite
		{
			return layer["AtsTitle"];
		}
		public function get AdfTitle():Sprite
		{
			return layer["AdfTitle"];
		}
		
		public function get moreProperty():Sprite
		{
			return layer["moreProperty"];
		}
		
		private function get showFashion():MovieClip
		{
			return layer["fashionShow"];
		}
		
		private function get partnerBtn():SimpleButton
		{
			return layer["partnerBtn"];
		}
		
		public function get position() : Point{
			return new Point(this.x, this.y);
		}
		
		override public function destroy():void{
			moveBar.removeEventListener(MouseEvent.MOUSE_DOWN,moveView);
			moveBar.removeEventListener(MouseEvent.MOUSE_UP,putView);
			closeBtn.removeEventListener(MouseEvent.CLICK,close);
			if(_equippedEquipGrid != null){
				_equippedEquipGrid.destroy();
				_equippedEquipGrid = null;
			}
			if(_propertyTitles != null){
				while (_propertyTitles.length > 0)
				{
					var sp:Sprite = _propertyTitles[0];
					if (sp.parent) sp.parent.removeChild(sp);
					sp = null;
					_propertyTitles.splice(0,1);
				}
				_propertyTitles.length = 0;
				_propertyTitles = null;
			}
			layer = null;
			super.destroy();
		}

	}
}