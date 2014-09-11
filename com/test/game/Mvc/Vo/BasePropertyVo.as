package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class BasePropertyVo extends BaseVO
	{
		
		
		private var _anti:Antiwear;
		
		public function BasePropertyVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			_anti["atk"]=0;
			_anti["def"]=0;
			_anti["ats"]=0;
			_anti["adf"]=0;
			_anti["hp"]=0;
			_anti["mp"]=0;
			_anti["hit"]=0;
			_anti["evasion"]=0;
			_anti["crit"]=0;
			_anti["toughness"]=0;
			_anti["spd"]=0;
			_anti["atk_spd"]=0;
			_anti["hp_regain"]=0;
			_anti["mp_regain"]=0;
			_anti["hurt_deepen"] = 0;
			_anti["hurt_reduce"] = 0;

			super();
		}
		
		public function init(data:Object) : void{
			atk = data.atk;
			def = data.def;
			ats = data.ats;
			adf = data.adf;
			hp = data.hp;
			mp = data.mp;
			hit = data.hit;
			evasion = data.evasion;
			crit = data.crit;
			toughness = data.toughness;
			spd = data.spd;
			atk_spd = data.atk_spd;
			hp_regain = data.hp_regain;
			mp_regain = data.mp_regain;
			hurt_deepen = data.hurt_deepen;
			hurt_reduce = data.hurt_reduce;
		}
		
		/**
		 * 攻击力
		 */
		public function get atk() : int
		{
			return _anti["atk"];
		}
		public function set atk(value:int) : void
		{
			_anti["atk"] = value;
		}
		
		
		/**
		 * 防御力
		 */
		public function get def() : int
		{
			return 	_anti["def"];
		}
		public function set def(value:int) : void
		{
			_anti["def"] = value;
		}
		
		/**
		 *技能攻击力 
		 */		

		public function get ats():int
		{
			return _anti["ats"];
		}

		public function set ats(value:int):void
		{
			_anti["ats"] = value;
		}
		
		
		/**
		 *技能防御力 
		 */		

		public function get adf():int
		{
			return _anti["adf"];
		}

		public function set adf(value:int):void
		{
			_anti["adf"] = value;
		}
			
		
		/**
		 * 魔力值
		 */
		public function get mp() : Number
		{
			return 	_anti["mp"];
		}
		public function set mp(value:Number) : void
		{
			_anti["mp"] = value;
		}
		
		
		/**
		 * 生命值
		 */
		public function set hp(value:Number) : void
		{
			_anti["hp"] = value;
		}
		public function get hp() : Number
		{
			return _anti["hp"];
		}
		
		
		
		/**
		 * 命中
		 */
		public function get hit() : Number
		{
			return _anti["hit"];
		}
		public function set hit(value:Number) : void
		{
			_anti["hit"] = value;
		}
		
		
		
		/**
		 * 闪避
		 */
		public function get evasion() : Number
		{
			return 	_anti["evasion"];
		}
		public function set evasion(value:Number) : void
		{
			_anti["evasion"] = value;
		}
		

		/**
		 * 暴击
		 */
		public function get crit() : Number
		{
			return 	_anti["crit"];
		}
		public function set crit(value:Number) : void
		{
			_anti["crit"] = value;
		}
		
		/**
		 * 抗暴
		 */
		public function get toughness() : Number
		{
			return 	_anti["toughness"];
		}
		public function set toughness(value:Number) : void
		{
			_anti["toughness"] = value;
		}
		
		
		/**
		 * 速度
		 */
		public function get spd() : Number
		{
			return 	_anti["spd"];
		}
		public function set spd(value:Number) : void
		{
			_anti["spd"] = value;
		}
		
		/**
		 * 攻击速度
		 */
		public function get atk_spd() : int
		{
			return 	_anti["atk_spd"];
		}
		public function set atk_spd(value:int) : void
		{
			_anti["atk_spd"] = value;
		}
		
		
		/**
		 * 生命恢复
		 */
		public function get hp_regain() : Number
		{
			return 	_anti["hp_regain"];
		}
		public function set hp_regain(value:Number) : void
		{
			_anti["hp_regain"] = value;
		}
		
		/**
		 * 魔力恢复
		 */
		public function get mp_regain() : Number
		{
			return 	_anti["mp_regain"];
		}
		public function set mp_regain(value:Number) : void
		{
			_anti["mp_regain"] = value;
		}
		
		//伤害加深
		public function get hurt_deepen() : Number{
			return _anti["hurt_deepen"];
		}
		public function set hurt_deepen(value:Number) : void{
			_anti["hurt_deepen"] = value;
		}
		
		//伤害减免
		public function get hurt_reduce() : Number{
			return _anti["hurt_reduce"];
		}
		public function set hurt_reduce(value:Number) : void{
			_anti["hurt_reduce"] = value;
		}


	}
}