package com.test.game.Modules.MainGame.Role
{

	import com.greensock.TweenMax;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Entitys.Show.ShowRoleEntity;
	import com.test.game.Manager.EquipedManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.Layer.AnimationLayerManager;
	import com.test.game.Modules.MainGame.BagView;
	import com.test.game.Modules.MainGame.Skill.PartnerSkillView;
	import com.test.game.Mvc.BmdView.OtherEntityView;
	import com.test.game.Mvc.BmdView.RoleEntityView;
	import com.test.game.Mvc.Vo.BasePropertyVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.data.DataControl;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class PartnerDetailView extends BaseView
	{
		private var _propertyTitles:Vector.<Sprite>;

		private var _fashionIcon:ItemIcon;
		
		
		public function PartnerDetailView()
		{
			renderView()
		}
		
		
		private function renderView():void{
			LoadManager.getIns().hideProgress();
			layer = AssetsManager.getIns().getAssetObject("PartnerDetailView") as Sprite;
			this.addChild(layer);
			layer.visible = false;
			this.isClose =true;
			
			renderTips();
			renderData();
			renderFashion();
			
			initEvent();

			show();

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
			
			partnerName.text = player.name + "的小伙伴";
			battlePower.text = PlayerManager.getIns().heroBattlePower.toString();
			var configProperty:BasePropertyVo = player.character.configProperty;
			var levelProperty:BasePropertyVo = player.character.levelUpProperty;
			
			HP.text = configProperty.hp + levelProperty.hp + player.heroScriptVo.addValueArr[0];
			MP.text = configProperty.mp + levelProperty.mp + player.heroScriptVo.addValueArr[1];
			ATK.text = configProperty.atk + levelProperty.atk + player.heroScriptVo.addValueArr[2];
			DEF.text = configProperty.def + levelProperty.def  + player.heroScriptVo.addValueArr[3];
			ATS.text = configProperty.ats + levelProperty.ats + player.heroScriptVo.addValueArr[4];
			ADF.text = configProperty.adf + levelProperty.adf + player.heroScriptVo.addValueArr[5];
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

		}
		
		private function renderPlayerAssets() : void{
			(BmdViewFactory.getIns().initView(OtherEntityView) as OtherEntityView).setEntity(player.occupation==1?2:1, PlayerManager.getIns().getPartnerEquipped());
			AnimationLayerManager.getIns().setOtherPosition(60,75);
			this.addChild(AnimationLayerManager.getIns().otherEntityLayer);
		}
		
		// 刷新
		override public function update() : void
		{
			renderPlayerAssets();
			renderData();
			renderFashion();
			(BmdViewFactory.getIns().initView(RoleEntityView) as RoleEntityView).update();
		}

		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			skillBtn.addEventListener(MouseEvent.CLICK,onShowSkill);
			upgradeBtn.addEventListener(MouseEvent.CLICK,onShowUpgrade);
		}
		
		protected function onShowUpgrade(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function onShowSkill(event:MouseEvent):void
		{
			//ViewFactory.getIns().initView(PartnerSkillView).show();
			hide();
		}			
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		
		override public function tweenLiteRight():void{
			TweenMax.fromTo(this,0.3,{x:320},{x:440});
		}
		
		override public function tweenLiteCenter():void{
			TweenMax.fromTo(this,0.3,{x:100},{x:300});
		}
		
		
		override public function show():void{
			if(layer == null) return;
			layer.visible = true;
			tweenLiteRight();
			this.y = 54;
			//openTween();
			update();
			
			super.show();
			
		}
		
		private function openTween():void{
			layer.scaleX = layer.scaleY = 0;
			layer.visible = true;
			TweenMax.fromTo(layer,0.4,{scaleX:0,scaleY:0,x:pos.x,y:pos.y},{scaleX:1,scaleY:1,x:this.centerX,y:this.centerY});			
		}
		
		private function closeTween():void{
			TweenMax.to(layer,0.4,{scaleX:0,scaleY:0,x:0,y:0,onComplete:hide});			
		}
		
		private function get pos():Point{
			var p:Point = new Point();
			p.x = ViewFactory.getIns().getView(RoleDetailView).layer["partnerBtn"].x;
			p.y = ViewFactory.getIns().getView(RoleDetailView).layer["partnerBtn"].y;
			return p;
		}
		
		private function close(e:MouseEvent):void{
			if(ViewFactory.getIns().getView(RoleDetailView) && !ViewFactory.getIns().getView(RoleDetailView).isClose){
				ViewFactory.getIns().getView(RoleDetailView).tweenLiteCenter();
			}
			
			//closeTween();
			hide();
			AnimationLayerManager.getIns().removeFromParentByOther();
			if(BmdViewFactory.getIns().getView(OtherEntityView) != null){
				BmdViewFactory.getIns().destroyView(OtherEntityView);
			}
		}


		private function get partnerName():TextField
		{
			return layer["partnerName"];
		}
		
		private function get battlePower():TextField
		{
			return layer["battlePower"];
		}
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		
		private function get HP():TextField
		{
			return layer["hpTxt"];
		}
		private function get MP():TextField
		{
			return layer["mpTxt"];
		}
		private function get ATK():TextField
		{
			return layer["atkTxt"];
		}
		private function get DEF():TextField
		{
			return layer["defTxt"];
		}
		private function get ATS():TextField
		{
			return layer["atsTxt"];
		}
		private function get ADF():TextField
		{
			return layer["adfTxt"];
		}
		
		private function get HpTitle():Sprite
		{
			return layer["HpTitle"];
		}
		
		private function get MpTitle():Sprite
		{
			return layer["MpTitle"];
		}
		private function get AtkTitle():Sprite
		{
			return layer["AtkTitle"];
		}
		private function get DefTitle():Sprite
		{
			return layer["DefTitle"];
		}
		private function get AtsTitle():Sprite
		{
			return layer["AtsTitle"];
		}
		private function get AdfTitle():Sprite
		{
			return layer["AdfTitle"];
		}
		
		private function get skillBtn():SimpleButton
		{
			return layer["skillBtn"];
		}
		private function get upgradeBtn():SimpleButton
		{
			return layer["upgradeBtn"];
		}
		
		

		
		public function get position() : Point{
			return new Point(this.x, this.y);
		}
		
		override public function destroy():void{
			closeBtn.removeEventListener(MouseEvent.CLICK,close);

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