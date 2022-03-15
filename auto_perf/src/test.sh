#!/bin/bash

if ! test -d ori_packages_list;then
   echo "Not Folder!"
fi


# subfolders=$(ls ./app_lib/malware)
# for subfolder in $subfolders
# do
#    files=$(ls $1/$subfolder)
#    for file in $files
#    do
#       filepath=$1/$subfolder/$file
#       if test -f $filepath; then
#             pkg=$(aapt dump badging $filepath|awk -F" " '/package/ {print $2}'|awk -F"'" '/name=/ {print $2}')
#             act=$(aapt dump badging $filepath|awk -F" " '/launchable-activity/ {print $2}'|awk -F"'" '/name=/ {print $2}')
#             # echo $filepath
#             # echo $pkg/$act
#             if [ -z $act ]; then
#                act=".LauncherActivity"
#             fi

#             adb install $filepath

#             {
#                adb shell "su -c '/data/local/tmp/simpleperf stat --app $pkg -e $event_group --duration 1  --interval 10 -o /data/local/tmp/${filefile%.apk}'"
#             }&
#             {
#                sleep 1
#                adb shell am start -n $pkg/$act
#                sleep 1
#                adb shell input tap 1000 2100
#                sleep 1
#                pid=$(adb shell pidof $pkg)
#                simpleperf_pid=$(adb shell pidof simpleperf)
#                if [ -z $pid ];then
#                   adb shell su -c "kill ${simpleperf_pid}"
#                fi
#             }&
#             wait

#             adb pull /data/local/tmp/${filefile%.apk}
#       fi
      
#    done
# done



# files=$(ls $folder)
# for file in $files
# do
#    echo $file
#    echo ${file%.apk}
# done

# event_group='L1-icache-load-misses,dTLB-load-misses,iTLB-load-misses'
# filename="AF3DWBfkGpzLDiMDFxTo4XhicYUCStAldu_bYSMV_CIXaT0cwin4ynpCbrQKkB6KqTDWkjnyekwAlO5YGiIRScxf2vMDVZMSoSG0E0w5t_7X4-Hpc0VXYP5nyec4R4XRvLOemYRahHTaJz_sZOLdcvSjbPzPR6Rj6w"
# filepath="./testfiles/benign/AF3DWBfkGpzLDiMDFxTo4XhicYUCStAldu_bYSMV_CIXaT0cwin4ynpCbrQKkB6KqTDWkjnyekwAlO5YGiIRScxf2vMDVZMSoSG0E0w5t_7X4-Hpc0VXYP5nyec4R4XRvLOemYRahHTaJz_sZOLdcvSjbPzPR6Rj6w.apk"
# ret=$(adb install $filepath)
# echo "ret value is:"
# echo $ret
# echo "ret value output done"

# pkg=$(aapt dump badging $filepath|awk -F" " '/package/ {print $2}'|awk -F"'" '/name=/ {print $2}')
# act=$(aapt dump badging $filepath|awk -F" " '/launchable-activity/ {print $2}'|awk -F"'" '/name=/ {print $2}')
# if [ -z $act ]; then
#     act=".LauncherActivity"
# fi

# adb shell am start -n $pkg/$act
# sleep 1
# pid=$(adb shell pidof $pkg)
# if [ -z $pid ];then
#    echo "pid is VOID"
# else
#    echo "pid is NOT VOID"
# fi
# ret=$(adb uninstall $pkg)
# echo "ret value is:"
# echo $ret
# echo "ret value output done"