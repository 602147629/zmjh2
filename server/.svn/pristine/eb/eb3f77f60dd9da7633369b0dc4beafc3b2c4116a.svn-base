var log4js = require('log4js'); 

const LEVEL = 'trace';
const TYPE = 1;//日志输出类型

if(TYPE === 0){
	//日志写入系统调试区域
	log4js.loadAppender('console');
	// log4js.addAppender(log4js.appenders.console());
}else{
	//日志写入文件
	log4js.loadAppender('file');
	log4js.addAppender(log4js.appenders.file('logs/cheese2.log'), 'cheese');
	log4js.addAppender(log4js.appenders.file('logs/dbError.log'), 'dbError');
}


// logger.debug('Got cheese.');
// logger.info('Cheese is Gouda.');
// logger.warn('Cheese is quite smelly.');
// logger.error('Cheese is too ripe!');
// logger.fatal('Cheese was breeding ground for listeria.');


module.exports = {
	//根据注册名，找到日志文件（写入console时可以随意）
	GetLogger : function(filename){
		var logger = log4js.getLogger(filename);
		logger.setLevel(LEVEL);//设置要记录到文本的等级（大于等于所设置的等级的日志将被记录）
		return logger;
	},
	GetCheeseLogger : function(){
		var logger = log4js.getLogger("cheese");
		logger.setLevel(LEVEL);//设置要记录到文本的等级（大于等于所设置的等级的日志将被记录）
		return logger;
	}
	// ,
	// //阻塞的方式打印日志
	// Debug : function(content){
	// 	require('util').debug(content);
	// }

}