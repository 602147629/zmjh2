package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class CharacterSkill extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function CharacterSkill(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["characte_name"] = "";
			_anti["skill_name"] = "";
			_anti["mp"] = 0;
			_anti["cooldown"] = 0;
			_anti["onlyhurt"] = 0;
			_anti["invincible"] = 0;
			_anti["info"] = "";
			_anti["kungfu"] = "";
			_anti["soul"] = 0;
		}
		
		override public function assign(data:Object) : void{
			id = data.id;
			character_name = data.character_name;
			skill_name = data.skill_name;
			mp = data.mp;
			cooldown = data.cooldown;
			onlyhurt = data.onlyhurt;
			invincible = data.invincible;
			info = data.info;
			kungfu = data.kungfu;
			soul = data.soul;
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		public function get character_name() : String{
			return _anti["character_name"];
		}
		public function set character_name(value:String) : void{
			_anti["character_name"] = value;
		}
		
		public function get skill_name() : String{
			return _anti["skill_name"];
		}
		public function set skill_name(value:String) : void{
			_anti["skill_name"] = value;
		}
		
		public function get mp() : int{
			return _anti["mp"];
		}
		public function set mp(value:int) : void{
			_anti["mp"] = value;
		}
		
		public function get cooldown() : int{
			return _anti["cooldown"];
		}
		public function set cooldown(value:int) : void{
			_anti["cooldown"] = value;
		}
		
		public function get onlyhurt() : int{
			return _anti["onlyhurt"];
		}
		public function set onlyhurt(value:int) : void{
			_anti["onlyhurt"] = value;
		}
		
		public function get invincible() : int{
			return _anti["invincible"];
		}
		public function set invincible(value:int) : void{
			_anti["invincible"] = value;
		}
		
		public function get info() : String{
			return _anti["info"];
		}
		public function set info(value:String) : void{
			_anti["info"] = value;
		}
		
		public function get kungfu() : String{
			return _anti["kungfu"];
		}
		public function set kungfu(value:String) : void{
			_anti["kungfu"] = value;
		}
		
		public function get soul() : int{
			return _anti["soul"];
		}
		public function set soul(value:int) : void{
			_anti["soul"] = value;
		}
	}
}