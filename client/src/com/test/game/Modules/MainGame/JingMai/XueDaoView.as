package com.test.game.Modules.MainGame.JingMai
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.JingMaiConst;
	import com.test.game.Const.NameHelper;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GlowAnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Configuration.JingMai;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class XueDaoView extends BaseView
	{

		private var jingMaiData:JingMai;
		private var type:String;
		private var maiIdx:int;
		private var xueDaoIconArr:Array;
		private var _glow:GlowAnimationEffect;
		private var _effect:BaseSequenceActionBind;
		
		public function XueDaoView()
		{
			renderView();
		}		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function renderView():void{
			
			LoadManager.getIns().hideProgress();
			layer = AssetsManager.getIns().getAssetObject("XueDaoView") as Sprite;
			layer.x = 220;
			layer.y = 30;
			this.addChild(layer);
			
			_glow = new GlowAnimationEffect();
			
			update();
			initBg();
			initEvent();
		}
		
		
		
		
		override public function show():void{
			if(layer == null) return;
			update();
			super.show();
		}
		
		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
		}
		

		
		override public function update():void{
			
		}
		
		
		public function setData(type:String):void{
			this.type = type;
			xueDaoIconArr = new Array();
			var idxArr:Array = this.type.split("mai");
			maiIdx = int(idxArr[1]);
			jingMaiData = ConfigurationManager.getIns().getObjectByID(
				AssetsConst.JINGMAI,maiIdx) as JingMai;
			maiTitle.gotoAndStop(this.type);
			xueDaoMc.gotoAndStop(this.type);
			initMcEvent();
			updateUI();
		}
		
		private function initMcEvent():void
		{
			
			for(var i:int=1;i<=jingMaiData.point_name.length;i++){
				(xueDaoMc[type+"v"+i] as MovieClip).buttonMode = true;
				(xueDaoMc[type+"v"+i] as MovieClip).addEventListener(MouseEvent.CLICK,onXueDao);
				
				var xueDaoIcon:MovieClip = AssetsManager.getIns().getAssetObject("XueDaoIcon") as MovieClip;
				xueDaoIcon.mouseChildren = false;
				xueDaoIcon.buttonMode = true;
				xueDaoIcon.nameTxt.text = jingMaiData.point_name[i-1];
				var content:String = 
					NameHelper.getPropertyName(jingMaiData.add_type[i-1])+"+"+jingMaiData.add_value[i-1];
				xueDaoIcon.addTxt.text = content;
				xueDaoIcon.x= 35;
				xueDaoIcon.y = 70+56*(i-1);
				layer.addChild(xueDaoIcon);
				//xueDaoIcon.addEventListener(MouseEvent.CLICK,onSelectIcon);
				xueDaoIconArr.push(xueDaoIcon);
			}	
		}
		
		protected function onSelectIcon(e:MouseEvent):void
		{
			for(var i:int=1;i<=jingMaiData.point_name.length;i++){
				if(xueDaoIconArr[i-1] == e.currentTarget){
					xueDaoIconArr[i-1].gotoAndStop(2);
					(xueDaoMc[type+"v"+i] as MovieClip).gotoAndStop(2);
				}else{
					if(player.jingMai.jingMaiArr[maiIdx-1]>=i){
						(xueDaoMc[type+"v"+i] as MovieClip).gotoAndStop(1);
					}else{
						(xueDaoMc[type+"v"+i] as MovieClip).gotoAndStop(3);
					}
					xueDaoIconArr[i-1].gotoAndStop(1);
				}
			}

		}
		
		private function updateUI():void
		{
			figureMc.gotoAndStop(player.occupation);
			pointTxt.text = player.jingMai.curPoint.toString();
			for(var i:int=1;i<=jingMaiData.point_name.length;i++){
				var name:String = jingMaiData.point_name[i-1];
				var addContent:String = 
					NameHelper.getPropertyName(jingMaiData.add_type[i-1])+"+"+jingMaiData.add_value[i-1];
				
				if(player.jingMai.jingMaiArr[maiIdx-1]>=i){
					TipsManager.getIns().addTips(xueDaoMc[type+"v"+i]
						,{title:name+"\n"+addContent+"\n(已打通)", tips:""});
					(xueDaoMc[type+"v"+i] as MovieClip).gotoAndStop(1);
					GreyEffect.reset(xueDaoIconArr[i-1]);
				}else{
					if(i==player.jingMai.jingMaiArr[maiIdx-1]+1){
						_glow.init(xueDaoMc[type+"v"+i]);
						_glow.start();
						(xueDaoMc[type+"v"+i] as MovieClip).gotoAndStop(2);
					}else{
						(xueDaoMc[type+"v"+i] as MovieClip).gotoAndStop(3);
					}
					TipsManager.getIns().addTips(xueDaoMc[type+"v"+i]
						,{title:name+"\n"+addContent+"\n(未打通)", tips:""});
					GreyEffect.change(xueDaoIconArr[i-1]);
				}
			}	
		}
		
		protected function onXueDao(e:MouseEvent):void
		{
			var idx:int = int(e.currentTarget.name.split("v")[1]);
			if(idx>player.jingMai.jingMaiArr[maiIdx-1]+1){
				(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
					"需要打通之前的穴道!");
				return;
			}else if(idx<player.jingMai.jingMaiArr[maiIdx-1]+1){
				return;
			}
			
			if(player.money<jingMaiData.gold){
				(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
					"金钱不足!");
				return;
			}
			
			if(player.soul<jingMaiData.gold){
				(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
					"战魂不足!");
				return;
			}
			
			if(player.jingMai.curPoint<=0){
				(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
					"潜能点不足!\n（潜能点可通过升级和重修之书获得）");
				return;
			}
			
			var addContent:String = 
				NameHelper.getPropertyName(jingMaiData.add_type[idx-1])+"+"+jingMaiData.add_value[idx-1];
			(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
				"打通穴道"+ColorConst.setLightBlue(jingMaiData.point_name[idx-1])
				+"\n"+ColorConst.setGold(addContent)
				+"\n花费1个潜能点、"+jingMaiData.gold+"金钱、"+jingMaiData.gold+"战魂",
				showEffect
			);
			GuideManager.getIns().jingMaiGuideSetting();
		}
		
		private function sureOpenXueDao():void{
			var arr:Array = player.jingMai.jingMaiArr;
			arr[maiIdx-1]++
			if(arr[maiIdx-1] == jingMaiData.point_name.length){
				var next:String = "";
				if(int(jingMaiData.next[0])!=0){
					for(var i:int = 0;i<jingMaiData.next.length;i++){
						if(i == jingMaiData.next.length-1){
							next += JingMaiConst.getJingMaiName(int(jingMaiData.next[i]))+"开启";
						}else{
							next += JingMaiConst.getJingMaiName(int(jingMaiData.next[i]))+"、";
						}
						var idx:int = int(jingMaiData.next[i])-1;
						arr[idx] = 0;
					}
				}

				(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
					ColorConst.setLightBlue(jingMaiData.name)+"完全打通!\n"
					+ColorConst.setLightBlue(next)
				);
			}
			player.jingMai.jingMaiArr = arr;
			PlayerManager.getIns().reduceMoney(jingMaiData.gold);
			PlayerManager.getIns().reduceSoul(jingMaiData.gold);
			PlayerManager.getIns().updatePropertys();

			_glow.stop();
			updateUI();
		}
		
		
		private function showEffect():void{
			_effect = AnimationEffect.createAnimation(10015,["attachEffect"],false,removeEffect)
			var idx:int = player.jingMai.jingMaiArr[maiIdx-1]+1
			_effect.x = xueDaoMc[type+"v"+idx].x + 220;
			_effect.y = xueDaoMc[type+"v"+idx].y + 78;
			layer.addChild(_effect);
			RenderEntityManager.getIns().removeEntity(_effect);
			AnimationManager.getIns().addEntity(_effect);
			
			GuideManager.getIns().jingMaiGuideSetting();
		}
		
		private function removeEffect(...args):void{
			if(_effect != null){
				AnimationManager.getIns().removeEntity(_effect);
				_effect.destroy();
				_effect = null;
			}
			sureOpenXueDao();
		}
		
		private function close(e:MouseEvent):void{
			GuideManager.getIns().jingMaiGuideSetting();
			ViewFactory.getIns().initView(JingMaiView).show();
			for(var i:int=1;i<=jingMaiData.point_name.length;i++){
				(xueDaoMc[type+"v"+i] as MovieClip).removeEventListener(MouseEvent.CLICK,onXueDao);
				xueDaoIconArr[i-1].removeEventListener(MouseEvent.CLICK,onSelectIcon);
				layer.removeChild(xueDaoIconArr[i-1]);
				xueDaoIconArr[i-1] = null;
			}
			this.hide();
			GuideManager.getIns().jingMaiGuideSetting();
		}
		
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		private function get figureMc():MovieClip
		{
			return layer["figureMc"];
		}
		
		private function get xueDaoMc():MovieClip
		{
			return layer["xueDaoMc"];
		}
		
		private function get maiTitle():MovieClip
		{
			return layer["maiTitle"];
		}
		
		private function get pointTxt():TextField
		{
			return layer["pointTxt"];
		}
		
		
		

		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		
		override public function destroy():void{
			if(closeBtn.hasEventListener(MouseEvent.CLICK)){
				closeBtn.removeEventListener(MouseEvent.CLICK,close);
			}
			super.destroy();
		}
	}
}