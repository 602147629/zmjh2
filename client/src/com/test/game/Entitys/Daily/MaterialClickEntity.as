package com.test.game.Entitys.Daily
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.DailyMissionFontEffect;
	import com.test.game.Entitys.Map.ItemIconEntity;
	import com.test.game.Manager.DigitalManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.StageClickManager;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.SimpleTips;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class MaterialClickEntity extends Sprite
	{
		private var _thing:BaseNativeEntity;
		private var _tool:BaseNativeEntity;
		private var _tips:SimpleTips;
		private var _map:BaseMapView;
		private var _point:Point;
		private var _id:int;
		private var _itemVo:ItemVo;
		private var _useItemVo:ItemVo;
		private var _tipShow:Boolean;
		public function MaterialClickEntity()
		{
			super();
			if(!_tips){
				_tips = ViewFactory.getIns().initView(SimpleTips) as SimpleTips;	
			}
			_tips.hide();
		}
		
		public function init(id:int):void{
			_id = id;
			_thing = new BaseNativeEntity();
			_thing.data.bitmapData = AUtils.getNewObj("Collection" + id) as BitmapData;
			StageClickManager.getIns().addClickThing(this, onClickThing, onClickOver, onClickOut);
			_thing.x = -_thing.width * .5;
			_thing.y = -_thing.height * .5;
			this.addChild(_thing);
			
			this.x = 1430 + 3100 * Math.random();
			this.y = 300 + Math.random() * 20;
			
			_point = new Point();
			_map = ViewFactory.getIns().getView(BaseMapView) as BaseMapView;
			
			_itemVo = PackManager.getIns().creatItem(_id);
			_itemVo.num = Math.ceil(Math.random()*NumberConst.getIns().three);
			
			_useItemVo = PackManager.getIns().creatItem(5000 + int((_id - 4100 + 1) / 2));
			_useItemVo.num = NumberConst.getIns().one;
		}
		
		private function initUnEnough():void{
			var fontFind:DailyMissionFontEffect = new DailyMissionFontEffect();
			fontFind.initFontEffect(this, "CollectionTool" + _useItemVo.id, new Point(0, -40));
		}
		
		private function initEnough() : void{
			var enoughFind:DailyMissionFontEffect = new DailyMissionFontEffect();
			enoughFind.initFontEffect(this, "CollectionComplete");
		}
		
		protected function onClickOver():void{
			_tips.show();
			_tipShow = true;
			_tips.x = _map.x + this.x + 10;
			_tips.y = this.y + 10;
			_tips.setData({title:"点击采集" + _itemVo.name, tips:"需要消耗一个" + _useItemVo.name + "。\n（南镇商铺贩卖）"});
		}
		
		protected function onClickOut():void{
			if(_tipShow){
				_tips.hide();
				_tipShow = false;
			}
		}
		
		protected function onClickThing():void{
			if(PackManager.getIns().searchItemNum(_useItemVo.id) > NumberConst.getIns().zero){
				initEnough();
				StageClickManager.getIns().removeClickThing(this);
				onClickOut();
				PackManager.getIns().addItemIntoPack(_itemVo);
				PackManager.getIns().reduceItem(_useItemVo.id, NumberConst.getIns().one);
				if(_thing.parent != null){
					_thing.parent.removeChild(_thing);
				}
				var iie:ItemIconEntity;
				iie = new ItemIconEntity(_itemVo.type + _itemVo.id, _itemVo.name, new Point(this.x, this.y), DigitalManager.getIns().getOneStauts());
				SceneManager.getIns().nowScene.addChild(iie);
			}else{
				initUnEnough();
			}
		}
		
		public function step() : void{
			
		}
		
		public function destroy() : void{
			if(_thing != null){
				_thing.destroy();
				_thing = null;
			}
			if(_tool != null){
				_tool.destroy();
				_tool = null;
			}
			_tips = null;
			_map = null;
			_itemVo = null;
			_useItemVo = null;
		}
		
	}
}