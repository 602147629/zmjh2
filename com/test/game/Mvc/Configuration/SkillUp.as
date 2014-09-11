package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class SkillUp extends BaseConfiguration
	{

		public function SkillUp()
		{	
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["skill_name"] = "";
			_anti["up_item"] = "";
			_anti["up_number"] = "";
			_anti["soul"] = 0;
			_anti["info"] = "";
			
			_anti["mp"] = 0;
			_anti["cooldown"] = 0;
			_anti["onlyhurt"] = 0;
			_anti["invincible"] = 0;
			_anti["atk_rate"] = 0;
			_anti["ats_rate"] = 0;
			_anti["attackIntervalFrame"] = 0;
			_anti["collisionRange"] = 0;
			_anti["buff_type"] = 0;
			_anti["buff_value"] = 0;
			_anti["shift_down"] = 0;
			_anti["syncope"] = 0;
			_anti["temptation"] = 0;
			_anti["release"] = 0;
			_anti["reduce_mp"] = 0;
			
			super();
		}
		
		private var _anti:Antiwear;
		
		
		override public function assign(data:Object):void{
			

			
			id = data.id;
			skill_name = data.skill_name;
			up_item = data.up_item;
			up_number = data.up_number;
			soul = data.soul;
			info = data.info;
			
			mp = data.mp;
			cooldown = data.cooldown;
			onlyhurt = data.onlyhurt;
			invincible = data.invincible;
			atk_rate = data.atk_rate;
			ats_rate = data.ats_rate;
			attackIntervalFrame = data.attackIntervalFrame;
			collisionRange = data.collisionRange;
			buff_type = data.buff_type;
			buff_value = data.buff_value;
			shift_down = data.shift_down;
			syncope = data.syncope;
			temptation = data.temptation;
			release = data.release;
			reduce_mp = data.reduce_mp;

		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		public function get skill_name() : String{
			return _anti["skill_name"];
		}
		public function set skill_name(value:String) : void{
			_anti["skill_name"] = value;
		}
	
		
		public function get up_item() : String{
			return _anti["up_item"];
		}
		public function set up_item(value:String) : void{
			_anti["up_item"] = value;
		}
		
		public function get up_number() : String{
			return _anti["up_number"];
		}
		public function set up_number(value:String) : void{
			_anti["up_number"] = value;
		}
		
		public function get soul() : int{
			return _anti["soul"];
		}
		public function set soul(value:int) : void{
			_anti["soul"] = value;
		}
		
		
		public function get info() : String{
			return _anti["info"];
		}
		public function set info(value:String) : void{
			_anti["info"] = value;
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

		public function get atk_rate() : String{
			return _anti["atk_rate"];
		}
		public function set atk_rate(value:String) : void{
			_anti["atk_rate"] = value;
		}
		
		public function get ats_rate() : String{
			return _anti["ats_rate"];
		}
		public function set ats_rate(value:String) : void{
			_anti["ats_rate"] = value;
		}
		
		public function get attackIntervalFrame() : String{
			return _anti["attackIntervalFrame"];
		}
		public function set attackIntervalFrame(value:String) : void{
			_anti["attackIntervalFrame"] = value;
		}

		public function get collisionRange() : String{
			return _anti["collisionRange"];
		}
		public function set collisionRange(value:String) : void{
			_anti["collisionRange"] = value;
		}
		
		public function get buff_type() : String{
			return _anti["buff_type"];
		}
		public function set buff_type(value:String) : void{
			_anti["buff_type"] = value;
		}
		
		public function get buff_value() : String{
			return _anti["buff_value"];
		}
		public function set buff_value(value:String) : void{
			_anti["buff_value"] = value;
		}
		
		public function get shift_down() : int{
			return _anti["shift_down"];
		}
		public function set shift_down(value:int) : void{
			_anti["shift_down"] = value;
		}

		public function get syncope() : int{
			return _anti["syncope"];
		}
		public function set syncope(value:int) : void{
			_anti["syncope"] = value;
		}
		
		public function get temptation() : int{
			return _anti["temptation"];
		}
		public function set temptation(value:int) : void{
			_anti["temptation"] = value;
		}
		
		public function get release() : int{
			return _anti["release"];
		}
		public function set release(value:int) : void{
			_anti["release"] = value;
		}
		
		public function get reduce_mp() : Number{
			return _anti["reduce_mp"];
		}
		public function set reduce_mp(value:Number) : void{
			_anti["reduce_mp"] = value;
		}
		

		
	}
}