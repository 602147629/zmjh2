package com.test.game.Modules.MainGame.Tip
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GameSettingManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.PublicNoticeManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.StartPageView;
	import com.test.game.Mvc.Configuration.Player;
	import com.test.game.Mvc.Configuration.PublicNotice;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class PublicNoticeView extends BaseView
	{
		private var publicNotice:Sprite;
		private var _noticeArr:Array = [];
		private var _publicStep:int;
		private var _isClick:Boolean;
		private var _getMoneyTxt:TextField;
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public function PublicNoticeView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			layer = new Sprite();
			this.addChild(layer);
			initPublicNotice();
		}
		
		private function initPublicNotice():void{
			publicNotice = AssetsManager.getIns().getAssetObject("publicNoticeMc") as Sprite;
			publicNotice.x = 50;
			publicNotice.y = 116;
			greetBtn.buttonMode = true;
			greetBtn.addEventListener(MouseEvent.CLICK, onGreetPublicNotice);
			EventManager.getIns().addEventListener(EventConst.PUBLIC_NOTICE, addNotice);
			_getMoneyTxt = new TextField();
			var format:TextFormat = new TextFormat();
			format.size = 20;
			_getMoneyTxt.defaultTextFormat = format;
			_getMoneyTxt.x = 400;
			_getMoneyTxt.y = 300;
		}
		
		private function addNotice(e:CommonEvent):void{
			if((ViewFactory.getIns().getView(StartPageView) as StartPageView).isNew
				|| player == null
				|| GameSettingManager.getIns().publicNotice == GameSettingManager.HIDE_PUBLIC_NOTICE) return;
			_noticeArr.push(e.data.result);
		}
		
		private function showPublicNotice():void{
			_isClick = false;
			var publicNoticeData:PublicNotice = ConfigurationManager.getIns().getObjectByID(
				AssetsConst.PUBLICNOTICE, _noticeArr[0].type) as PublicNotice;
			if(publicNoticeData == null){
				resetPublicNoticeTxt();
				_publicStep = -1;
			}else{
				var content:String = publicNoticeData.message.replace("[1]",ColorConst.setGold(_noticeArr[0].name));
				var infoArr:Array = _noticeArr[0].info.split("|");
				for(var i:int = 0; i < infoArr.length; i++){
					content = content.replace("[" + (i + 2) + "]", ColorConst.setGold(infoArr[i]));
				}
				publicNoticeTxt.htmlText = content;
				layer.addChild(publicNotice);
				TipsManager.getIns().removeTips(greetBtn);
				if(PublicNoticeManager.getIns().checkPublicNoticeCount){
					TipsManager.getIns().addTips(greetBtn, {title:"祝福次数已超过200次，明天才能继续祝福", tips:""});
				}else{
					TipsManager.getIns().addTips(greetBtn, {title:player.statisticsInfo.publicNoticeCount + "/200", tips:""});
				}
			}
		}
		
		private function resetPublicNoticeTxt():void{
			_noticeArr.shift();
			publicNoticeTxt.htmlText = "";
			if(publicNotice.parent != null){
				publicNotice.parent.removeChild(publicNotice);
			}
		}
		
		private function onGreetPublicNotice(e:MouseEvent):void{
			if(player == null) return;
			var _curPlayerSet:Player = ConfigurationManager.getIns().getObjectByProperty(
				AssetsConst.PLAYER, "lv", player.character.lv) as Player;
			var soul:int
			if(PublicNoticeManager.getIns().checkPublicNoticeCount){
				soul = NumberConst.getIns().one;
			}else{
				soul = int(_curPlayerSet.dailysoul / NumberConst.getIns().two);
			}
			_getMoneyTxt.htmlText = ColorConst.setGold("战魂+" + soul);
			LayerManager.getIns().gameTipLayer.addChild(_getMoneyTxt);
			TweenMax.to(_getMoneyTxt, 1.6, {ease:Linear.easeInOut, y:260, alpha:0.5, onComplete:removeGetMoneyTxt});
			PlayerManager.getIns().addSoul(soul);
			PublicNoticeManager.getIns().addPublicNoticeCount();
			resetPublicNoticeTxt();
			_isClick = true;
		}
		
		private function removeGetMoneyTxt():void{
			_getMoneyTxt.htmlText = "";
			if(_getMoneyTxt.parent){
				_getMoneyTxt.parent.removeChild(_getMoneyTxt);
			}
			_getMoneyTxt.y = 300;
			_getMoneyTxt.alpha = 1;
		}
		
		override public function update() : void{
			if(_noticeArr.length > 0 && player != null){
				if(_publicStep == 0){
					showPublicNotice();
				}else if(_publicStep == 8 && !_isClick){
					resetPublicNoticeTxt();
				}else if(_publicStep == 10){
					_publicStep = -1;
				}
				_publicStep++;
			}else{
				_publicStep = 0;
			}
		}
		
		public function clear() : void{
			if(publicNotice != null){
				greetBtn.play();
				TipsManager.getIns().removeTips(greetBtn);
				GreyEffect.reset(greetBtn);
			}
		}
		
		private function get greetBtn() : MovieClip{
			return (publicNotice["greetBtn"] as MovieClip);
		}
		private function get publicNoticeTxt() : TextField{
			return (publicNotice["publicNoticeTxt"] as TextField);
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameTipLayer;	
		}
	}
}