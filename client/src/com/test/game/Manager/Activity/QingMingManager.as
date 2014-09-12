package com.test.game.Manager.Activity
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.Map.ItemIconEntity;
	import com.test.game.Manager.Extra.DoubleDungeonManager;
	import com.test.game.Modules.MainGame.GameOverView;
	import com.test.game.Mvc.Vo.EnemyVo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DigitalManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SceneManager;
	
	public class QingMingManager extends Singleton
	{
		private var startCreate:Boolean = true;
		private static const LITTLE_APPEAR_RATE:Number = 1 / (2 * 60 * 60 * 12);
		private static const LARGE_APPEAR_RATE:Number = 1 / (2 * 60 * 30);
		private function get gameOverView() : GameOverView{
			return ViewFactory.getIns().getView(GameOverView) as GameOverView;
		}
		public function QingMingManager(){
			super();
		}
		
		public static function getIns():QingMingManager{
			return Singleton.getIns(QingMingManager);
		}
		
		private var _stepCount:int = 0;
		public function step() : void{
			if(startCreate){
				_stepCount++;
				if(_stepCount >= 30){
					if(gameOverView != null &&　!gameOverView.isClose) return;
					if(!((LevelManager.getIns().nowIndex == "1_1"
						|| LevelManager.getIns().nowIndex == "1_2"
						|| LevelManager.getIns().nowIndex == "1_3")
						&& LevelManager.getIns().mapType == 0)){
						var random:Number = Math.random();
						if(random <= LITTLE_APPEAR_RATE){
							LevelManager.getIns().createQingMingMonster(2020);
						}else if(random <= LARGE_APPEAR_RATE){
							LevelManager.getIns().createQingMingMonster(1020);
						}
					}
					_stepCount = 0;
				}
			}
		}
		
		public function addQingMingItem(monster:MonsterEntity) : void{
			var fodder:String = "";
			var itemName:String = "";
			var monsterID:int = (monster.charData as EnemyVo).ID;
			var itemVo:ItemVo;
			if(monsterID == 1020){
				var lv:int = SceneManager.getIns().nowScene["myPlayer"].player.character.lv;
				var money:int = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.PLAYER, "lv", lv).dailygold;
				fodder = "WeatherMoney";
				itemName = NumberConst.numTranslate(money);
				PlayerManager.getIns().checkAdd("zombie_money",money,5*10000);
				PlayerManager.getIns().addMoney(money);
			}else if(monsterID == 2020){
				var arr:Array = ConfigurationManager.getIns().getSearchByProperty(AssetsConst.BLACK_MARKET, "type", 1);
				itemVo = PackManager.getIns().creatItem(arr[int(Math.random() * arr.length)].id);
				itemVo.num = getMaterialNum;
				PackManager.getIns().addItemIntoPack(itemVo);
				fodder = itemVo.type + itemVo.id;
				itemName = itemVo.name;
			}
			if(fodder != ""){
				var iie:ItemIconEntity;
				if(itemVo != null){
					for(var i:int = 0; i < itemVo.num; i++){
						iie = new ItemIconEntity(fodder, itemName, monster.bodyPos, DigitalManager.getIns().getOneStauts());
						SceneManager.getIns().nowScene.addChild(iie);
					}
				}else{
					iie = new ItemIconEntity(fodder, itemName, monster.bodyPos, DigitalManager.getIns().getOneStauts());
					SceneManager.getIns().nowScene.addChild(iie);
				}
			}
		}
		
		public function get getMaterialNum() : int{
			var result:int = NumberConst.getIns().one;
			if(DoubleDungeonManager.getIns().isInDoubleDungeon){
				result += NumberConst.getIns().one;
			}
			return result;
		}
	}
}