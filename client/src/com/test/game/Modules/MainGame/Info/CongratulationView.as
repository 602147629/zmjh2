package com.test.game.Modules.MainGame.Info
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.BuffConst;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class CongratulationView extends BaseView
	{
		private var _callback:Function;
		private var _itemID:int;
		private var _itemVo:ItemVo;
		private var _itemIcon:ItemIcon;
		private var _specialItem:BaseNativeEntity;
		private var _point:Point;
		public function CongratulationView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.CONGRATULATIONVIEW)
			];
			AssetsManager.getIns().addQueen([], arr, start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = new Sprite();
				this.addChild(layer);
				
				initUI();
				initParams();
				setParams();
				setCenter();
				startPlay(_itemID, _callback);
			}
		}
		
		private var _playMC:MovieClip;
		private function initParams():void{
			var obj:Object = AssetsManager.getIns().getAssetObject("CongratulationView");
			_playMC = obj as MovieClip;
			_playMC.stop();
			_playMC.x = -180;
			_playMC.y = -170;
			_itemIcon = new ItemIcon();
			_itemIcon.selectable = false;
			_itemIcon.menuable = false;
			_specialItem = new BaseNativeEntity();
		}
		
		protected function onHide(event:MouseEvent):void{
			this.hide();
			(_playMC["ComfireBtn"] as SimpleButton).removeEventListener(MouseEvent.CLICK, onHide);
			if(_callback != null){
				_callback();
			}
		}
		
		private function onEnterFrameHandler(e:Event) : void{
			if(e.target.currentFrame == 10){
				(_playMC["ComfireBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onHide);
				if(_itemID > 0){
					itemLayer.addChild(_itemIcon);
					(_playMC["Info"] as TextField).text = "恭喜您获得了" + _itemVo.name + "X" + _itemVo.num;
				}else{
					itemLayer.addChild(_specialItem);
					switch(_itemID){
						case BuffConst.BUFF_LAOXIU:
							(_playMC["Info"] as TextField).text = "恭喜您获得了老朽的祝福";
							break;
						case BuffConst.BUFF_GAOSHOU:
							(_playMC["Info"] as TextField).text = "恭喜您获得了30次高手卡的自动战斗!";
							break;
						case BuffConst.BUFF_RENPIN:
							(_playMC["Info"] as TextField).text = "恭喜您获得了30次战斗的人品加成!";
							break;
						case BuffConst.BUFF_SHUANGBEI:
							(_playMC["Info"] as TextField).text = "恭喜您获得了30次双倍经验金币战魂战斗!";
							break;
					}
					
				}
			}
			if(e.target.currentFrame == e.target.totalFrames){
				e.target.stop();
				e.target.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
		}
		
		override public function step():void{
			
		}
		
		private function initUI():void{
			initBg();
		}
		
		public function startPlay(itemID:int, callback:Function = null) : void{
			SoundManager.getIns().fightSoundPlayer("LevelUpSound");
			_itemID = itemID;
			_callback = callback;
			if(layer == null) return;
			
			if(_playMC != null){
				_playMC.gotoAndPlay(1);
				_playMC.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
				if(_playMC.parent == null){
					layer.addChild(_playMC);
				}
			}
			var point:Point;
			if(_itemIcon != null && _itemIcon.parent != null){
				_itemIcon.parent.removeChild(_itemIcon);
			}
			if(_specialItem != null && _specialItem.parent != null){
				_specialItem.parent.removeChild(_specialItem);
			}
			if(_itemID > 0){
				_point = (ViewFactory.getIns().getView(MainToolBar) as MainToolBar).getBtnPosition("bag");
				_itemVo = PackManager.getIns().creatItem(_itemID);
				_itemIcon.setData(_itemVo);
			}else{
				TipsManager.getIns().removeTips(_specialItem);
				switch(_itemID){
					case BuffConst.BUFF_LAOXIU:
						_specialItem.data.bitmapData = AUtils.getNewObj("BuffLaoXiu") as BitmapData;
						TipsManager.getIns().addTips(_specialItem, {title:"老朽的祝福", tips:"初出江湖的少侠们可以获得此BUFF，使用技能不消耗元气，所有技能冷却时间减半。（此效果一直持续到15级）"});
						break;
					case BuffConst.BUFF_GAOSHOU:
						_specialItem.data.bitmapData = AUtils.getNewObj("BuffGaoShou") as BitmapData;
						TipsManager.getIns().addTips(_specialItem, {title:"高手BUFF", tips:"使用自动战斗将变成高手模式全程霸体！BOSS战时可以自动战斗，过关后获得经验，金钱和战魂增加50%。"});
						break;
					case BuffConst.BUFF_RENPIN:
						_specialItem.data.bitmapData = AUtils.getNewObj("BuffRenPin") as BitmapData;
						TipsManager.getIns().addTips(_specialItem, {title:"人品BUFF", tips:"过关后获得特殊道具的概率大大提高。"});
						break;
					case BuffConst.BUFF_SHUANGBEI:
						_specialItem.data.bitmapData = AUtils.getNewObj("BuffShuangBei") as BitmapData;
						TipsManager.getIns().addTips(_specialItem, {title:"双倍BUFF", tips:"过关后可以获得双倍的经验、金钱、战魂和材料。"});
						break;
				}
				_specialItem.x = 21 - _specialItem.width * .5;
				_specialItem.y = 21 - _specialItem.height * .5;
			}
			show();
		}
		
		override public function setParams():void{
			if(layer == null) return;
		}
		
		private function get itemLayer() : Sprite{
			return _playMC["ItemLayer"];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameInfoLayer;
		}
		
		override public function destroy() : void{
			_playMC = null;
			super.destroy();
		}
	}
}