package com.test.game.Modules.MainGame.DungeonMenu
{
	import com.greensock.TweenMax;
	import com.superkaka.game.Loader.AssetsManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class DungeonTitle extends Sprite
	{
		private var _data:Array;
		private var _dungeonTitle:MovieClip;
		
		public function get dungeonTitle():Sprite{
			return _dungeonTitle;
		}
		
		public var index:int;
		
		private var _orginalY:int;
	
		private var _dungeonIconArr:Array;
		
		public var isShow:Boolean;
		
		public function DungeonTitle()
		{
			_dungeonIconArr=[];
			_dungeonTitle = AssetsManager.getIns().getAssetObject("DungeonTitle") as MovieClip;
			_dungeonTitle.stop();
			_dungeonTitle.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_dungeonTitle.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addChild(_dungeonTitle);
			this.buttonMode=true;
			
			for(var i:int = 0; i < 3; i++){
				var icon:DungeonIcon = new DungeonIcon();
				this.addChild(icon);
				_dungeonIconArr.push(icon);
			}
			
			setIconsVisible(false);
		}
		
		public function setData(data:Array, assess:Array):void{
			_data = data;
			_orginalY = this.y;
			setName()
			
			for(var i:int = 0; i < 3; i++){
				_dungeonIconArr[i].setData(_data[i], assess[i]);
				_dungeonIconArr[i].x = 15 + 100 * i;
				_dungeonIconArr[i].y = 50;
			}
			setIconsVisible(false);
		}
		
		private function setName() : void{
			DungeonNum.mouseEnabled = false;
			DungeonName.mouseEnabled = false;
			var info:Array = _data[0].chapter.split(" ");
			DungeonNum.text = info[0];
			DungeonName.text = info[2];
			switch((info[0] as String).slice(1, 2)){
				case "一":
					(_dungeonTitle["TitleHead"]["TitleChange"] as MovieClip).gotoAndStop(1);
					break;
				case "二":
					(_dungeonTitle["TitleHead"]["TitleChange"] as MovieClip).gotoAndStop(2);
					break;
				case "三":
					(_dungeonTitle["TitleHead"]["TitleChange"] as MovieClip).gotoAndStop(3);
					break;
				case "四":
					(_dungeonTitle["TitleHead"]["TitleChange"] as MovieClip).gotoAndStop(4);
					break;
			}
		}
		
		private var _tweenMaxFun:Function;
		public function showDungeons():void{
			isShow = true;
			TweenMax.killAll(true);
			TweenMax.to(this,0.5,{y:_orginalY, onComplete:setIconsVisible, onCompleteParams:[true]});
			//setIconsVisible(true);
			_dungeonTitle.gotoAndStop(1);
			_dungeonTitle["TitleHead"].visible = true;
		}
		
		public function onMouseOver(e:MouseEvent) : void{
			_dungeonTitle.gotoAndStop(1);
			if(!isShow)
				_dungeonTitle["TitleHead"].visible = false;
		}
		
		public function onMouseOut(e:MouseEvent) : void{
			if(isShow) return;
			_dungeonTitle.gotoAndStop(2);
			_dungeonTitle["TitleHead"].visible = false;
		}
		
		public function hideDungeonsDown():void{
			isShow = false;
			setIconsVisible(false);
			TweenMax.to(this, 0.5, {y:_orginalY + 95});
			_dungeonTitle.gotoAndStop(2);
			_dungeonTitle["TitleHead"].visible = false;
		}
		
		public function hideDungeonsUp():void{
			isShow=false;
			setIconsVisible(false);
			TweenMax.to(this,0.5, {y:_orginalY});
			_dungeonTitle.gotoAndStop(2);
			_dungeonTitle["TitleHead"].visible = false;
		}
		
		private function setIconsVisible(visible:Boolean):void{
			for(var i:int = 0; i < _dungeonIconArr.length; i++){
				var icon:DungeonIcon = _dungeonIconArr[i];
				icon.visible = visible;
				icon.x = i * 115 + 15;
				//TweenMax.fromTo(icon,0.4,{x:icon.x - 60},{x:icon.x});
			}
		}
		
		
		public function get DungeonNum():TextField{
			return _dungeonTitle["DungeonNum"];
		}
		
		public function get DungeonName():TextField{
			return _dungeonTitle["DungeonName"];
		}

		public function destroy() : void{
			for(var i:int = 0; i < 4; i++){
				_dungeonIconArr[i].destroy();
				_dungeonIconArr[i] = null;
			}
			_dungeonIconArr.length = 0;
			_dungeonIconArr = null;
			_dungeonTitle.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_dungeonTitle.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			if(_dungeonTitle.parent != null){
				_dungeonTitle.parent.removeChild(_dungeonTitle);
			}
			_dungeonTitle = null;
		}
	}
}