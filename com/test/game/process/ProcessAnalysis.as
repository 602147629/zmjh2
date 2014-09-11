package com.test.game.process
{
	import com.adobe.serialization.json.JSON;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.Ai.BaseBev;
	import com.test.game.Manager.ConfigurationManager;
	
	public class ProcessAnalysis
	{
		private var _locked:Boolean;
		private var _mainObj:Object;
		private var _nowObj:Object;
		private var _nowWord:Object;
		private var _nowAction:Object;
		private var _nowIndex:int;
		private var _fightJudge:Object;
		private var _transferJudge:Object;
		private var _entity:MonsterEntity;
		private var _bevAi:BaseBev;
		private var _aiObj:Object;
		
		public function ProcessAnalysis(obj:Object, entity:MonsterEntity){
			_mainObj = obj;
			_entity = entity;
			_nowObj = _mainObj.start;
		}
		
		public function step():void{
			if(_locked) return;
			if(_nowObj != null){
				if(_nowObj.type == ProcessConst.WORD){
					AnalysisWord();
				}else if(_nowObj.type == ProcessConst.FIGHT){
					AnalysisFight();
				}
				if(_bevAi != null){
					_bevAi.step();
				}
			}
		}
		
		//动作集判断
		private function AnalysisFight():void{
			if(_fightJudge.judge(_entity)){
				if(_bevAi != null){
					_bevAi.destroy();
					_bevAi = null;
					_aiObj = null;
				}
				_nowObj = _mainObj[_nowObj.callback];
				if(_nowObj.type == ProcessConst.FIGHT){
					for(var judge:String in _nowObj[ProcessConst.JUDGE]){
						_fightJudge = new (ProcessConst.funcStatues[judge])(_nowObj[ProcessConst.JUDGE][judge]);
					}
					//设置智能AI配置
					if(_nowObj[ProcessConst.TRANSFER] != null){
						for(var transfer:String in _nowObj[ProcessConst.TRANSFER]){
							if(transfer != ProcessConst.AI){
								_transferJudge = new (ProcessConst.funcStatues[transfer])(_nowObj[ProcessConst.TRANSFER][transfer]);
							}else{
								_aiObj = com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData(_nowObj[ProcessConst.TRANSFER][transfer]));
							}
						}
					}
				}
				setEntityStatus();
				_nowIndex = 0;
			}
			//是否进入智能AI
			else if(_transferJudge.judge(_entity) && _bevAi == null){
				_bevAi = new BaseBev(_entity, _aiObj);
			}
			else if(!_transferJudge.judge(_entity)){
				if(_bevAi != null){
					_bevAi.destroy();
					_bevAi = null;
					_aiObj = null;
				}
				//判断当前动作集是否达到要求，如若达到，则跳到下一动作集
				if(_fightJudge.judge(_entity)){
					_nowObj = _mainObj[_nowObj.callback];
					_nowIndex = 0;
				}else{
					//如若当前动作为空，设置当前的动作
					if(_nowAction == null){
						for(var prop:String in _nowObj[_nowIndex]){
							if(prop != "status"){
								_nowAction = new (ProcessConst.funcStatues[prop])(_nowObj[_nowIndex][prop])
							}
						}
					}
					//如若设置完动作后，当前动作还是为空，则判断是否达到跳到下一动作/活动集的要求，达到则跳到下一动作/活动集，否则当前动作集重复
					if(_nowAction == null){
						if(_fightJudge.judge(_entity)){
							_nowObj = _mainObj[_nowObj.callback];
						}
						_nowIndex = 0;
						return;
					}
					//如若当前动作已完成，则指针跳到当前动作集的下一动作
					if(_nowAction.judge(_entity)){
						_nowAction = null;
						_nowIndex++;
					}
				}
			}
		}
		
		
		private var _nowFrame:int;
		//活动集判断
		private function AnalysisWord():void{
			//每个活动持续50帧————测试的判断（以后根据需求判断）
			_nowFrame++;
			if(_nowFrame >= 50){
				_nowFrame = 0;
				_nowIndex++;
				_nowWord = null;
			}
			//如若当前索引下的活动集已无动作，则跳到下一动作/活动集，并设置下一动作/活动集的判断函数
			if(_nowObj[_nowIndex] == null){
				_nowObj = _mainObj[_nowObj.callback];
				for(var judge:String in _nowObj[ProcessConst.JUDGE]){
					_fightJudge = new (ProcessConst.funcStatues[judge])(_nowObj[ProcessConst.JUDGE][judge]);
				}
				//设置智能AI配置
				if(_nowObj[ProcessConst.TRANSFER] != null){
					for(var transfer:String in _nowObj[ProcessConst.TRANSFER]){
						if(transfer != ProcessConst.AI){
							_transferJudge = new (ProcessConst.funcStatues[transfer])(_nowObj[ProcessConst.TRANSFER][transfer]);
						}else{
							_aiObj = com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData(_nowObj[ProcessConst.TRANSFER][transfer]));
						}
					}
				}
				setEntityStatus();
				_nowIndex = 0;
				return;
			}
			//如果当前活动与记录的活动一致，则返回
			if(_nowWord == _nowObj[_nowIndex])	return;
			//设置当前活动
			for(var prop:String in _nowObj[_nowIndex]){
				_nowWord = _nowObj[_nowIndex];
				//var obj:Object = new (ProcessConst.funcStatues[prop])(_nowObj[_nowIndex][prop]);
			}
		}
		
		private function setEntityStatus() : void{
			if(_nowObj.status == null)	return;
			switch(_nowObj.status){
				case ProcessConst.ONLY_HURT:
					_entity.characterJudge.onlyHurtTime = -1;
					_entity.characterJudge.inviclbleTime = 1;
					break;
				case ProcessConst.INVINCIBLE:
					_entity.characterJudge.inviclbleTime = -1;
					_entity.characterJudge.onlyHurtTime = 1;
					break;
				case ProcessConst.NOTHING:
					_entity.characterJudge.onlyHurtTime = 1;
					_entity.characterJudge.inviclbleTime = 1;
					break;
			}
		}
		
		public function get locked() : Boolean{
			return _locked;
		}
		
		public function get bevAi() : BaseBev{
			return _bevAi;
		}
		
		public function destroy() : void{
			if(_bevAi != null){
				_bevAi.destroy();
				_bevAi = null;
			}
			_mainObj = null;
			_nowObj = null;
			_nowWord = null;
			_nowAction = null;
			_fightJudge = null;
			_transferJudge = null;
			_entity = null;
			_aiObj = null;
			
		}
	}
}