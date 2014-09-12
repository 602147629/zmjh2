var EventEmitter = require("events").EventEmitter;
var itemClass = require('../model/Item.js');
var comm = require("../const/common.js");


function BagControllor(){
	EventEmitter.call(this);

	this.items = [];
	this.maxItems = comm.Bag.MAX_ITEMS;
    this.currentItemsLen = 0;
}

require('util').inherits(BagControllor, EventEmitter);

BagControllor.prototype.items;//道具数组
BagControllor.prototype.maxItems;//格子数目
BagControllor.prototype.currentItemsLen;//当前道具数目


BagControllor.prototype.initWithData = function(data){
    this.maxItems = data.max;//最多道具格子数目
    this.setItemsFromDb(data.items);//具体道具
}

//增加道具(对外接口)
BagControllor.prototype.addItems = function(id,num){
    var changeItems = [];
    //添加道具
    var newItemIndexs = [];//如果需要新增道具，新道具所可以用的索引数组（在第一次遍历中就计算出来，提高效率）
    var targetItem;
    for(var i=0;i<this.maxItems;i++){
        var item = this.items[i];
        if(item){
            if(item.itemId == id){
                targetItem = item;
                //这个道具已经达到数量上限
                if(item.num >= item.maxNum){
                    continue;
                }
                item.num += num;
                changeItems.push(item);
                if(item.num > item.maxNum){
                    //超过单个上限
                    num -= (item.num - item.maxNum);
                    item.num = item.maxNum;

                    //多余的数目继续往下加
                }else{
                    //结束
                    //提交申请存档
                    this.emit("SAVE");
                    return changeItems;
                }
            }
        }else{
            newItemIndexs.push(i);
        }
    }

    //判定格子是否够用
    if(newItemIndexs.length === 0){
        //背包已满
        console.log('BagControllor->addItem bag is full!');
        //提交申请存档
        if(changeItems.length > 0){
            this.emit("SAVE");
        }
        return changeItems;
    }

    //递归增加道具，直到num==0
    while(num > 0 && newItemIndexs.length > 0){
        var itemObj = {};
        itemObj.id = id;
        itemObj.num = num;
        itemObj.index = newItemIndexs.shift();
        var temp = this.addToBag(itemObj);


        if(temp.num > temp.maxNum){
            temp.num = temp.maxNum;
            num -= temp.maxNum;
        }else{
            num = 0;
        }
        changeItems.push(temp);
    }
    //提交申请存档
    this.emit("SAVE");
    return changeItems;
}

//删除道具
BagControllor.prototype.removeItem = function(id,num){
    var changeItems = [];
    //判定数目是否足够
    var totalCount = this.getItemCountById(id);
    if(totalCount < num){
        //数目不够
        console.log('BagControllor->removeItem item not enough!totalCount:%d,needNum:%d',totalCount,num);
        return changeItems;
    }

	var len = this.items.length;
	for(var i=0;i<len;i++){
		var item = this.items[i];
        if(item){
            if(item.itemId == id){
                if(item.num > num){
                    //该组数量足够
                    item.num -= num;
                    num = 0;
                }else{
                    //减少剩余所需数目
                    num -= item.num;
                    //该组数量不够
                    item.num = 0;
                    //移除出背包
                    this.removeFromBag(i);
                }
                //放入受到影响的数组
                changeItems.push(item);

                //消耗完毕
                if(num <= 0){
                    //提交申请存档
                    this.emit("SAVE");
                    return changeItems;
                }
            }
        }
	}
    //理论上不可能走到这里!
    require("Log").error("BagControllor->removeItem error!unknow error!");
	return changeItems;
}

//根据道具id，获得该道具的总数量
BagControllor.prototype.getItemCountById = function(id){
    var totalNum = 0;
    this.items.forEach(function(item){
        if(item.itemId == id){
            totalNum += item.num;
        }
    });
    return totalNum;
}

//增加一个道具
BagControllor.prototype.addToBag = function(itemObj){
    var targetItem = new itemClass();
    targetItem.buildFromObj(itemObj);
    this.items[itemObj.index] = targetItem;

    this.currentItemsLen++;

    return targetItem;
}

//移除一个道具
BagControllor.prototype.removeFromBag = function(index){
    if(this.items[index]){
        delete this.items[index];
        this.currentItemsLen--;
    }else{
        console.log('BagControllor->removeFromBag error! item not found!item.index:%d',index);
    }
}

//从数据库里的数据初始化道具信息
BagControllor.prototype.setItemsFromDb = function(items){
    if(items == ""){
        return;
    }
    items = JSON.parse(items);
	var self = this;
	items.forEach(function(itemObj){
		self.addToBag(itemObj);
	});
    self = null;
}


//获取所有道具json
BagControllor.prototype.getItemsJsonInfo = function(){
	var json = [];
	this.items.forEach(function(item){
		json.push(item.getJsonInfo());
	});
	return json;
}


//获取存入redis数据
BagControllor.prototype.getItemsJsonInfoForRedis = function(){
    return {
        "pid" : this.pid,
        "items" : JSON.stringify(this.getItemsJsonInfo()),
        "max" : this.max
    }
}

//销毁
BagControllor.prototype.destroy = function(){
	this.removeAllListeners();
    if(this.items){
        this.items.length = 0;
        this.items = null;
    }
}


module.exports = BagControllor;
