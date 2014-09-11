package com.test.game.Entitys.Judge
{
	import com.test.game.Const.NumberConst;

	public class CharacterJudge
	{
		//僵直时间
		public var unMoveTime:int;
		//锁住角色，不能操作
		public var isLock:Boolean;
		//是否处在被攻击和僵直的状态
		public var isUnMoveStatus:Boolean;
		//AI判断中，判断角色是否发出攻击
		public var isStartAttack:Boolean;
		//无敌判断
		public var isInvincible:Boolean;
		//无敌时间
		public var inviclbleTime:int;
		//霸体判断
		public var isOnlyHurt:Boolean;
		//霸体时间
		public var onlyHurtTime:int;
		//倒地判断
		public var isFallDown:Boolean;
		//倒地站起判断
		public var isStandUp:Boolean;
		//抓取判断
		public var isCatchStatus:Boolean;
		//吸取判断
		public var isFocusStatus:Boolean;
		//跟随判断
		public var isFollowStatus:Boolean;
		//空中跳起斩下
		public var isRollStatus:Boolean;
		//高手卡没有僵直判断
		public var isUseAutoFight:Boolean;
		//免疫类型
		public var immunityType:int;
		//减伤类型
		public var hurtReduceType:Number;
		//减伤数值
		public var hurtReduceNum:Number;
		//是否魅惑
		public var isTemptation:Boolean;
		//魅惑时间
		public var temptationTime:int;
		
		public function CharacterJudge()
		{
		}
		
		//复活
		public function relive() : void{
			isUnMoveStatus = false;
			immunityType = NumberConst.getIns().zero;
			inviclbleTime = NumberConst.getIns().thirty * NumberConst.getIns().three;
			isInvincible = true;
			onlyHurtTime = NumberConst.getIns().zero;
			isOnlyHurt = false;
			temptationTime = NumberConst.getIns().zero;
			isTemptation = false;
		}
		
		//添加硬直时间
		public function addUnMoveTime(value:int) : void{
			if(unMoveTime < value){
				unMoveTime = value;
			}
		}
	}
}