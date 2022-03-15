#!/bin/bash
# event_group[0] has already been profiled
# event_group[0]='branch-load-misses,branch-loads,L1-dcache-load-misses'

event_group[1]='branch-store-misses,branch-stores,dTLB-load-misses'
event_group[2]='dTLB-loads,iTLB-load-misses,iTLB-loads'
event_group[3]='L1-dcache-loads,L1-dcache-store-misses,L1-dcache-stores'
event_group[4]='L1-icache-load-misses,L1-icache-loads,branch-misses'
event_group[5]='bus-cycles,cache-misses,cache-references'
event_group[6]='cpu-cycles,instructions'


temp1=$1
adb shell monkey -p $temp1 -v 1 &
sleep 1
is_number=0
trial=0
while [ $is_number -eq 0 ]
do
	pid_str=$(adb shell "su -c 'ps | grep $temp1'")
	echo $pid_str

	pid=$(echo $pid_str | awk '{print $2}')
	echo "pid:" $pid

	# check if pid is extracted
	re='^[0-9]+$'
	if ! [[ $pid =~ $re ]] ; then
		echo "error: Not a number" >&2;
		sleep 1
		trial=$((trial+1))
		if [ $trial -eq 20 ] ; then
			exit 1
		fi
	else
		is_number=1
	fi
done
adb shell "su -c '/data/local/tmp/simpleperf stat -p $pid -e ${event_group[6]} --duration 60 --interval 10 -o /data/local/tmp/${1}output${2}-event_group[6]'"
