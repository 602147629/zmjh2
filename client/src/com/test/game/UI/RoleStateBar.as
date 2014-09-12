package com.test.game.UI
{
	import com.greensock.TweenLite;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Manager.RoleManager;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class RoleStateBar extends BaseSprite
	{
		private var _layer:Sprite;
		private var _roleHead:BaseNativeEntity;
		public function RoleStateBar(name:String, fodder:String)
		{
			super();
			
			_layer = AssetsManager.getIns().getAssetObject("RoleStateBar") as Sprite;
			this.addChild(_layer);
			
			_roleHead = new BaseNativeEntity();
			_roleHead.data.bitmapData = AUtils.getNewObj(fodder + "_LittleHead") as BitmapData;
			_roleHead.data.scaleX = -.7;
			_roleHead.data.scaleY = .7;
			RoleHead.addChild(_roleHead);
			
			playerName.text = name;
			maskTest();
		}
		
		public function resetRole(name:String, fodder:String) : void{
			playerName.text = name;
			_roleHead.data.bitmapData = AUtils.getNewObj(fodder + "_LittleHead") as BitmapData;
			
			var arr:Array = RoleManager.getIns().getOnlyHpAndMp();
			setHp(arr[0], arr[0]);
			setMp(arr[1], arr[1]);
		}
		
		public function setHp(useHp:Number, totalHp:Number) : void{
			var rate:Number = useHp / totalHp;
			if(rate <= 0){
				rate = 0;
			}else if(rate > 1){
				rate = 1;
			}
			if(_hpMask != null){
				TweenLite.to(_hpMask, 1, {width:rate * 164});
				hpTF.text = int(useHp<0?0:useHp) + "/" + totalHp;
			}
		}
		
		public function setMp(useMp:Number, totalMp:Number) : void{
			var rate:Number = useMp / totalMp;
			if(rate <= 0){
				rate = 0;
			}else if(rate > 1){
				rate = 1;
			}
			if(_mpMask != null){
				TweenLite.to(_mpMask, 1, {width:rate * 136});
				mpTF.text = int(useMp) + "/" + totalMp;
			}
		}
		
		private var _hpMask:Sprite;
		private var _mpMask:Sprite;
		private function maskTest():void{
			_hpMask = new Sprite();
			_hpMask.graphics.beginFill(0xFF0000);
			_hpMask.graphics.drawRect(0, 0, 164, 20);
			_hpMask.graphics.endFill();
			hpBar.addChild(_hpMask);
			hpBar.mask = _hpMask;
			
			_mpMask = new Sprite();
			_mpMask.graphics.beginFill(0xFF0000);
			_mpMask.graphics.drawRect(0, 0, 136, 20);
			_mpMask.graphics.endFill();
			mpBar.addChild(_mpMask);
			mpBar.mask = _mpMask;
		}
		
		public function get hpBar():Sprite{
			return _layer["RoleBar"]["HpBar"];
		}
		public function get mpBar():Sprite{
			return _layer["RoleBar"]["MpBar"];
		}
		public function get hpTF() : TextField{
			return _layer["RoleBar"]["HpLayer"]["HpTF"];
		}
		public function get mpTF() : TextField{
			return _layer["RoleBar"]["MpLayer"]["MpTF"];
		}
		public function get playerName() : TextField{
			return _layer["RoleBar"]["PlayerName"];
		}
		public function get RoleHead():Sprite{
			return _layer["RoleHead"];
		}
		public function get roleBar() : Sprite{
			return _layer["RoleBar"];
		}
	}
}