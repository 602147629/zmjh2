package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class EnemySkill extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function EnemySkill(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["source"] = "";
			_anti["sid"] = 0;
			_anti["hurt"] = 0;
			_anti["durationFrame"] = 0;
			_anti["attackIntervalFrame"] = 0;
			_anti["unActionFrame"] = 0;
			_anti["hurtTime"] = 0;
			_anti["hurtMoveType"] = 0;
			_anti["skillMoveType"] = 0;
			_anti["xPos"] = 0;
			_anti["yPos"] = 0;
			_anti["zPos"] = 0;
			_anti["skillMoveX"] = 0;
			_anti["skillMoveY"] = 0;
			_anti["skillMoveZ"] = 0;
			_anti["hurtMoveX"] = 0;
			_anti["hurtMoveY"] = 0;
			_anti["hurtMoveZ"] = 0;
			_anti["roleMoveX"] = 0;
			_anti["roleMoveY"] = 0;
			_anti["roleMoveZ"] = 0;
			_anti["handX"] = 0;
			_anti["handY"] = 0;
			_anti["handZ"] = 0;
			_anti["collisionRange"] = 0;
			_anti["isHurt"] = 0;
			_anti["attackType"] = 0;
			_anti["fallDownHurt"] = 0;
			_anti["skillProperty"] = 0;
			_anti["atk_hurt"] = 0;
			_anti["atk_rate"] = 0;
			_anti["ats_hurt"] = 0;
			_anti["ats_rate"] = 0;
			_anti["chaos_hurt"] = 0;
			_anti["nid"] = 0;
			_anti["continue_skill"] = "";
			_anti["continue_pos_x"] = "";
			_anti["continue_pos_y"] = "";
			_anti["continue_pos_z"] = "";
			_anti["isDouble"] = 0;
			_anti["rotation"] = 0;
			_anti["appoint_frame"] = "";
			_anti["appoint_skill"] = "";
			_anti["locate_frame"] = 0;
			_anti["locate_distance"] = 0;
			_anti["hp_rate"] = 0;
			_anti["target_buff_type"] = "";
			_anti["target_buff_value"] = "";
		}
		
		override public function assign(data:Object) : void{
			id = data.id;
			sid = data.sid;
			name = data.name;
			source = data.source;
			hurt = data.hurt;
			durationFrame = data.durationFrame;
			attackIntervalFrame = data.attackIntervalFrame;
			unActionFrame = data.unActionFrame;
			hurtTime = data.hurtTime;
			hurtMoveType = data.hurtMoveType;
			skillMoveType = data.skillMoveType;
			xPos = data.xPos;
			yPos = data.yPos;
			zPos = data.zPos;
			skillMoveX = data.skillMoveX;
			skillMoveY = data.skillMoveY;
			skillMoveZ = data.skillMoveZ;
			hurtMoveX = data.hurtMoveX;
			hurtMoveY = data.hurtMoveY;
			hurtMoveZ = data.hurtMoveZ;
			roleMoveX = data.roleMoveX;
			roleMoveY = data.roleMoveY;
			roleMoveZ = data.roleMoveZ;
			handX = data.handX;
			handY = data.handY;
			handZ = data.handZ;
			collisionRange  = data.collisionRange;
			isHurt = data.isHurt;
			attackType = data.attackType;
			fallDownHurt = data.fallDownHurt;
			skillProperty = data.skillProperty;
			atk_hurt = data.atk_hurt;
			atk_rate = data.atk_rate;
			ats_hurt = data.ats_hurt;
			ats_rate = data.ats_rate;
			chaos_hurt = data.chaos_hurt;
			nid = data.nid;
			continue_skill = data.continue_skill;
			continue_pos_x = data.continue_pos_x;
			continue_pos_y = data.continue_pos_y;
			continue_pos_z = data.continue_pos_z;
			isDouble = data.isDouble;
			rotation = data.rotation;
			appoint_frame = data.appoint_frame;
			appoint_skill = data.appoint_skill;
			isRepeat = data.isRepeat;
			locate_frame = data.locate_frame;
			locate_distance = data.locate_distance;
			hp_rate = data.hp_rate;
			target_buff_type = data.target_buff_type;
			target_buff_value = data.target_buff_value;
		}
		
		public function copy() : EnemySkill{
			var data:EnemySkill = new EnemySkill();
			data.id = id;
			data.sid = sid;
			data.name = name;
			data.source = source;
			data.hurt = hurt;
			data.durationFrame = durationFrame;
			data.attackIntervalFrame = attackIntervalFrame;
			data.unActionFrame = unActionFrame;
			data.hurtTime = hurtTime;
			data.hurtMoveType = hurtMoveType;
			data.skillMoveType = skillMoveType;
			data.xPos = xPos;
			data.yPos = yPos;
			data.zPos = zPos;
			data.skillMoveX = skillMoveX;
			data.skillMoveY = skillMoveY;
			data.skillMoveZ = skillMoveZ;
			data.hurtMoveX = hurtMoveX;
			data.hurtMoveY = hurtMoveY;
			data.hurtMoveZ = hurtMoveZ;
			data.roleMoveX = roleMoveX;
			data.roleMoveY = roleMoveY;
			data.roleMoveZ = roleMoveZ;
			data.handX = handX;
			data.handY = handY;
			data.handZ = handZ;
			data.collisionRange  = collisionRange;
			data.isHurt = isHurt;
			data.attackType = attackType;
			data.fallDownHurt = fallDownHurt;
			data.skillProperty = skillProperty;
			data.atk_hurt = atk_hurt;
			data.atk_rate = atk_rate;
			data.ats_hurt = ats_hurt;
			data.ats_rate = ats_rate;
			data.chaos_hurt = chaos_hurt;
			data.nid = nid;
			data.continue_skill = continue_skill;
			data.continue_pos_x = continue_pos_x;
			data.continue_pos_y = continue_pos_y;
			data.continue_pos_z = continue_pos_z;
			data.isDouble = isDouble;
			data.rotation = rotation;
			data.appoint_frame = appoint_frame;
			data.appoint_skill = appoint_skill;
			data.isRepeat = isRepeat;
			data.locate_frame = locate_frame;
			data.locate_distance = locate_distance;
			data.hp_rate = hp_rate;
			data.target_buff_type = target_buff_type;
			data.target_buff_value = target_buff_value;
			return data;
		}
		
		public var id:int;
		public var name:String;
		public function get source() : String{
			return _anti["source"];
		}
		public function set source(value:String) : void{
			_anti["source"] = value;
		}
		
		public function get sid() : int{
			return _anti["sid"];
		}
		public function set sid(value:int) : void{
			_anti["sid"] = value;
		}
		
		public function get hurt() : int{
			return _anti["hurt"];
		}
		public function set hurt(value:int) : void{
			_anti["hurt"] = value;
		}
		
		public function get durationFrame() : int{
			return _anti["durationFrame"];
		}
		public function set durationFrame(value:int) : void{
			_anti["durationFrame"] = value;
		}
		
		public function get attackIntervalFrame() : int{
			return _anti["attackIntervalFrame"];
		}
		public function set attackIntervalFrame(value:int) : void{
			_anti["attackIntervalFrame"] = value;
		}
		
		public function get unActionFrame() : int{
			return _anti["unActionFrame"];
		}
		public function set unActionFrame(value:int) : void{
			_anti["unActionFrame"] = value;
		}
		
		public function get hurtTime() : int{
			return _anti["hurtTime"];
		}
		public function set hurtTime(value:int) : void{
			_anti["hurtTime"] = value;
		}
		
		public function get hurtMoveType() : int{
			return _anti["hurtMoveType"];
		}
		public function set hurtMoveType(value:int) : void{
			_anti["hurtMoveType"] = value;
		}
		
		public function get skillMoveType() : int{
			return _anti["skillMoveType"];
		}
		public function set skillMoveType(value:int) : void{
			_anti["skillMoveType"] = value;
		}
		
		public function get xPos() : int{
			return _anti["xPos"];
		}
		public function set xPos(value:int) : void{
			_anti["xPos"] = value;
		}
		
		public function get yPos() : int{
			return _anti["yPos"];
		}
		public function set yPos(value:int) : void{
			_anti["yPos"] = value;
		}
		
		public function get zPos() : int{
			return _anti["zPos"];
		}
		public function set zPos(value:int) : void{
			_anti["zPos"] = value;
		}
		
		public function get skillMoveX() : Number{
			return _anti["skillMoveX"];
		}
		public function set skillMoveX(value:Number) : void{
			_anti["skillMoveX"] = value;
		}
		
		public function get skillMoveY() : Number{
			return _anti["skillMoveY"];
		}
		public function set skillMoveY(value:Number) : void{
			_anti["skillMoveY"] = value;
		}
		
		public function get skillMoveZ() : Number{
			return _anti["skillMoveZ"];
		}
		public function set skillMoveZ(value:Number) : void{
			_anti["skillMoveZ"] = value;
		}
		
		public function get hurtMoveX() : Number{
			return _anti["hurtMoveX"];
		}
		public function set hurtMoveX(value:Number) : void{
			_anti["hurtMoveX"] = value;
		}
		
		public function get hurtMoveY() : Number{
			return _anti["hurtMoveY"];
		}
		public function set hurtMoveY(value:Number) : void{
			_anti["hurtMoveY"] = value;
		}
		
		public function get hurtMoveZ() : Number{
			return _anti["hurtMoveZ"];
		}
		public function set hurtMoveZ(value:Number) : void{
			_anti["hurtMoveZ"] = value;
		}
		
		public function get roleMoveX() : Number{
			return _anti["roleMoveX"];
		}
		public function set roleMoveX(value:Number) : void{
			_anti["roleMoveX"] = value;
		}
		
		public function get roleMoveY() : Number{
			return _anti["roleMoveY"];
		}
		public function set roleMoveY(value:Number) : void{
			_anti["roleMoveY"] = value;
		}
		
		public function get roleMoveZ() : Number{
			return _anti["roleMoveZ"];
		}
		public function set roleMoveZ(value:Number) : void{
			_anti["roleMoveZ"] = value;
		}
		
		public function get handX() : Number{
			return _anti["handX"];
		}
		public function set handX(value:Number) : void{
			_anti["handX"] = value;
		}
		
		public function get handY() : Number{
			return _anti["handY"];
		}
		public function set handY(value:Number) : void{
			_anti["handY"] = value;
		}
		
		public function get handZ() : Number{
			return _anti["handZ"];
		}
		public function set handZ(value:Number) : void{
			_anti["handZ"] = value;
		}
		
		public function get collisionRange() : int{
			return _anti["collisionRange"];
		}
		public function set collisionRange(value:int) : void{
			_anti["collisionRange"] = value;
		}
		
		public function get isHurt() : int{
			return _anti["isHurt"];
		}
		public function set isHurt(value:int) : void{
			_anti["isHurt"] = value;
		}
		
		public function get attackType() : int{
			return _anti["attackType"];
		}
		public function set attackType(value:int) : void{
			_anti["attackType"] = value;
		}
		
		public function get fallDownHurt() : int{
			return _anti["fallDownHurt"];
		}
		public function set fallDownHurt(value:int) : void{
			_anti["fallDownHurt"] = value;
		}
		
		public function get skillProperty() : int{
			return _anti["skillProperty"];
		}
		public function set skillProperty(value:int) : void{
			_anti["skillProperty"] = value;
		}
		
		public function get atk_hurt() : int{
			return _anti["atk_hurt"];
		}
		public function set atk_hurt(value:int) : void{
			_anti["atk_hurt"] = value;
		}
		
		public function get atk_rate() : int{
			return _anti["atk_rate"];
		}
		public function set atk_rate(value:int) : void{
			_anti["atk_rate"] = value;
		}
		
		public function get ats_hurt() : int{
			return _anti["ats_hurt"];
		}
		public function set ats_hurt(value:int) : void{
			_anti["ats_hurt"] = value;
		}
		
		public function get ats_rate() : int{
			return _anti["ats_rate"];
		}
		public function set ats_rate(value:int) : void{
			_anti["ats_rate"] = value;
		}
		
		public function get chaos_hurt() : int{
			return _anti["chaos_hurt"];
		}
		public function set chaos_hurt(value:int) : void{
			_anti["chaos_hurt"] = value;
		}
		
		public function get nid() : int{
			return _anti["nid"];
		}
		public function set nid(value:int) : void{
			_anti["nid"] = value;
		}
		
		public function get continue_skill() : String{
			return _anti["continue_skill"];
		}
		public function set continue_skill(value:String) : void{
			_anti["continue_skill"] = value;
		}
		
		public function get continue_pos_x() : String{
			return _anti["continue_pos_x"];
		}
		public function set continue_pos_x(value:String) : void{
			_anti["continue_pos_x"] = value
		}
		
		public function get continue_pos_y() : String{
			return _anti["continue_pos_y"];
		}
		public function set continue_pos_y(value:String) : void{
			_anti["continue_pos_y"] = value
		}
		
		public function get continue_pos_z() : String{
			return _anti["continue_pos_z"];
		}
		public function set continue_pos_z(value:String) : void{
			_anti["continue_pos_z"] = value
		}
		
		public function get isDouble() : int{
			return _anti["isDouble"];
		}
		public function set isDouble(value:int) : void{
			_anti["isDouble"] = value;
		}
		
		public function get rotation() : Number{
			return _anti["rotation"];
		}
		public function set rotation(value:Number) : void{
			_anti["rotation"] = value;
		}
		
		public function get appoint_frame() : String{
			return _anti["appoint_frame"];
		}
		public function set appoint_frame(value:String) : void{
			_anti["appoint_frame"] = value
		}
		
		public function get appoint_skill() : String{
			return _anti["appoint_skill"];
		}
		public function set appoint_skill(value:String) : void{
			_anti["appoint_skill"] = value
		}
		
		public function get isRepeat() : int{
			return _anti["isRepeat"];
		}
		public function set isRepeat(value:int) : void{
			_anti["isRepeat"] = value;
		}
		
		public function get locate_frame() : int{
			return _anti["locate_frame"];
		}
		public function set locate_frame(value:int) : void{
			_anti["locate_frame"] = value;
		}
		
		public function get locate_distance() : int{
			return _anti["locate_distance"];
		}
		public function set locate_distance(value:int) : void{
			_anti["locate_distance"] = value;
		}
		
		public function get hp_rate() : Number{
			return _anti["hp_rate"];
		}
		public function set hp_rate(value:Number) : void{
			_anti["hp_rate"] = value;
		}
		
		public function get target_buff_type() : String{
			return _anti["target_buff_type"];
		}
		public function set target_buff_type(value:String) : void{
			_anti["target_buff_type"] = value;
		}
		
		public function get target_buff_value() : String{
			return _anti["target_buff_value"];
		}
		public function set target_buff_value(value:String) : void{
			_anti["target_buff_value"] = value;
		}
	}
}