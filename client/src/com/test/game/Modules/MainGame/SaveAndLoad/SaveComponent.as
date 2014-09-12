package com.test.game.Modules.MainGame.SaveAndLoad
{
	import com.gameServer.ApiFor4399;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.URLManager;
	import com.test.game.Modules.MainGame.SelectPlayerView;
	import com.test.game.Modules.MainGame.StartPageView;
	import com.test.game.Modules.MainGame.WaitView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SaveComponent extends Sprite
	{
		private var _obj:Sprite;
		
		private var _numMc:MovieClip;
		
		private var _index:int;
		
		private var _type:int;//1 save 2 load
		private var _data:*;
		
		public function SaveComponent(index:int)
		{
			_index = index;
			this.buttonMode = true;
			super();
			renderView();
		}
		
		private function renderView():void
		{
			_obj = AssetsManager.getIns().getAssetObject("saveComponent") as Sprite;
			this.addChild(_obj);
			
			var str:String = "save"+_index;
			_numMc = AssetsManager.getIns().getAssetObject(str) as MovieClip;
			_numMc.x = 20;
			_numMc.y = 10;
			this.addChild(_numMc);
			
			empty.mouseEnabled = false;
			playerName.mouseEnabled = false;
			playerInfo.mouseEnabled = false;
			saveTime.mouseEnabled = false;
			
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		public function resetData() : void{
			_data = null;
		}
		
		public function setType(type:int):void{
			_numMc.gotoAndStop(type)
			_type = type;
			if(_type == 1){
				empty.text = "点击新建存档";
				unNormal.visible = false;
			}else if(_type == 2){
				empty.text = "无存档记录";
				unNormal.visible = false;
			}
		}
		
		protected function onClick(e:MouseEvent):void{
			//if(SaveManager.getIns().judgeUserID()){
				//1 save 2 load
				PlayerManager.getIns().saveIndex = _index;
				if(_type == 1){
					if(_data != null){
						(ViewFactory.getIns().initView(TipView) as TipView).setFun("这样做原来的存档会删除，是否覆盖原存档？", createNew, null);
					}else{
						createNew();
					}
				}else if(_type == 2){
					if(_data){
						if(_data.status == 1){
							(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun("您的该存档由于修改已被暂时封停，点击确定进行账号申诉。", 
								function () : void{
									URLManager.getIns().openDataURL();
								}, null);
						}else if(_data.status == 2){
							(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun("您的该存档由于修改次数过多已经被永久封停。", null, null);
						}else{
							ApiFor4399.getIns().getData(false, _index);
							ViewFactory.getIns().initView(WaitView).show();
						}
						//ViewFactory.getIns().initView(StartPageView).hide();	
					}
				}
			//}
		}
		
		private function createNew() : void{
			ViewFactory.getIns().initView(StartPageView).hide();
			ViewFactory.getIns().initView(SelectPlayerView).show();
		}

		public function setData(data:* = null):void{
			if(data == null){
				empty.visible = true;
				playerName.text = "";
				playerInfo.text = "";
				saveTime.text = "";
				unNormal.visible = false;
			}else{
				empty.visible = false;
				
				_data = data;
				_index = data.index;
				
				var titleArr:Array = data.title.split("|");
				playerName.text = titleArr[0];
				
				if(titleArr.length >= 2){
					playerInfo.text = titleArr[1];
				}
				saveTime.text = data.datetime;
				
				if(_data.status != 0){
					unNormal.visible = true;
				}else{
					unNormal.visible = false;
				}
			}
		}
		
		private function get playerName():TextField
		{
			return _obj["playerName"];
		}
		
		private function get playerInfo():TextField
		{
			return _obj["playerInfo"];
		}
		
		private function get saveTime():TextField
		{
			return _obj["saveTime"];
		}
		
		private function get empty():TextField
		{
			return _obj["empty"];
		}
		private function get unNormal() : Sprite{
			return _obj["UnNormal"];
		}
	}
}