package com.test.game.Modules.MainGame
{
	import com.Open4399Tools.Open4399Tools;
	import com.gameServer.ApiFor4399;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.StringConst;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Modules.MainGame.Tip.TipSpecialView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Utils.AllUtils;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	public class SelectPlayerView extends BaseView
	{
		public function SelectPlayerView(){
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.SELECTPLAYERVIEW), AssetsUrl.getAssetObject(AssetsConst.TIPVIEW)], start, LoadManager.getIns().onProgress);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.SELECTPLAYERVIEW.split("/")[1]) as Sprite;
				layer.x = 0;
				layer.y = 0;
				this.addChild(layer);
				
				initUI();
				initParams();
				setParams();
			}
		}
		
		private function initParams():void{
			
		}
		
		private function initUI():void{
			KuangWuPicture.buttonMode = true;
			KuangWuPicture.gotoAndStop(1);
			KuangWuPicture.addEventListener(MouseEvent.CLICK, onSelectPlayer);
			KuangWuPicture.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			KuangWuPicture.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			XiaoYaoPicture.buttonMode = true;
			XiaoYaoPicture.gotoAndStop(1);
			XiaoYaoPicture.addEventListener(MouseEvent.CLICK, onSelectPlayer);
			XiaoYaoPicture.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			XiaoYaoPicture.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			KuangWuSelected.visible = false;
			XiaoYaoSelected.visible = false;
			
			(layer["QuitBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onQuit);
			
			confirmName= AssetsManager.getIns().getAssetObject("ConfirmName") as Sprite;
			confirmName.x = 310;
			confirmName.y = 250;
			(confirmName["ConfirmBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, comfireSelect);
			(confirmName["ReselectBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, reSelect);
			
			(confirmName["PlayerName"] as TextField).addEventListener(TextEvent.TEXT_INPUT, nameInputEvent);

		}
		
		private function nameInputEvent(e:TextEvent):void{
			if((AllUtils.getStringBytesLength((confirmName["PlayerName"] as TextField).text,"gb2312") 
				+ AllUtils.getStringBytesLength(e.text,'gb2312')) > (confirmName["PlayerName"] as TextField).maxChars){   
				e.preventDefault();   
				return;    
			}   
		}   
		
		private function onQuit(e:MouseEvent) : void{
			(ViewFactory.getIns().initView(TipView) as TipView).setFun("是否退出?", quit, null);
		}
		
		private function quit() : void{
			cancelSelect();
			this.hide();
			ViewFactory.getIns().getView(StartPageView).show();
		}
		
		private function onMouseOver(e:MouseEvent) : void{
			KuangWuPicture.gotoAndStop(1);
			XiaoYaoPicture.gotoAndStop(1);
			(e.currentTarget as MovieClip).gotoAndStop(2);
		}
		
		private function onMouseOut(e:MouseEvent) : void{
			(e.currentTarget as MovieClip).gotoAndStop(1);
		}
		
		private var _name:String;
		private function onSelectPlayer(e:MouseEvent) : void{
			KuangWuPicture.removeEventListener(MouseEvent.CLICK, onSelectPlayer);
			KuangWuPicture.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			KuangWuPicture.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			XiaoYaoPicture.removeEventListener(MouseEvent.CLICK, onSelectPlayer);
			XiaoYaoPicture.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			XiaoYaoPicture.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			(e.target as MovieClip).gotoAndStop(2);
			_name = e.currentTarget.name;
			(layer[_name + "Select"] as Sprite).visible = true;
			(layer["ClickSelect"] as Sprite).visible = false;
			showPlayerName();
		}
		
		private var confirmName:Sprite;
		private function showPlayerName() : void{
			layer.addChild(confirmName);
		}
		
		
		private function comfireSelect(e:MouseEvent) : void{
			if((confirmName["PlayerName"] as TextField).text != ""){
				var str:String = ("职业：" + (_name=="KuangWu"?StringConst.ROLE_KUANGWU:StringConst.ROLE_XIAOYAO) + "\n昵称：" +　(confirmName["PlayerName"] as TextField).text) + "\n\n是否开始游戏?";
				if(GameConst.localLogin){
					(ViewFactory.getIns().initView(TipSpecialView) as TipSpecialView).setFun(str, savePlayerData, cancelSelect);
				}else{
					(ViewFactory.getIns().initView(TipSpecialView) as TipSpecialView).setFun(str, checkBadWords, cancelSelect);
				}
			}else{
				(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun("昵称不能为空", null, null);
			}
		}
		
		private function reSelect(e:MouseEvent) : void{
			cancelSelect();
		}
		
		private function checkBadWords() : void{
			Open4399Tools.getIns().checkBadWords((confirmName["PlayerName"] as TextField).text, savePlayerData);
		}
		
		private function savePlayerData(code:int = 10000) : void{
			if(code == 10000){
				if(confirmName.parent != null){
					confirmName.parent.removeChild(confirmName);
				}
				ShopManager.getIns().getTotalRecharged(
					function (total:int) : void{
						PlayerManager.getIns().playerData = PlayerManager.getIns().initPlayerDataJson((confirmName["PlayerName"] as TextField).text, _name=="KuangWu"?1:2, total);	
						(ViewFactory.getIns().getView(StartPageView) as StartPageView).saveListView.saveType = 1;
						var saveTitle:String = (confirmName["PlayerName"] as TextField).text + "|" + (_name=="KuangWu"?"狂武":"逍遥") +"    lv.1";
						ApiFor4399.getIns().saveData(saveTitle, PlayerManager.getIns().playerData, false, PlayerManager.getIns().saveIndex);
					});
			}else{
				(ViewFactory.getIns().initView(TipView) as TipView).setFun("昵称带有敏感用词，请重新命名", null, null);
			}
		}
		
		private function cancelSelect() : void{
			KuangWuPicture.addEventListener(MouseEvent.CLICK, onSelectPlayer);
			KuangWuPicture.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			KuangWuPicture.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			XiaoYaoPicture.addEventListener(MouseEvent.CLICK, onSelectPlayer);
			XiaoYaoPicture.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			XiaoYaoPicture.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			KuangWuPicture.gotoAndStop(1);
			XiaoYaoPicture.gotoAndStop(1);
			KuangWuSelected.visible = false;
			XiaoYaoSelected.visible = false;
			(layer["ClickSelect"] as Sprite).visible = true;
			(confirmName["PlayerName"] as TextField).text = "4399小勇士";
			if(confirmName != null){
				if(confirmName.parent != null){
					confirmName.parent.removeChild(confirmName);
				}
			}
		}
		
		
		private function get KuangWuPicture():MovieClip{
			return layer["KuangWu"];
		}
		
		private function get XiaoYaoPicture():MovieClip{
			return layer["XiaoYao"];
		}
		
		private function get KuangWuSelected():Sprite{
			return layer["KuangWuSelect"];
		}
		
		private function get XiaoYaoSelected():Sprite{
			return layer["XiaoYaoSelect"];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy() : void{
			if(layer != null){
				if(layer.parent != null){
					layer.parent.removeChild(layer);
				}
				layer = null;
			}
			super.destroy();
		}
	}
}