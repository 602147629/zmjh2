package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.MidConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Modules.MainGame.Role.RoleDetailView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Configuration.Title;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class TitleManager extends Singleton{

		public function TitleManager(){
			super();
		}
		
		public static function getIns():TitleManager{
			return Singleton.getIns(TitleManager);
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		//根据id获得称号
		public function addTitleById(id:int) : void{
			var titleData:Title = ConfigurationManager.getIns().getObjectByID(AssetsConst.TITLE,id) as Title;
			var titleArr:Array = player.titleInfo.titleOwned;
			var titleVo:ItemVo = PackManager.getIns().creatItem(titleData.id);
			titleArr.push(id);
			player.titleInfo.titleOwned = titleArr;
			(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
				"恭喜获得"+ColorConst.setLightBlue(titleData.name)+"称号,是否直接装备这个称号？"
				,function():void{
					putUpTitle(titleData.id);
				}
				,null
				,[titleVo]
			);
		}
		

		
		//检测称号是否已经获得
		public function checkTitleGet(id:int):Boolean{
			var result:Boolean = false;
			for each(var titleId:int in player.titleInfo.titleOwned){
				if(titleId == id){
					result = true;
				}
			}
			return result;
		}
		
		//装备称号
		public function putUpTitle(id:int):void{
			player.titleInfo.titleNow = id;
			PlayerManager.getIns().updatePropertys();
		}
		
		//卸下称号
		public function putDownTitle():void{
			player.titleInfo.titleNow = NumberConst.getIns().negativeOne;
			PlayerManager.getIns().updatePropertys();
			(ViewFactory.getIns().getView(RoleDetailView) as RoleDetailView).update();
		}
		
		//显示称号
		public function showTitle():void{
			player.titleInfo.titleShow = NumberConst.getIns().one;
		}
		
		//隐藏称号
		public function hideTitle():void{
			player.titleInfo.titleShow = NumberConst.getIns().zero;
		}
		
		/**
		 *副本通关时检测 
		 * 
		 */		
		public function checkDungeonPassTitles():void{
			checkFirstDungeonTitle();
			checkFirstEliteTitle();
			checkMoZhuLinClearTitle();
			checkFiftyJiTitle();
			checkGodTitle();
		}
		
		/**
		 *游戏登录时检测 
		 * 
		 */		
		public function checkLogInTitles():void{
			checkFirstDungeonTitle();
			checkFirstEliteTitle();
			checkMoZhuLinClearTitle();
			checkBattlePowerTitle();
			checkFiftyJiTitle();
			checkGoldBossTitle();
			checkMidAutumnTitle();
			checkPkKingTitle();
			checkGodTitle();
			
		}
		
		
		//初出江湖
		public function checkFirstDungeonTitle():void{
			if(!checkTitleGet(NumberConst.getIns().title_1)){
				for(var i:int =0;i<player.dungeonPass.length;i++){
					if(player.dungeonPass[i].lv > NumberConst.getIns().zero){
						addTitleById(NumberConst.getIns().title_1);
						break;
					}
				}	
			}
		}
		
		//初显锋芒
		public function checkFirstEliteTitle():void{
			if(!checkTitleGet(NumberConst.getIns().title_2)){
				for(var eliteIdx:int =0;eliteIdx<player.eliteDungeon.eliteDungeonPass.length;eliteIdx++){
					if(player.eliteDungeon.eliteDungeonPass[eliteIdx].lv > NumberConst.getIns().zero){
						addTitleById(NumberConst.getIns().title_2);
						break;
					}
				}
			}
		}
		
		//锋芒毕露
		public function checkMoZhuLinClearTitle():void{
			if(!checkTitleGet(NumberConst.getIns().title_3)){
				for(var i:int =0;i<player.dungeonPass.length;i++){
					if(player.dungeonPass[i].name == "2_1"){
						addTitleById(NumberConst.getIns().title_3);
						break;
					}
				}
			}
		}
		
		//行侠仗义
		public function checkBattlePowerTitle():void{
			if(!checkTitleGet(NumberConst.getIns().title_4)){
				if(PlayerManager.getIns().battlePower>=5*10000){
					addTitleById(NumberConst.getIns().title_4);	
				}
			}
		}
		
		//德高望重
		public function checkGoldBossTitle():void{
			if(!checkTitleGet(NumberConst.getIns().title_5)){
				for(var i:int =0;i<player.pack.boss.length;i++){
					if(player.pack.boss[i].lv > NumberConst.getIns().bossMaxLv){
						addTitleById(NumberConst.getIns().title_5);
						break;
					}
				}
			}
		}
		
		//绝世高手
		public function checkFiftyJiTitle():void{
			if(!checkTitleGet(NumberConst.getIns().title_6)){
				var jiNum:int;
				for(var i:int =0;i<player.dungeonPass.length;i++){
					if(player.dungeonPass[i].lv >= NumberConst.getIns().five){
						jiNum++;
					}
				}
				for(var eliteIdx:int =0;eliteIdx<player.eliteDungeon.eliteDungeonPass.length;eliteIdx++){
					if(player.eliteDungeon.eliteDungeonPass[eliteIdx].lv >= NumberConst.getIns().five){
						jiNum++;
					}
				}
				if(jiNum >= NumberConst.getIns().fifty){
					addTitleById(NumberConst.getIns().title_6);
				}
			}
		}
		
		//腰缠万贯
		public function checkVip6Title():void{
			if(!checkTitleGet(NumberConst.getIns().title_7)){
				if(ShopManager.getIns().vipLv >= 6){
					addTitleById(NumberConst.getIns().title_7);
				}
			}
		}
		
		//花好月圆
		public function checkMidAutumnTitle():void{
			if(!checkTitleGet(NumberConst.getIns().title_8)){

			}
		}
		
		//傲视天下
		public function checkPkKingTitle():void{
			if(!checkTitleGet(NumberConst.getIns().title_9)){
				if(player.pkInfo.pkWin >= 2000){
					addTitleById(NumberConst.getIns().title_9);
				}
			}
		}
		
		//神
		public function checkGodTitle():void{
			if(!checkTitleGet(NumberConst.getIns().title_10)){
				var result:Boolean = false;
				for(var i:int =0;i<player.dungeonPass.length;i++){
					if(player.dungeonPass[i].hit >= 9999){
						result = true;
					}
				}
				for(var eliteIdx:int =0;eliteIdx<player.eliteDungeon.eliteDungeonPass.length;eliteIdx++){
					if(player.eliteDungeon.eliteDungeonPass[eliteIdx].hit >= 9999){
						result = true;
					}
				}
				if(result){
					addTitleById(NumberConst.getIns().title_10);
				}
			}
		}
		
		

	}
}