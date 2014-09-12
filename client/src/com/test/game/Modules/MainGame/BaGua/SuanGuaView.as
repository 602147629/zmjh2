package com.test.game.Modules.MainGame.BaGua
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.BaGuaManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	public class SuanGuaView extends BaseView
	{
		private static const up:int = 0;
		private static const right:int = 1;
		private static const down:int = 2;
		private static const left:int = 3;
		
		private static const orginX:int = 354;
		private static const orginY:int = 154;
		private static const range:int = 98;
		
		
		
		
		private var _obj:Sprite;
		
		private var BaGuaPieceArr:Array;
		
		private var size:int = 4;
		private var startTiles:int = 2;
		private var keepPlaying:Boolean;
		private var grid:SuanGuaIconGrid;
		private var won:Boolean;
		private var over:Boolean;
		private var stepTime:int;
		private var keyDown:Boolean;
		
		public function SuanGuaView()
		{
			renderView();
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		
		
		private function renderView():void{
			
			LoadManager.getIns().hideProgress();
			layer = AssetsManager.getIns().getAssetObject("SuanGuaView") as Sprite;
			this.addChild(layer);
			
			TipsManager.getIns().addTips(mingShuMc,{title:"命数：算卦合成卦象的时候获得的点数，可以累积点数抽取八卦牌",tips:""});
			TipsManager.getIns().addTips(restartBtn,{title:"点击重置将重新开始算卦",tips:""});
			
			update();
			
			initEvent();
		}
		

		
		override public function show():void{
			if(layer == null) return;
			//update();
			//GameConst.stage.addEventListener(KeyboardEvent.KEY_DOWN,suanGuaKeydown);
			keyDown = false;
            updateShowData();
			super.show();
		}

		private function close(e:MouseEvent):void{
			//clearAllTiles();
			//GameConst.stage.removeEventListener(KeyboardEvent.KEY_DOWN,suanGuaKeydown);
			this.hide();
			(ViewFactory.getIns().initView(BaGuaView) as BaGuaView).show();
			this.hide();
		}
		
		
		
		override public function update():void{
			reStartGame();
		}
		
		private function updateShowData():void
		{
			soulTxt.text = player.soul.toString();
			scoreTxt.text = player.baGuaScore.toString();
			stepTxt.text = this.stepTime.toString();
		}		
		

		
		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			restartBtn.addEventListener(MouseEvent.CLICK,sureReStart);
		}
			

		public function suanGuaKeydown(keyCode:uint):void
		{
			//DebugArea.getIns().showInfo("---keyCode:" + keyCode + "---keyDown:" + keyDown + "---Over:" + over + "---", DebugConst.NORMAL);
			if(player.soul>=NumberConst.getIns().suanGuaCost){
				if(keyDown==false && !this.over && !this.won){
					switch(keyCode){
						case Keyboard.UP:
							keyDown = true;
							move(up);
							break;
						case Keyboard.DOWN:
							keyDown = true;
							move(down);
							break;
						case Keyboard.LEFT:
							keyDown = true;
							move(left);
							break;
						case Keyboard.RIGHT:
							keyDown = true;
							move(right);
							break;
					}
				}
			}else{
				(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
					"战魂不足！请获得更多战魂后再来算卦");
			}
		}

		
		// Return true if the game is lost, or has won and the user hasn't kept playing
		private function get isGameTerminated():Boolean {
			if (this.over || (this.won && !this.keepPlaying)) {
				return true;
			} else {
				return false;
			}
		}
		
		// Set up the game
		private function reStartGame():void {
			
			this.grid        = new SuanGuaIconGrid(this.size);
			this.stepTime        = 0;
			this.over        = false;
			this.won         = false;
			this.keepPlaying = false;
			
			keyDown==false;
			BaGuaPieceArr = new Array();
			// Add the initial tiles
			if(player != null){
				soulTxt.text = player.soul.toString();
				scoreTxt.text = player.baGuaScore.toString();
				stepTxt.text = this.stepTime.toString();
			}
			addStartTiles();
		}
		
		// Set up the initial tiles to start the game with
		private function addStartTiles():void {
			for (var i:int = 0; i < this.startTiles; i++) {
				this.addRandomTile();
			}
		}
		
		// Adds a tile in a random position
		private function addRandomTile():void {
			if (this.grid.cellsAvailable) {
				var value:int = Math.random()>0.9?4:2;
				var tile:SuanGuaIcon = new SuanGuaIcon(this.grid.randomAvailableCell(), value);
				this.grid.insertTile(tile);
				tile.x = orginX+range*tile.posX;
				tile.y = orginY+range*tile.posY;
				layer.addChild(tile);
				tile.scaleX = 0.1;
				tile.scaleY = 0.1;
				TweenMax.to(tile,0.2,{scaleX:1,scaleY:1});
				
			}
		}


		
		// Save all tile positions and remove merger info
		private function prepareTiles():void {
			this.grid.eachCell(function (x:int, y:int, tile:SuanGuaIcon):void {
				if (tile) {
					tile.mergedFrom = null;
					tile.savePosition();
				}
			});
		}
		
		// Move a tile and its representation
		private function moveTile(tile:SuanGuaIcon, cell:Object):void {
			this.grid.cells[tile.posX][tile.posY] = null;
			this.grid.cells[cell.x][cell.y] = tile;
			tile.updatePosition(cell);
		}
		

		// Move tiles on the grid in the specified direction
		private function move(direction:int) :void{
			// 0: up, 1: right, 2: down, 3: left
			if (isGameTerminated) return; // Don't do anything if the game's over
			
			var cell:Object;
			var tile:SuanGuaIcon;
			
			var vector:Object     = this.getVector(direction);
			var traversals:Object = this.buildTraversals(vector);
			var moved:Boolean      = false;
			var moveAvailable:Boolean
			var index:int = 0;
			// Save the current tile positions and remove merger information
			this.prepareTiles();
			
			// Traverse the grid in the right direction and move tiles
			for(var x:int=0 ; x < traversals.x.length;x++){
				for(var y:int=0 ; y < traversals.y.length;y++){
					
					var merge:Boolean = false;
					cell = { x: traversals.x[x], y: traversals.y[y] };
					tile = this.grid.cellContent(cell);
					
					if (tile) {
						index++;
						var positions:Object = this.findFarthestPosition(cell, vector);
						var next:SuanGuaIcon      = this.grid.cellContent(positions.next);
						
						// Only one merger per row traversal?
						if (next && next.numValue === tile.numValue && !next.mergedFrom) {

							next.numValue = tile.numValue * 2;
							next.mergedFrom = [tile, next];
							TweenMax.fromTo(next,0.2,{scaleX:1.2,scaleY:1.2},{scaleX:1,scaleY:1});
							// Converge the two tiles' positions
							this.grid.removeTile(tile);
							index--;
							merge = true;
							tile.updatePosition(positions.next);
							
							checkScore(next);
							moveAvailable = true;
						} else {
							if(tile.posX !=  positions.farthest.x ||tile.posY !=  positions.farthest.y  ){
								moveAvailable = true;
							}
							this.moveTile(tile, positions.farthest);
						}
						
						//全部数组中最后一个移动完
						if (index == this.grid.num) {
							moved = true; // The tile moved from its original cell!
							
						}
						
						TweenMax.to(tile,0.2,{x:orginX+range*tile.posX,y:orginY+range*tile.posY,onComplete:moveComplete,onCompleteParams:[tile,merge,moved,moveAvailable]});
						
					}
				}
			}

		}
		
		/**
		 * 计算得分
		 * @param value
		 * 
		 */		
		private function checkScore(icon:SuanGuaIcon):void
		{
			var value:int = icon.numValue;
			player.baGuaScore += value/2;
			var bagState:int = BaGuaManager.getIns().checkFull();
			if(bagState>=0){
				if(value>=NumberConst.getIns().suanGuaBaseScore){
					addBaGuaPiece(value,icon.x,icon.y);
				}
				if(bagState==0){
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"八卦牌背包已满！请整理,否则无法获得八卦牌");
				}
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"八卦牌背包已满！请整理，否则无法获得八卦牌");
			}
		}
		
		private function addBaGuaPiece(value:int,x:int,y:int):void
		{
			var vo:BaGuaPieceVo;
			var baseScore:int = NumberConst.getIns().suanGuaBaseScore;
			switch(value){
				case baseScore:
					vo = BaGuaManager.getIns().addRandomBaguaPiece(0);
					break;
				case baseScore*2:
					vo = BaGuaManager.getIns().addRandomBaguaPiece(Math.floor(Math.random()*2));
					break;
				case baseScore*4:
					vo = BaGuaManager.getIns().addRandomBaguaPiece(1);
					break;
				case baseScore*8:
					vo = BaGuaManager.getIns().addRandomBaguaPiece(Math.floor(Math.random()*2)+1,true);
					this.won = true;
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"恭喜你算到最高的卦象！算卦结束。",sureReStart);
					break;
			}
			
			
			var piece:BaGuaPiece = new BaGuaPiece();
			piece.x = x - 25;
			piece.y = y - 25;
			piece.setData(vo);
			piece.dragable = false;
			if(BaGuaPieceArr.length==5){
				clearAllBaGuaPieces();
			}
			BaGuaPieceArr.push(piece);
			layer.addChild(piece);
			showEffect(x,y);
			piece.parent.setChildIndex(piece, piece.parent.numChildren - 1);
			TweenMax.to(piece,1.5,{ease:Cubic.easeInOut,x:793,y:160+(BaGuaPieceArr.length-1)*65});
		}
		
		private var effectArr:Array = new Array();
		private function showEffect(x:int,y:int):void{
			var _attachEffect:BaseSequenceActionBind = AnimationEffect.createAnimation(10015,["attachEffect"],false,removeEffect)
			_attachEffect.x = x - 60;
			_attachEffect.y = y - 60;
			layer.addChild(_attachEffect);
			effectArr.push(_attachEffect);
			RenderEntityManager.getIns().removeEntity(_attachEffect);
			AnimationManager.getIns().addEntity(_attachEffect);
		}
		
		private function removeEffect(...args):void{
			for(var i:int=0;i<effectArr.length;i++){
				if(effectArr[i].actionOver){
					AnimationManager.getIns().removeEntity(effectArr[i]);
					effectArr[i].destroy();
					effectArr[i]= null;
					effectArr.splice(effectArr.indexOf(effectArr[i]),1);
				}
			}

		}
		
		public function sureReStart(e:MouseEvent = null):void{
			clearAllTiles();
			clearAllBaGuaPieces();
			reStartGame();
		}
		
		
		/**
		 * 
		 * 卦象移动完毕
		 * 
		 */		
		private function moveComplete(...args):void{
			var tile:SuanGuaIcon = args[0];
			var merged:Boolean = args[1];
			var moved:Boolean = args[2];
			var moveAvailable:Boolean = args[3];
			if(tile && merged && tile.parent){
				tile.destroy();
				tile.parent.removeChild(tile);	
			}
			
			if (moved) {
				if (!this.movesAvailable()) {
					this.over = true; // Game over!
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"已无法获得新的卦象。请重新开始往更高的卦象努力吧！",sureReStart);
				}else if(moveAvailable){
					this.addRandomTile();
					this.stepTime++;
					PlayerManager.getIns().reduceSoul(NumberConst.getIns().suanGuaCost);
					updateShowData();
					
				}
			}
			keyDown = false;
		}

		// Get the vector representing the chosen direction
		private function getVector(direction):Object{
			// Vectors representing tile movement
			var map:Object = {
				0: { x: 0,  y: -1 }, // Up
				1: { x: 1,  y: 0 },  // Right
				2: { x: 0,  y: 1 },  // Down
				3: { x: -1, y: 0 }   // Left
			};
			
			return map[direction];
		}
		
		// Build a list of positions to traverse in the right order
		private function buildTraversals(vector:Object):Object {
			var traversals:Object = { x: [], y: [] };
			
			for (var pos:int = 0; pos < this.size; pos++) {
				traversals.x.push(pos);
				traversals.y.push(pos);
			}
			
			// Always traverse from the farthest cell in the chosen direction
			if (vector.x === 1) {
				traversals.x = traversals.x.reverse();
			}
			if (vector.y === 1) {
				traversals.y = traversals.y.reverse();
			}
			
			return traversals;
		}
		
		private function findFarthestPosition(cell:Object, vector:Object):Object {
			var previous:Object;
			
			// Progress towards the vector direction until an obstacle is found
			do {
				previous = cell;
				cell     = { x: previous.x + vector.x, y: previous.y + vector.y };
			} while (this.grid.withinBounds(cell) && this.grid.cellAvailable(cell))
			
			return {
				farthest: previous,
				next: cell // Used to check if a merge is required
			}
		}
		
		private function movesAvailable():Boolean {
			return this.grid.cellsAvailable || this.tileMatchesAvailable;
		}
		
		// Check for available matches between tiles (more expensive check)
		private function get tileMatchesAvailable():Boolean {

			var tile:Object;
			
			for (var x:int = 0; x < this.size; x++) {
				for (var y:int = 0; y < this.size; y++) {
					tile = this.grid.cellContent({ x: x, y: y });
					
					if (tile) {
						for (var direction:int = 0; direction < 4; direction++) {
							var vector:Object = this.getVector(direction);
							var cell:Object   = { x: x + vector.x, y: y + vector.y };
							
							var other:Object  = this.grid.cellContent(cell);
							
							if (other && other.numValue === tile.numValue) {
								return true; // These two tiles can be merged
							}
						}
					}
				}
			}
			
			return false;
		}
		
		

		private function clearAllTiles():void{
			this.grid.eachCell(function (x:int, y:int, tile:SuanGuaIcon):void {
				if(tile && tile.parent){
					tile.destroy();
					tile.parent.removeChild(tile);	
				}
				tile = null;
			});
		}
		
		private function clearAllBaGuaPieces():void{
			for(var i:int =0;i<BaGuaPieceArr.length;i++){
				if(BaGuaPieceArr[i].parent){
					BaGuaPieceArr[i].destroy();
					BaGuaPieceArr[i].parent.removeChild(BaGuaPieceArr[i]);	
				}
				BaGuaPieceArr[i] = null;
			}
			BaGuaPieceArr = [];
		}
		

		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		private function get soulTxt():TextField
		{
			return layer["soulTxt"];
		}
		
		private function get scoreTxt():TextField
		{
			return layer["scoreTxt"];
		}
		
		private function get stepTxt():TextField
		{
			return layer["stepTxt"];
		}
		
		private function get mingShuMc():Sprite
		{
			return layer["mingShuMc"];
		}
		
		private function get restartBtn():SimpleButton
		{
			return layer["restartBtn"];
		}

		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}

		
		override public function destroy():void{
			if(closeBtn.hasEventListener(MouseEvent.CLICK)){
				closeBtn.removeEventListener(MouseEvent.CLICK,close);;
			}
			super.destroy();
		}
	}
}