package com.test.game.Modules.MainGame.Title
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.greensock.TweenMax;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Entitys.Show.ShowRoleEntity;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TitleManager;
	import com.test.game.Manager.Layer.AnimationLayerManager;
	import com.test.game.Modules.MainGame.Achieve.AchieveComponent;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Mvc.BmdView.RoleEntityView;
	import com.test.game.Mvc.Configuration.Title;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ChangePage;
	import com.test.game.UI.ItemIcon;
	import com.test.game.UI.Grid.AutoGrid;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	
	public class TitleView extends BaseView
	{

		private var _anti:Antiwear;
		
		private var _titleGrid:AutoGrid;
		
		private var _changePage:ChangePage;
		
		private var _curItemIcon:ItemIcon;
		
		private var _curTitleEnable:Boolean;
		
		private var _curTitleData:Title;
		
		
		private var _titleEffect:BaseSequenceActionBind;
		
		public function TitleView()
		{
			_anti = new Antiwear(new binaryEncrypt());
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.TITLEVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView,LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		
		
		private function renderView(...args):void{
			LoadManager.getIns().hideProgress();			
			
			 layer = AssetsManager.getIns().getAssetObject("TitleView") as Sprite;
			this.addChild(layer);
			layer.visible = false;
			equipState.mouseEnabled = false;
			
			BmdViewFactory.getIns().initView(RoleEntityView).show();
			
			update();
			initEvent();
			initBg();
			setCenter();
			openTween();
		}

		private function get player():PlayerVo
		{
			return PlayerManager.getIns().player;
		}		
		

		override public function update():void{
			(BmdViewFactory.getIns().initView(RoleEntityView) as RoleEntityView).update();
			AnimationLayerManager.getIns().roleEntityLayer.x = 185;
			AnimationLayerManager.getIns().roleEntityLayer.y = 106;
			layer.addChild(AnimationLayerManager.getIns().roleEntityLayer);
			renderIcons();
			selectFirst();
		}
		
		
		private function renderIcons():void{
			
			
			if(!_changePage){
				_changePage = new ChangePage();
				_changePage.x = 60;
				_changePage.y = 390;
				_changePage.scaleX = _changePage.scaleY = 0.9;
				layer.addChild(_changePage);	
			}
			
			if (!_titleGrid)
			{
				_titleGrid = new AutoGrid(TitleIcon,6, 1, 120, 54, 0, 0);
				_titleGrid.x = 35;
				_titleGrid.y = 56;
				layer.addChild(_titleGrid);
			}
			_titleGrid.setData(titleData,_changePage);
			
			if(!_curItemIcon){
				_curItemIcon = new ItemIcon();
				_curItemIcon.x = 235;
				_curItemIcon.y = 285;
				_curItemIcon.hideNum();
				_curItemIcon.selectable = false;
				_curItemIcon.menuable = false;
				layer.addChild(_curItemIcon);	
			}
		}
		
		private function get titleData():Array{
			return ConfigurationManager.getIns().getAllData(AssetsConst.TITLE);
		}

		
		private function initEvent():void{
			EventManager.getIns().addEventListener(EventConst.TITLE_SELECT_CHANGE,onTitleSelect);
			equipBtn.addEventListener(MouseEvent.CLICK,equipTitle);
			closeBtn.addEventListener(MouseEvent.CLICK,close);
		}
		
		protected function equipTitle(event:MouseEvent):void
		{
			if(_curTitleEnable){
				TitleManager.getIns().putUpTitle(_curTitleData.id);
				equipBtn.visible = false;
				equipState.htmlText = ColorConst.setYellow("已装备");
			}
		}
		
		protected function onTitleSelect(e:CommonEvent):void
		{
			_titleGrid.clearItemArrSelected();
			e.data[1].showSelected();
			_curTitleEnable = e.data[0].own;
			renderTitleInfo(e.data[0].titleData);
		}		
		
		private function renderTitleInfo(data:Title):void
		{
			_curTitleData = data;
			if(_titleEffect){
				AnimationManager.getIns().removeEntity(_titleEffect);
				_titleEffect.destroy();
				_titleEffect = null;
			}
			var index:int = int(data.id.toString().substr(2,3));
			_titleEffect = AnimationEffect.createAnimation(10030,["Title_"+index],false);
			if(index == 4 || index == 5 || index == 8){
				_titleEffect.x = 428;
				_titleEffect.y = 58;
			}else if(index == 1 || index == 2 || index == 3){
				_titleEffect.x = 448;
				_titleEffect.y = 128;
			}else{
				_titleEffect.x = 440;
				_titleEffect.y = 108;
			}

			this.addChild(_titleEffect);
			RenderEntityManager.getIns().removeEntity(_titleEffect);
			AnimationManager.getIns().addEntity(_titleEffect);
			
			_curItemIcon.setData(PackManager.getIns().creatItem(data.id));
			
			
			
			if(_curTitleEnable){
				if(player.titleInfo.titleNow == _curTitleData.id){
					equipBtn.visible = false;
					equipState.htmlText = ColorConst.setYellow("已装备");
				}else{
					equipBtn.visible = true;
					equipState.htmlText = "";
				}
			}else{
				equipBtn.visible = false;
				equipState.htmlText = ColorConst.setRed("未获得");
			}
			
			if(_curTitleData.id == NumberConst.getIns().title_10 && _curTitleEnable==false){
				requireTxt.text = "?????";
			}else{
				requireTxt.text = data.message;
			}
			
			
		}
		
		
		private function get addValueTxt():TextField
		{
			return layer["addValueTxt"];
		}
		
		private function get requireTxt():TextField
		{
			return layer["requireTxt"];
		}

		private function get equipBtn():SimpleButton
		{
			return layer["equipBtn"];
		}
		
		private function get equipState():TextField
		{
			return layer["equipState"];
		}
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		
		override public function show():void{
			if(layer == null) return;
			openTween();
			update();
			super.show();
		}
		
		private function selectFirst():void
		{
			_titleGrid.clearItemArrSelected();
			_titleGrid.showItemArrSelected(0);
			_curTitleEnable = _titleGrid.first.own;
			renderTitleInfo(_titleGrid.first.titleData);
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
			p.x = ViewFactory.getIns().getView(RoleStateView).layer["Role"]["titleBtn"].x  + 25 - this.x;
			p.y = ViewFactory.getIns().getView(RoleStateView).layer["Role"]["titleBtn"].y  + 25 - this.y;
			return p;
		}
		
		
		private function close(e:MouseEvent):void{
			if(_titleEffect){
				AnimationManager.getIns().removeEntity(_titleEffect);
				_titleEffect.destroy();
				_titleEffect = null;
			}
			closeTween();
		}
		
		override public function hide():void{
			super.hide();
		}
		

		
		override public function destroy():void{
			layer = null;
			super.destroy();
		}
	}
}