package com.test.game.Modules.MainGame.MainUI
{
	import com.greensock.TweenLite;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class PlayerKillingRoleStateView extends BaseView
	{
		private var _fodder:String = "";
		public function PlayerKillingRoleStateView(){
			super();
			RenderEntityManager.getIns().addEntity(this);
		}
		override public function init() : void{
			super.init();
			start();
		}
		
		private function start() : void{
			layer = AssetsManager.getIns().getAssetObject("PlayerKillingRoleStateView") as Sprite;
			layer.x = 625;
			layer.y = 10;
			//layer.scaleX = -1;
			this.addChild(layer);
			assist.visible = false;
			initParams();
			initUI();
			setParams();
		}
		
		private var _roleHead:BaseNativeEntity;
		private function initUI():void{
			_roleHead = new BaseNativeEntity();
			RoleHead.addChild(_roleHead);
		}
		
		private function initParams():void{
			maskTest();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		public function initPlayerData(player:PlayerVo) : void{
			_fodder = player.fodder;
			playerName.text = player.name;
			level.text = player.character.lv.toString();
			if(player.gameKey != null){
				playerGameID.text = "UID:" + player.gameKey.split("|")[0];
			}else{
				playerGameID.text = "心魔：";// + GameConst.UID;
			}
			setBossHead(player.assistInfo);
			setRoleHead(player.fodder);
			setHp(player.character.totalProperty.hp, player.character.totalProperty.hp);
			setMp(player.character.totalProperty.mp, player.character.totalProperty.mp);
		}
		
		private function setRoleHead(fodder:String):void{
			_roleHead.data.bitmapData = AUtils.getNewObj(fodder + "_LittleHead") as BitmapData;
		}
		
		private var _hurtStep:int = 0;
		public function setRoleHurtHead(count:int) : void{
			if(_hurtStep < count){
				_hurtStep = count;
			}
			_roleHead.y = -2;
			_roleHead.data.bitmapData = AUtils.getNewObj(_fodder + "_LittleHurtHead") as BitmapData;
		}
		
		override public function step():void{
			if(_hurtStep > 0){
				_hurtStep--;
				if(_hurtStep == 0){
					setRoleHead(_fodder);
				}
			}
		}
		
		private var _bossHead:BaseNativeEntity = new BaseNativeEntity;
		private function setBossHead(assistInfo:int):void{
			if(assistInfo == -1){
				layer["Assist"].visible = false;
				return;
			}else{
				layer["Assist"].visible = true;
				/*var curAssist:ItemVo = AssistManager.getIns().AssistVo;
				var skills:Array = curAssist.bossConfig.skill_info.split("|");
				var str:String = "\n" + skills[1] + "\n释放消耗"+curAssist.bossConfig.skill_energy+"格能量" + "\n<font color='#FFFF00'>按Q键可随时释放</font>";
				TipsManager.getIns().addTips((layer["Assist"] as Sprite), {title:skills[0], tips:str});*/
			}
			
			var obj:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SPECIAL, "id", assistInfo);
			var boss:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.BOSS, "id", obj.bid);
			_bossHead.data.bitmapData = AUtils.getNewObj(boss.fodder + "_LittleHead") as BitmapData;
			_bossHead.data.scaleX = -.5;
			_bossHead.data.scaleY = .5;
			if(_bossHead.parent == null){
				BossHead.addChild(_bossHead);
			}
		}
		
		private var _hpMask:Sprite;
		private var _mpMask:Sprite;
		private var _arcMask:Sprite;
		private var _angle:Number;
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
			
			_arcMask = new Sprite();
			_arcMask.graphics.beginFill(0xFF0000);
			_arcMask.scaleX = -1;
			_angle = 185;
			drawSector(_arcMask.graphics,_angle);
			BossBar.addChild(_arcMask);
			BossBar.mask=_arcMask;
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
				//TipsManager.getIns().addTips(hpBar, {title:"体力 " + useHp + "/" + totalHp, tips:""});
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
				//TipsManager.getIns().addTips(mpBar, {title:"元气 " + useMp + "/" + totalMp, tips:""});
			}
		}
		
		public function addBossCount(rate:Number) : void{
			if(rate <= 0){
				rate = 0;
			}else if(rate > 1){
				rate = 1;
			}
			_angle = 185 * rate;
			drawSector(_arcMask.graphics, _angle);
		}
		
		private function drawSector(g:Graphics,lAngle:Number,x:Number = -18, y:Number = 8, radius:Number = 30, sAngle:Number = 20):void{
			g.clear();
			g.beginFill(0xFF0000);
			var sx:Number = radius;
			var sy:Number = 0;
			if (sAngle != 0) {
				sx = Math.cos(sAngle * Math.PI/180) * radius;
				sy = Math.sin(sAngle * Math.PI/180) * radius;
			}
			g.moveTo(x, y);
			g.lineTo(x + sx, y +sy);
			var a:Number =  lAngle * Math.PI / 180 / lAngle;
			var cos:Number = Math.cos(a);
			var sin:Number = Math.sin(a);
			var b:Number = 0;
			for (var i:Number = 0; i < lAngle; i++) {
				var nx:Number = cos * sx - sin * sy;
				var ny:Number = cos * sy + sin * sx;
				sx = nx;
				sy = ny;
				g.lineTo(sx + x, sy + y);
			}
			g.lineTo(x, y);
			g.endFill();
		}
		
		public function upDataLevel(lv:int) : void{
			level.text = lv.toString();
		}
		
		public function resetState() : void{
			addBossCount(1);
			setParams();
		}
		
		public function get playerName():TextField{
			return layer["playerName"];
		}
		
		public function get level():TextField{
			return layer["level"];
		}
		
		public function get hpBar():Sprite{
			return layer["HpBar"];
		}
		
		public function get BossBar():Sprite{
			return layer["Assist"]["BossBar"];
		}
		
		public function get RoleHead():Sprite{
			return layer["RoleHead"];
		}
		
		public function get BossHead():Sprite{
			return layer["Assist"]["BossHead"];
		}
		
		public function get assist() : Sprite{
			return layer["Assist"];
		}
		
		public function get hpTF() : TextField{
			return layer["HpLayer"]["HpTF"];
		}
		
		public function get barRect() : Sprite{
			return layer["BarRect"];
		}
		private function get playerGameID() : TextField{
			return layer["playerGameID"]
		}
		public function get mpTF() : TextField{
			return layer["MpLayer"]["MpTF"];
		}
		public function get mpBar():Sprite{
			return layer["MpBar"];
		}
		
		override public function destroy():void{
			_mpMask = null;
			_hpMask = null;
			_arcMask = null;
			layer = null;
			super.destroy();
		}
	}
}