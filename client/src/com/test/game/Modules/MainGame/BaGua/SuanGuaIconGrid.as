package com.test.game.Modules.MainGame.BaGua
{
	public class SuanGuaIconGrid
	{
		
		private var size:int;
		public var cells:Array;
		public var num:int;
		
		public function SuanGuaIconGrid(size:int, previousState:Array=null)
		{
			this.size = size;
			this.num = 0;
			this.cells = previousState ? fromState(previousState) : empty();
		}
		

		// Build a grid of the specified size
		private function empty():Array {
			var cells:Array = [];
			
			for (var x:int = 0; x < this.size; x++) {
				var row:Array = cells[x] = [];
				
				for (var y:int = 0; y < this.size; y++) {
					row.push(null);
				}
			}
			
			return cells;
		}
		
		private function fromState(state:Array) :Array{
			var cells:Array = [];
			
			for (var x:int = 0; x < this.size; x++) {
				var row:Array = cells[x] = [];
				
				for (var y:int = 0; y < this.size; y++) {
					var tile:SuanGuaIcon = state[x][y];
					row.push(tile ? new SuanGuaIcon(tile.position, tile.numValue) : null);
				}
			}
			
			return cells;
		}
		
		// Find the first available random position
		public function randomAvailableCell() :Object{
			
			var cells:Array = this.availableCells;
			if (cells.length>0) {
				return cells[Math.floor(Math.random() * cells.length)];
			}else{
				return null;
			}
		}
		
		private function get availableCells():Array{
			var cells:Array = [];
			
			this.eachCell(function (x:int, y:int, tile:SuanGuaIcon):void {
				if (!tile) {
					cells.push({ x: x, y: y });
				}
			});
			
			return cells;
		};
		
		// Call callback for every cell
		public function eachCell(callback):void {
			for (var x:int = 0; x < this.size; x++) {
				for (var y:int = 0; y < this.size; y++) {
					callback(x, y, this.cells[x][y]);
				}
			}
		};
		
		// Check if there are any cells available
		public function get cellsAvailable():Boolean {
			return !!this.availableCells.length;

		};
		
		// Check if the specified cell is taken
		public function cellAvailable(cell:Object):Boolean {
			return !this.cellOccupied(cell);
		};
		
		private function cellOccupied(cell:Object):Boolean {
			return !!this.cellContent(cell);
		};
		
		public function  cellContent(cell:Object):SuanGuaIcon {
			if (this.withinBounds(cell)) {
				return this.cells[cell.x][cell.y];
			} else {
				return null;
			}
		};
		
		// Inserts a tile at its position
		public function insertTile(tile:SuanGuaIcon):void {
			var orginTile:SuanGuaIcon = this.cells[tile.posX][tile.posY];
			this.cells[tile.posX][tile.posY] = tile;
			this.num ++;
		};
		
		public function removeTile(tile:SuanGuaIcon):void {
			this.cells[tile.posX][tile.posY] = null;
			this.num --;
			
		};
		
		public function withinBounds(position):Boolean {
			return position.x >= 0 && position.x < this.size &&
				position.y >= 0 && position.y < this.size;
		};
		
		public function serialize():Object{
			var cellState:Array = [];
			
			for (var x:int = 0; x < this.size; x++) {
				var row:Array = cellState[x] = [];
				
				for (var y:int = 0; y < this.size; y++) {
					row.push(this.cells[x][y] ? this.cells[x][y].serialize() : null);
				}
			}
			
			return {
				size: this.size,
				cells: cellState
			};
		};
	}
}