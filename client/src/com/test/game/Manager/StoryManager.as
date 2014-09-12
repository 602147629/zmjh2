package com.test.game.Manager
{
	import com.greensock.TweenLite;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.TFStepEffect;
	import com.test.game.Modules.MainGame.LevelInfoView;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Mvc.BmdView.GameSenceView;
	import com.test.game.Mvc.Configuration.LevelStory;
	import com.test.game.Mvc.Vo.DungeonPassVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class StoryManager extends Singleton
	{
		private function get gsv() : GameSenceView{
			return (BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView);
		}
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		//是否开启剧情模式
		private var _startStoryControl:Boolean = true;
		public function get startStoryControl() : Boolean{
			return _startStoryControl;
		}
		public function set startStoryControl(value:Boolean) : void{
			_startStoryControl = value;
		}
		//出现Boss
		private var _bossAppear:Boolean = false;
		private var _bossAppearComplete:Boolean = false;
		private var _dialogueRight:MovieClip;
		private var _dialogueLeft:MovieClip;
		private var _bg:Bitmap;
		private var _roleHeadRight:Bitmap;
		private var _roleHeadLeft:Bitmap;
		private var _layer:Sprite;
		private var _stepTime:int;
		private var _stepCount:int;
		private var _info:LevelStory;
		private var _tfStepEffect:TFStepEffect;
		public function StoryManager(){
			super();
			init();
		}
		
		private function init():void{
			_roleHeadRight = new Bitmap(AUtils.getNewObj(PlayerManager.getIns().player.fodder + "_LittleHead") as BitmapData);
			_roleHeadRight.scaleX = .9;
			_roleHeadRight.scaleY = .9;
			_roleHeadRight.x = 20;
			_roleHeadRight.y = -12;
			_dialogueRight = AUtils.getNewObj("StoryDialogueRight") as MovieClip;
			_dialogueRight.addChild(_roleHeadRight);
			
			_roleHeadLeft = new Bitmap(AUtils.getNewObj(PlayerManager.getIns().player.fodder + "_LittleHead") as BitmapData);
			_roleHeadLeft.scaleX = .9;
			_roleHeadLeft.scaleY = .9;
			_roleHeadLeft.x = 18;
			_roleHeadLeft.y = -12;
			_dialogueLeft = AUtils.getNewObj("StoryDialogueRight") as MovieClip;
			_dialogueLeft.addChild(_roleHeadLeft);
			
			_bg = new Bitmap(AUtils.getNewObj("UIBg") as BitmapData);
			_bg.alpha = 0;
			
			_layer = new Sprite();
			_layer.addChild(_bg);
			_layer.addChild(_dialogueRight);
			_layer.addEventListener(MouseEvent.CLICK, onSkip);
			
			_tfStepEffect = new TFStepEffect();
		}
		
		public function get isStoryStart() : Boolean{
			if(_bossAppear && _startStoryControl){
				return true;
			}else{
				return false;
			}
		}
		
		//跳过剧情
		public function onSkip(event:MouseEvent = null):void{
			if(_bossAppear && _startStoryControl && _bossAppearComplete){
				if(_tfStepEffect.stepControl){
					_tfStepEffect.completeAll();
				}else{
					onNextDialogue();
				}
			}
		}
		
		public static function getIns():StoryManager{
			return Singleton.getIns(StoryManager);
		}
		
		public function initParams() : void{
			_startStoryControl = false;
			for each(var item:DungeonPassVo in player.dungeonPass){
				if(item.name == LevelManager.getIns().nowIndex){
					if(item.lv == NumberConst.getIns().negativeOne){
						_startStoryControl = true;
						break;
					}
				}
			}
		}
		
		public function step() : void{
			if(_bossAppear && _startStoryControl){
				if(_bossAppearComplete){
					/*_stepTime++;
					if(_stepTime == 30 * 5){
						onNextDialogue();
					}*/
					//_tfStepEffect.step();
				}else{
					setMonsterUnMove();
					setPlayerPosition();
					if(SceneManager.getIns().nowScene.x < -3500 && _stepTime >= 10){
						_bossAppearComplete = true;
						setDialogue();
					}
				}
			}
		}
		
		private function setPlayerPosition() : void{
			_stepTime++;
			for(var j:int = 0; j < gsv.players.length; j++){
				if(_stepTime < 10){
					gsv.players[j].moveRight();
				}
				if(gsv.players[j].y < 370){
					gsv.players[j].moveDown();
					gsv.players[j].setAction(ActionState.WALK);
				}else if(gsv.players[j].y > 380){
					gsv.players[j].moveUp();
					gsv.players[j].setAction(ActionState.WALK);
				}else{
					gsv.players[j].setAction(ActionState.WAIT);
				}
			}
		}
		
		private function onNextDialogue() : void{
			_stepCount++;
			if(_stepCount < 4){
				setDialogue();
			}else{
				clear();
				setMove();
				(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).levelTimeEffect.start();
			}
		}
		
		private function setMonsterUnMove() : void{
			for(var i:int = 0; i < gsv.monsters.length; i++){
				gsv.monsters[i].isLock = true;
			}
		}
		
		private function setMonsterHit() : void{
			for(var i:int = 0; i < gsv.monsters.length; i++){
				gsv.monsters[i].setAction(ActionState.HIT1);
			}
		}
		
		private function setPlayerUnMove() : void{
			for(var i:int = 0; i < gsv.players.length; i++){
				gsv.players[i].isLock = true;
				gsv.players[i].setAction(ActionState.WAIT);
			}
		}
		
		private function setMove() : void{
			for(var i:int = 0; i < gsv.monsters.length; i++){
				gsv.monsters[i].isLock = false;
			}
			for(var j:int = 0; j < gsv.players.length; j++){
				gsv.players[j].isLock = false;
			}
		}
		
		private function setDialogue():void{
			if(_layer.parent == null){
				LayerManager.getIns().gameTipLayer.addChild(_layer);
			}
			if(_dialogueLeft.parent != null){
				_dialogueLeft.parent.removeChild(_dialogueLeft);
			}
			if(_dialogueRight.parent != null){
				_dialogueRight.parent.removeChild(_dialogueRight);
			}
			switch(_stepCount){
				case 1:
					monsterWord();
					break;
				case 2:
					playerWord();
					break;
				case 3:
					setMonsterHit();
					TweenLite.delayedCall(.5, monsterWord);
					break;
			}
		}
		
		private function monsterWord() : void{
			var name:String;
			var content:String;
			_dialogueRight.x = 555;
			_dialogueRight.y = 270;
			_layer.addChild(_dialogueRight);
			name = LevelManager.getIns().levelData.boss_name;
			content = _info["Dialogue_" + _stepCount];
			_roleHeadRight.bitmapData = AUtils.getNewObj(LevelManager.getIns().levelData.fodder + "_LittleHead") as BitmapData;
			(_dialogueRight["DialogueName"] as TextField).text = name;
			(_dialogueRight["DialogueContent"] as TextField).text = "";
			_tfStepEffect.initParams((_dialogueRight["DialogueContent"] as TextField), content);
		}
		
		private function playerWord() : void{
			var name:String;
			var content:String;
			_dialogueLeft.x = 185;
			_dialogueLeft.y = 210;
			_layer.addChild(_dialogueLeft);
			name = PlayerManager.getIns().player.name;
			var arr:Array = _info["Dialogue_" + _stepCount].split("|");
			content = (PlayerManager.getIns().player.occupation==1?arr[0]:arr[1]);
			_roleHeadLeft.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "_LittleHead") as BitmapData;
			(_dialogueLeft["DialogueName"] as TextField).text = name;
			(_dialogueLeft["DialogueContent"] as TextField).text = "";
			_tfStepEffect.initParams((_dialogueLeft["DialogueContent"] as TextField), content);
		}
		
		public function judgeStartStory() : void{
			if(LevelManager.getIns().mapType == 1) return;
			for each(var item:DungeonPassVo in player.dungeonPass){
				if(item.name == LevelManager.getIns().nowIndex){
					if(item.lv == NumberConst.getIns().negativeOne){
						_bossAppear = true;
						LevelManager.getIns().storyStop = true;
						break;
					}
				}
			}
			if(_startStoryControl){
				_bossAppear = true;
				LevelManager.getIns().storyStop = true;
			}
			if(_bossAppear){
				_info = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.LEVEL_STORY, "level_id", LevelManager.getIns().nowIndex) as LevelStory;
				_stepTime = 0;
				_stepCount = 1;
				setMonsterUnMove();
				setPlayerUnMove();
				(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).levelTimeEffect.stop();
			}
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).skipUnEnabled();
		}
		
		public function clear() : void{
			_bossAppearComplete = false;
			_bossAppear = false;
			_stepTime = 0;
			_stepCount = 1;
			LevelManager.getIns().storyStop = false;
			if(_layer != null && _layer.parent != null){
				_layer.parent.removeChild(_layer);
			}
		}
	}
}