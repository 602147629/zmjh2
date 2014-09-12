package com.test.game.UI
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Mvc.Vo.ItemVo;
	
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NumItemIcon extends BaseSprite
	{

		private var _image:BaseNativeEntity;
		
		private var _stars:BaseNativeEntity;
		
		private var _colorBg:BaseNativeEntity;
		
		private var _numTxt:TextField;
		
		private var _curNum:int;
		
		private var _needNum:int;
		
		
		private var _url:String;
		
		private var _data:ItemVo;
		
		public function get data():ItemVo{
			return _data;
		}
		
		
		public function NumItemIcon()
		{
			this.buttonMode = true;
			
			//物品图标
			if(!_image){
				_image  = new BaseNativeEntity();
				this.addChild(_image);
			}
			
			//颜色底
			if(!_colorBg){
				_colorBg  = new BaseNativeEntity();
				_colorBg.x=-1;
				_colorBg.y=-1;
				this.addChild(_colorBg);
			}
			
			//星星
			if(!_stars){
				_stars  = new BaseNativeEntity();
				_stars.x=5;
				_stars.y=32;
				this.addChild(_stars);
			}

			//数字
			if(!_numTxt){	
				var tipTextFormat:TextFormat = new TextFormat();
				tipTextFormat.font = "宋体";
				_numTxt = new TextField();
				_numTxt.x = -4;
				_numTxt.y = 28;
				_numTxt.width =50;
				_numTxt.autoSize = TextFieldAutoSize.RIGHT;
				_numTxt.defaultTextFormat = tipTextFormat;
				_numTxt.filters = new Array( new GlowFilter(ColorConst.black,1,2,2,255));
				_numTxt.mouseEnabled = false;
				this.addChild(_numTxt);
			}
			
			super();		
		}

		
		public function setData(data:ItemVo,need:int):void{
			
			
			if(!data){
				this.visible =false;
				return;
			}
			
			this.visible =true;
			_data = data;
			_needNum = need;
			
			if(_data.type == ItemTypeConst.BOSS ){
				if(PackManager.getIns().searchMaterialBossCard(_data.id,_data.lv)){
					_curNum = NumberConst.getIns().one;
				}else{
					_curNum = NumberConst.getIns().zero;
				}
				
			}else{
				_curNum = PackManager.getIns().searchItemNum(_data.id);
			}
			
			
			var _url:String = _data.type+_data.id.toString();
			_image.data.bitmapData = AUtils.getNewObj(_url) as BitmapData;
			
			//物品数量
			setNum();
			
			setBoss();
			
			//物品tip
			setTips();	
		}

		private function setNum():void
		{
			
			if(_curNum>=_needNum){
				_numTxt.textColor = ColorConst.green;
			}else{
				_numTxt.textColor = ColorConst.red;
			}
			_numTxt.text = _curNum.toString()+ "/" +_needNum.toString();

		}		
		
		private function setBoss():void
		{
			if(_data.type==ItemTypeConst.BOSS){
				_colorBg.data.bitmapData = AUtils.getNewObj(_data.bossUp.color) as BitmapData;
				var starId:String = "starIcon"+ _data.bossUp.star;
				_stars.data.bitmapData = AUtils.getNewObj(starId) as BitmapData;
				
			}
		}	
		
		private function setTips():void{
			TipsManager.getIns().addTips(this,_data);
		}
		
		
		override public function destroy():void{
			removeComponent(_image);
			removeComponent(_colorBg);
			removeComponent(_stars);
			removeComponent(_numTxt);
			super.destroy();
		}

	}
}