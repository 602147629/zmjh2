package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class PackVo extends BaseVO
	{
		public function PackVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			super();
		}
		private var _anti:Antiwear;

		public function get allWithoutEquiped():Vector.<ItemVo>
		{
			var allItems:Vector.<ItemVo>= new Vector.<ItemVo>();
			allItems = allItems.concat(unEquip);
			allItems = allItems.concat(material);
			allItems = allItems.concat(special);
			allItems = allItems.concat(book);
			allItems = allItems.concat(prop);
			allItems = allItems.concat(fashionUnEquip);
			allItems = allItems.concat(bossUnEquip);
			return allItems;
		}
		
		public function get allWithouthEquiped() : Array{
			var result:Array = new Array();
			var i:int = 0;
			for(i = 0; i < unEquip.length; i++){
				result.push(unEquip[i].mid);
			}
			for(i = 0; i < material.length; i++){
				result.push(material[i].mid);
			}
			for(i = 0; i < special.length; i++){
				result.push(special[i].mid);
			}
			for(i = 0; i < book.length; i++){
				result.push(book[i].mid);
			}
			for(i = 0; i < prop.length; i++){
				result.push(prop[i].mid);
			}
			for(i = 0; i < fashionUnEquip.length; i++){
				result.push(fashionUnEquip[i].mid);
			}
			for(i = 0; i < bossUnEquip.length; i++){
				result.push(bossUnEquip[i].mid);
			}
			
			return result;
		}
		
		
		public function get materialTab():Vector.<ItemVo>
		{
			var materials:Vector.<ItemVo>= new Vector.<ItemVo>();
			materials = materials.concat(material);
			return materials;
		}

		
		public function get specialTab():Vector.<ItemVo>
		{
			var specials:Vector.<ItemVo>= new Vector.<ItemVo>();
			specials = specials.concat(special);
			specials = specials.concat(bossUnEquip);
			return specials;
		}
		
		public function get equipTab():Vector.<ItemVo>
		{
			var equips:Vector.<ItemVo>= new Vector.<ItemVo>();
			equips = equips.concat(unEquip);
			equips = equips.concat(fashionUnEquip);
			equips = equips.concat(book);
			return equips;
		}
		
		public function get propTab():Vector.<ItemVo>
		{
			var props:Vector.<ItemVo>= new Vector.<ItemVo>();
			props = props.concat(prop);
			return props;
		}
		
		
		private  var _equips:Vector.<ItemVo>;
		public function get equip():Vector.<ItemVo>
		{
			return _equips;
		}
		public function set equip(value:Vector.<ItemVo>):void
		{
			_equips = value;
		}
		
		public function get unEquip() : Vector.<ItemVo>
		{
			var unEquip:Vector.<ItemVo> = new Vector.<ItemVo>();
			
			for each(var equip:ItemVo in this.equip)
			{
				if (equip.mid>=0){
					unEquip.push(equip);
				}
			}
			return unEquip;
		}

		
		private  var _fashion:Vector.<ItemVo>;
		public function get fashion():Vector.<ItemVo>
		{
			return _fashion;
		}
		public function set fashion(value:Vector.<ItemVo>):void
		{
			_fashion = value;
		}
		
		public function get fashionUnEquip() : Vector.<ItemVo>
		{
			var unEquip:Vector.<ItemVo> = new Vector.<ItemVo>();
			
			for each(var fashion:ItemVo in this.fashion)
			{
				if (fashion.mid >= 0 ){
					unEquip.push(fashion);
				}
			}
			return unEquip;
		}
		
		
		private  var _materials:Vector.<ItemVo>;
		public function get material():Vector.<ItemVo>
		{
			return _materials;
		}
		public function set material(value:Vector.<ItemVo>):void
		{
			_materials = value;
		}
		
		
		private  var _specials:Vector.<ItemVo>;
		public function get special():Vector.<ItemVo>
		{
			return _specials;
		}
		public function set special(value:Vector.<ItemVo>):void
		{
			_specials = value;
		}
		
		
		private  var _books:Vector.<ItemVo>;
		public function get book():Vector.<ItemVo>
		{
			return _books;
		}
		public function set book(value:Vector.<ItemVo>):void
		{
			_books = value;
		}
		
		private  var _props:Vector.<ItemVo>;
		public function get prop():Vector.<ItemVo>
		{
			return _props;
		}
		public function set prop(value:Vector.<ItemVo>):void
		{
			_props = value;
		}
		
		
		private  var _bossCards:Vector.<ItemVo>;
		public function get boss():Vector.<ItemVo>
		{
			return _bossCards;
		}
		public function set boss(value:Vector.<ItemVo>):void
		{
			_bossCards = value;
		}
		
		private var _bossUnEquip:Vector.<ItemVo>;
		public function get bossUnEquip() : Vector.<ItemVo>
		{
			var unEquip:Vector.<ItemVo> = new Vector.<ItemVo>();
			
			for each(var boss:ItemVo in this.boss)
			{
				if (boss.mid >= 0 ){
					unEquip.push(boss);
				}
			}
			return unEquip;
		}
		
		
		private  var _packBoxs:Array;
		public function get packBoxs():Array
		{
			return _packBoxs;
		}
		public function set packBoxs(value:Array):void
		{
			_packBoxs = value;
		}
		
		
		public function get maxMid() : int
		{
			return 	_anti["maxMid"];
		}
		public function set maxMid(value:int) : void
		{
			_anti["maxMid"] = value;
		}
		
		
		public function get packUsed() : int
		{
			return 	_anti["packUsed"];
		}
		public function set packUsed(value:int) : void
		{
			_anti["packUsed"] = value;
		}
		
		public function get packMaxRoom() : int
		{
			return 	_anti["packMaxRoom"];
		}
		public function set packMaxRoom(value:int) : void
		{
			_anti["packMaxRoom"] = value;
		}
	}
}