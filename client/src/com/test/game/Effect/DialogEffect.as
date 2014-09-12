package com.test.game.Effect
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Manager.Layers.LayerManager;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class DialogEffect extends BaseEffect
	{
		private static var _layer:Sprite;
		private static var _dialogue:Sprite;
		private static var _roleHead:BaseNativeEntity;
		private static var _tfStep:DelayTFStepEffect;
		private static var _callback:Function;
		private static var _showMC:MovieClip;
		public function DialogEffect()
		{
			super();
			
		}
		
		public static function init(type:int, callback:Function) : void{
			_callback = callback;
			switch(type){
				case 1:
					dialogue1_1();
					break;
				case 2:
					dialogue2_1();
					break;
				case 3:
					dialogue3_1();
					break;
				case 4:
					dialogue4_1();
					break;
			}
		}
		
		public static function configurate(xPos:int, yPos:int, fodder:String, name:String, detail:String, callback:Function) : void{
			if(_dialogue == null){
				_dialogue = AUtils.getNewObj("StoryDialogueRight") as Sprite;
				_roleHead = new BaseNativeEntity();
				_roleHead.scaleX = .9;
				_roleHead.scaleY = .9;
				_roleHead.x = 15;
				_roleHead.y = -13;
				_dialogue.addChild(_roleHead);
			}
			if(_tfStep == null){
				_tfStep = new DelayTFStepEffect();
			}
			if(_dialogue.parent == null){
				LayerManager.getIns().gameTipLayer.addChild(_dialogue);
			}
			_dialogue.x = xPos;
			_dialogue.y = yPos;
			(_dialogue["DialogueName"] as TextField).text = name;
			(_dialogue["DialogueContent"] as TextField).text = "";
			_roleHead.data.bitmapData = AUtils.getNewObj(fodder + "_LittleHead") as BitmapData;
			_tfStep.initParams((_dialogue["DialogueContent"] as TextField), detail, callback);
		}
		
		private static function dialogue1_1() : void{
			configurate(130, 190, "KuangWu", "狂武", "打完收工。", dialogue1_2);
		}
		private static function dialogue1_2() : void{
			configurate(590, 260, "XiaoYao", "逍遥", "这么菜也跑来混江湖，回去练个十年再来挑战本少爷吧！", dialogue1_3);
		}
		private static function dialogue1_3() : void{
			configurate(300, 70, "WuXiangShiZhe", "？？？", "啊哈哈哈哈，会些花拳绣腿就自以为是！真是笑死人了！", dialogue1_4);
		}
		private static function dialogue1_4() : void{
			configurate(130, 190, "KuangWu", "狂武", "谁？！", dialogueComplete);
		}
		
		private static function dialogue2_1() : void{
			configurate(160, 290, "XiaoYao", "逍遥", "竟然偷袭我！你是谁！", dialogue2_2);
			_showMC = AUtils.getNewObj("CartoonBoss") as MovieClip;
			_showMC.x = 681;
			_showMC.y = 357;
			LayerManager.getIns().gameTipLayer.addChild(_showMC);
		}
		private static function dialogue2_2() : void{
			configurate(550, 260, "WuXiangShiZhe", "无相使者", "本座乃是无相使者！你们天资不错，不如当我的小弟，随我统一江湖吧！", dialogue2_3);
		}
		private static function dialogue2_3() : void{
			configurate(160, 290, "XiaoYao", "逍遥", "要本公子当小弟？不拿盆水照照你自己的样子。", dialogue2_4);
		}
		private static function dialogue2_4() : void{
			configurate(10, 190, "KuangWu", "狂武", "邪魔歪道，来战！", dialogue2_5);
		}
		private static function dialogue2_5() : void{
			configurate(550, 260, "WuXiangShiZhe", "无相使者", "哼，不识好歹！见识无相神功的厉害吧！", dialogueComplete);
		}
		
		private static function dialogue3_1() : void{
			configurate(550, 260, "WuXiangShiZhe", "无相使者", "哼哼哼，连一击都承受不住。想打败本座的话就去集齐十大至宝吧。哈哈哈哈哈！", dialogueComplete);
			_showMC = AUtils.getNewObj("CartoonCharacter") as MovieClip;
			_showMC.x = 93;
			_showMC.y = 313;
			LayerManager.getIns().gameTipLayer.addChild(_showMC);
		}
		
		private static function dialogue4_1() : void{
			configurate(10, 190, "KuangWu", "狂武", "邪魔高手，若不提升，实难胜之。", dialogue4_2);
		}
		private static function dialogue4_2() : void{
			configurate(160, 290, "XiaoYao", "逍遥", "哼！此仇不报非君子！听说墨竹林有至宝的消息，能使人功力大增！我们走！", dialogueComplete);
		}
		
		private static function dialogueComplete() : void{
			if(_showMC != null){
				if(_showMC.parent != null){
					_showMC.parent.removeChild(_showMC);
				}
			}
			if(_dialogue != null && _dialogue.parent != null){
				_dialogue.parent.removeChild(_dialogue);
			}
			if(_callback != null){
				_callback();
			}
		}
		
		public static function clear() : void{
			_callback = null;
			if(_tfStep != null){
				_tfStep.completeAll();
			}
			dialogueComplete();
		}
	}
}