#临时目录
TMP_PATH="./shell/"
if [ ! -x "$TMP_PATH" ]; then
	mkdir "$TMP_PATH"
fi

#运行脚本
run()
{
	#关闭程序
	if [ -a "./shell/kill.sh" ]; then
		echo "关闭程序："
		sh ./shell/kill.sh
	fi
	#启动
	nohup node Game.js deploy 222&
	#生成关闭的程序
	echo "#!/bin/bash" > ./shell/kill.sh
	echo "echo run pid:$!" >> ./shell/kill.sh	
	echo "kill -15 $!" >> ./shell/kill.sh
	chmod 777 ./shell/kill.sh
	# sleep 1
	#打印启动错误
	sleep 1
}


echo "  ---------- 开始 ----------"
echo "  ---------- 执行 ---------"
echo ""
run
echo ""
echo "  ---------- 结束 ----------"
