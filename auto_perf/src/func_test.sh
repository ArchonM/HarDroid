#!/bin/bash
event_group='L1-icache-load-misses,dTLB-load-misses,iTLB-load-misses'
filename="8e606c2f35be100d3f19763def3e6c1524af142b67d9ff115ab7db1a2ff30c8f"
filepath="./testfiles/malware/8e606c2f35be100d3f19763def3e6c1524af142b67d9ff115ab7db1a2ff30c8f.apk"
adb install $filepath
pkg=$(aapt dump badging $filepath|awk -F" " '/package/ {print $2}'|awk -F"'" '/name=/ {print $2}')
act=$(aapt dump badging $filepath|awk -F" " '/launchable-activity/ {print $2}'|awk -F"'" '/name=/ {print $2}')
if [ -z $act ]; then
    act=".LauncherActivity"
fi

{
    adb shell "su -c '/data/local/tmp/simpleperf stat --app $pkg -e $event_group --duration 10  --interval 10 -o /data/local/tmp/$filename'"
}&
{
    sleep 1
    adb shell am start -n $pkg/$act
    sleep 1
    adb shell input tap 1000 2100
    sleep 1
    pid=$(adb shell pidof $pkg)
    simpleperf_pid=$(adb shell pidof simpleperf)
    if [ -z $pid ];then
        adb shell su -c "kill ${simpleperf_pid}"
    fi
}&
wait
adb uninstall $pkg