#!/bin/bash

# Initialization:
echo "Initialization"
# jump to work directory and get work path
echo "=========================================================================================="
cd ./$(dirname $0)
work_path=$(pwd)
echo "Current work path is:"
echo $work_path
# set up path to benign applications
echo "=========================================================================================="
benign_path=$work_path/app_lib/benign
echo "Path to Benign Applications is:"
echo $benign_path
echo
echo "This path contains:"
files=$(ls $benign_path)
if [ ! -n "$files" ]
then
    echo "None"
else
    for filename in $files
    do
        echo $filename
    done
fi
# set up path to malware
echo "=========================================================================================="
malware_path=$work_path/app_lib/malware
echo "Path to Malicious Applications is:"
echo $malware_path
echo
echo "This path contains:"
files=$(ls $malware_path)
if [ ! -n "$files" ]
then
    echo "None"
else
    for filename in $files
    do
        echo $filename
    done
fi

# set up path to profile result
echo "=========================================================================================="
result_path=$work_path/../output
echo "Path to Result is:"
echo $result_path
echo
echo "This path contains:"
files=$(ls $result_path)
if [ ! -n "$files" ]
then
    echo "None"
else
    for filename in $files
    do
        echo $filename
    done
fi
# check whether these information is correct
echo "=========================================================================================="
while true
do
	read -r -p "Are these correct? [Y/n] " input
	case $input in
	    [yY][eE][sS]|[yY])
			echo "Yes"
			break
			;;
	    [nN][oO]|[nN])
			echo "No"
			exit 1
			;;
	    *)
			echo "Invalid input..."
			;;
	esac
done
# Prepare for Profiling, set test environment
echo "=========================================================================================="
echo "Preparing Testing Environment"
echo "=========================================================================================="

# set stay awake while plugged in
echo "Setting stay awake"
adb shell settings put global stay_on_while_plugged_in 3
# turn off wifi
echo "Turning off WiFi"
adb shell su -c 'svc wifi disable'
# turn off bluetooth
echo "Turning off Bluetooth"
adb shell settings get global bluetooth_on 0
adb shell am broadcast -a android.intent.action.BLUETOOTH_ENABLE --ez state true
# turn off location
echo "Turning off Location Service"
adb shell settings put secure location_providers_allowed -gps
adb shell settings put secure location_providers_allowed -network
# turn off nfc
echo "Turning off NFC sensor"
adb shell service call nfc 5
# turn off airplane mode
echo "Turning off AirPlane Mode"
adb shell settings put global airplane_mode_on 0
adb shell am broadcast -a android.intent.action.AIRPLANE_MODE
echo "=========================================================================================="
echo "Testing Environment Prepared"
echo "=========================================================================================="

# test one application each time
# benign applications first
count=0
files=$(ls $benign_path)
for filename in $files
do
    count=$((count+1))
    # Install application
    echo "=========================================================================================="
    echo "Start Installing Benign Application $count"
    echo "=========================================================================================="
    echo "Installing Application $filename"
    adb install $benign_path/$filename


    # Start Profiling
    echo "=========================================================================================="
    echo "Start Profiling"
    echo "=========================================================================================="
    #obtain new package list
    adb shell pm list packages > new_packages_list
    #obtain the number of packages newly installed
    num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
    num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
    #obtain diff between two packages list
    raw_diff=$(diff ori_packages_list new_packages_list)
    package_name=${raw_diff#*package:}
    bash profile0.sh $package_name $count
    echo "=========================================================================================="
    echo "Profiling Finished, Uninstalling Application"
    echo "=========================================================================================="
    echo $package_name
    adb uninstall $package_name
    echo "=========================================================================================="
    echo "Pulling output to Result"
    echo "=========================================================================================="
    adb pull /data/local/tmp/${package_name}output${count}-event_group[0] $result_path/benign0/${package_name}-${count}-event_group[0]
    adb shell rm /data/local/tmp/${package_name}output${count}-event_group[0]
done

count=0
files=$(ls $benign_path)
for filename in $files
do
    count=$((count+1))
    # Install application
    echo "=========================================================================================="
    echo "Start Installing Benign Application $count"
    echo "=========================================================================================="
    echo "Installing Application $filename"
    adb install $benign_path/$filename


    # Start Profiling
    echo "=========================================================================================="
    echo "Start Profiling"
    echo "=========================================================================================="
    #obtain new package list
    adb shell pm list packages > new_packages_list
    #obtain the number of packages newly installed
    num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
    num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
    #obtain diff between two packages list
    raw_diff=$(diff ori_packages_list new_packages_list)
    package_name=${raw_diff#*package:}
    bash profile1.sh $package_name $count
    echo "=========================================================================================="
    echo "Profiling Finished, Uninstalling Application"
    echo "=========================================================================================="
    echo $package_name
    adb uninstall $package_name
    echo "=========================================================================================="
    echo "Pulling output to Result"
    echo "=========================================================================================="
    adb pull /data/local/tmp/${package_name}output${count}-event_group[1] $result_path/benign1/${package_name}-${count}-event_group[1]
    adb shell rm /data/local/tmp/${package_name}output${count}-event_group[1]
done

count=0
files=$(ls $benign_path)
for filename in $files
do
    count=$((count+1))
    # Install application
    echo "=========================================================================================="
    echo "Start Installing Benign Application $count"
    echo "=========================================================================================="
    echo "Installing Application $filename"
    adb install $benign_path/$filename


    # Start Profiling
    echo "=========================================================================================="
    echo "Start Profiling"
    echo "=========================================================================================="
    #obtain new package list
    adb shell pm list packages > new_packages_list
    #obtain the number of packages newly installed
    num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
    num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
    #obtain diff between two packages list
    raw_diff=$(diff ori_packages_list new_packages_list)
    package_name=${raw_diff#*package:}
    bash profile2.sh $package_name $count
    echo "=========================================================================================="
    echo "Profiling Finished, Uninstalling Application"
    echo "=========================================================================================="
    echo $package_name
    adb uninstall $package_name
    echo "=========================================================================================="
    echo "Pulling output to Result"
    echo "=========================================================================================="
    adb pull /data/local/tmp/${package_name}output${count}-event_group[2] $result_path/benign2/${package_name}-${count}-event_group[2]
    adb shell rm /data/local/tmp/${package_name}output${count}-event_group[2]
done

count=0
files=$(ls $benign_path)
for filename in $files
do
    count=$((count+1))
    # Install application
    echo "=========================================================================================="
    echo "Start Installing Benign Application $count"
    echo "=========================================================================================="
    echo "Installing Application $filename"
    adb install $benign_path/$filename


    # Start Profiling
    echo "=========================================================================================="
    echo "Start Profiling"
    echo "=========================================================================================="
    #obtain new package list
    adb shell pm list packages > new_packages_list
    #obtain the number of packages newly installed
    num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
    num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
    #obtain diff between two packages list
    raw_diff=$(diff ori_packages_list new_packages_list)
    package_name=${raw_diff#*package:}
    bash profile3.sh $package_name $count
    echo "=========================================================================================="
    echo "Profiling Finished, Uninstalling Application"
    echo "=========================================================================================="
    echo $package_name
    adb uninstall $package_name
    echo "=========================================================================================="
    echo "Pulling output to Result"
    echo "=========================================================================================="
    adb pull /data/local/tmp/${package_name}output${count}-event_group[3] $result_path/benign3/${package_name}-${count}-event_group[3]
    adb shell rm /data/local/tmp/${package_name}output${count}-event_group[3]
done

count=0
files=$(ls $benign_path)
for filename in $files
do
    count=$((count+1))
    # Install application
    echo "=========================================================================================="
    echo "Start Installing Benign Application $count"
    echo "=========================================================================================="
    echo "Installing Application $filename"
    adb install $benign_path/$filename


    # Start Profiling
    echo "=========================================================================================="
    echo "Start Profiling"
    echo "=========================================================================================="
    #obtain new package list
    adb shell pm list packages > new_packages_list
    #obtain the number of packages newly installed
    num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
    num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
    #obtain diff between two packages list
    raw_diff=$(diff ori_packages_list new_packages_list)
    package_name=${raw_diff#*package:}
    bash profile4.sh $package_name $count
    echo "=========================================================================================="
    echo "Profiling Finished, Uninstalling Application"
    echo "=========================================================================================="
    echo $package_name
    adb uninstall $package_name
    echo "=========================================================================================="
    echo "Pulling output to Result"
    echo "=========================================================================================="
    adb pull /data/local/tmp/${package_name}output${count}-event_group[4] $result_path/benign4/${package_name}-${count}-event_group[4]
    adb shell rm /data/local/tmp/${package_name}output${count}-event_group[4]
done

count=0
files=$(ls $benign_path)
for filename in $files
do
    count=$((count+1))
    # Install application
    echo "=========================================================================================="
    echo "Start Installing Benign Application $count"
    echo "=========================================================================================="
    echo "Installing Application $filename"
    adb install $benign_path/$filename


    # Start Profiling
    echo "=========================================================================================="
    echo "Start Profiling"
    echo "=========================================================================================="
    #obtain new package list
    adb shell pm list packages > new_packages_list
    #obtain the number of packages newly installed
    num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
    num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
    #obtain diff between two packages list
    raw_diff=$(diff ori_packages_list new_packages_list)
    package_name=${raw_diff#*package:}
    bash profile5.sh $package_name $count
    echo "=========================================================================================="
    echo "Profiling Finished, Uninstalling Application"
    echo "=========================================================================================="
    echo $package_name
    adb uninstall $package_name
    echo "=========================================================================================="
    echo "Pulling output to Result"
    echo "=========================================================================================="
    adb pull /data/local/tmp/${package_name}output${count}-event_group[5] $result_path/benign5/${package_name}-${count}-event_group[5]
    adb shell rm /data/local/tmp/${package_name}output${count}-event_group[5]
done

count=0
files=$(ls $benign_path)
for filename in $files
do
    count=$((count+1))
    # Install application
    echo "=========================================================================================="
    echo "Start Installing Benign Application $count"
    echo "=========================================================================================="
    echo "Installing Application $filename"
    adb install $benign_path/$filename


    # Start Profiling
    echo "=========================================================================================="
    echo "Start Profiling"
    echo "=========================================================================================="
    #obtain new package list
    adb shell pm list packages > new_packages_list
    #obtain the number of packages newly installed
    num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
    num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
    #obtain diff between two packages list
    raw_diff=$(diff ori_packages_list new_packages_list)
    package_name=${raw_diff#*package:}
    bash profile6.sh $package_name $count
    echo "=========================================================================================="
    echo "Profiling Finished, Uninstalling Application"
    echo "=========================================================================================="
    echo $package_name
    adb uninstall $package_name
    echo "=========================================================================================="
    echo "Pulling output to Result"
    echo "=========================================================================================="
    adb pull /data/local/tmp/${package_name}output${count}-event_group[6] $result_path/benign6/${package_name}-${count}-event_group[6]
    adb shell rm /data/local/tmp/${package_name}output${count}-event_group[6]
done


count=0
files=$(ls $malware_path)
for filename in $files
do
    count=$((count+1))
    # Install application
    echo "=========================================================================================="
    echo "Start Installing Benign Application $count"
    echo "=========================================================================================="
    echo "Installing Application $filename"
    adb install $malware_path/$filename


    # Start Profiling
    echo "=========================================================================================="
    echo "Start Profiling"
    echo "=========================================================================================="
    #obtain new package list
    adb shell pm list packages > new_packages_list
    #obtain the number of packages newly installed
    num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
    num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
    #obtain diff between two packages list
    raw_diff=$(diff ori_packages_list new_packages_list)
    package_name=${raw_diff#*package:}
    bash profile0.sh $package_name $count
    echo "=========================================================================================="
    echo "Profiling Finished, Uninstalling Application"
    echo "=========================================================================================="
    adb uninstall $package_name
    echo "=========================================================================================="
    echo "Pulling output to Result"
    echo "=========================================================================================="
    adb pull /data/local/tmp/${package_name}output${count}-event_group[0] $result_path/malware0/${package_name}-${count}-event_group[0]
    adb shell rm /data/local/tmp/${package_name}output${count}-event_group[0]
done

# test one application each time
# benign applications first
# count=0
# files=$(ls $malware_path)
# for filename in $files
# do
#     count=$((count+1))
#     # Install application
#     echo "=========================================================================================="
#     echo "Start Installing Benign Application $count"
#     echo "=========================================================================================="
#     echo "Installing Application $filename"
#     adb install $malware_path/$filename
#
#
#     # Start Profiling
#     echo "=========================================================================================="
#     echo "Start Profiling"
#     echo "=========================================================================================="
#     #obtain new package list
#     adb shell pm list packages > new_packages_list
#     #obtain the number of packages newly installed
#     num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
#     num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
#     #obtain diff between two packages list
#     raw_diff=$(diff ori_packages_list new_packages_list)
#     package_name=${raw_diff#*package:}
#     bash profile1.sh $package_name $count
#     echo "=========================================================================================="
#     echo "Profiling Finished, Uninstalling Application"
#     echo "=========================================================================================="
#     adb uninstall $package_name
#     echo "=========================================================================================="
#     echo "Pulling output to Result"
#     echo "=========================================================================================="
#     adb pull /data/local/tmp/${package_name}output${count}-event_group[1] $result_path/malware1/${package_name}-${count}-event_group[1]
#     adb shell rm /data/local/tmp/${package_name}output${count}-event_group[1]
# done

# test one application each time
# benign applications first
# count=0
# files=$(ls $malware_path)
# for filename in $files
# do
#     count=$((count+1))
#     # Install application
#     echo "=========================================================================================="
#     echo "Start Installing Benign Application $count"
#     echo "=========================================================================================="
#     echo "Installing Application $filename"
#     adb install $malware_path/$filename
#
#
#     # Start Profiling
#     echo "=========================================================================================="
#     echo "Start Profiling"
#     echo "=========================================================================================="
#     #obtain new package list
#     adb shell pm list packages > new_packages_list
#     #obtain the number of packages newly installed
#     num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
#     num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
#     #obtain diff between two packages list
#     raw_diff=$(diff ori_packages_list new_packages_list)
#     package_name=${raw_diff#*package:}
#     bash profile2.sh $package_name $count
#     echo "=========================================================================================="
#     echo "Profiling Finished, Uninstalling Application"
#     echo "=========================================================================================="
#     adb uninstall $package_name
#     echo "=========================================================================================="
#     echo "Pulling output to Result"
#     echo "=========================================================================================="
#     adb pull /data/local/tmp/${package_name}output${count}-event_group[2] $result_path/malware2/${package_name}-${count}-event_group[2]
#     adb shell rm /data/local/tmp/${package_name}output${count}-event_group[2]
# done
#
# count=0
# files=$(ls $malware_path)
# for filename in $files
# do
#     count=$((count+1))
#     # Install application
#     echo "=========================================================================================="
#     echo "Start Installing Benign Application $count"
#     echo "=========================================================================================="
#     echo "Installing Application $filename"
#     adb install $malware_path/$filename
#
#
#     # Start Profiling
#     echo "=========================================================================================="
#     echo "Start Profiling"
#     echo "=========================================================================================="
#     #obtain new package list
#     adb shell pm list packages > new_packages_list
#     #obtain the number of packages newly installed
#     num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
#     num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
#     #obtain diff between two packages list
#     raw_diff=$(diff ori_packages_list new_packages_list)
#     package_name=${raw_diff#*package:}
#     bash profile3.sh $package_name $count
#     echo "=========================================================================================="
#     echo "Profiling Finished, Uninstalling Application"
#     echo "=========================================================================================="
#     adb uninstall $package_name
#     echo "=========================================================================================="
#     echo "Pulling output to Result"
#     echo "=========================================================================================="
#     adb pull /data/local/tmp/${package_name}output${count}-event_group[3] $result_path/malware3/${package_name}-${count}-event_group[3]
#     adb shell rm /data/local/tmp/${package_name}output${count}-event_group[3]
# done
#
# count=0
# files=$(ls $malware_path)
# for filename in $files
# do
#     count=$((count+1))
#     # Install application
#     echo "=========================================================================================="
#     echo "Start Installing Benign Application $count"
#     echo "=========================================================================================="
#     echo "Installing Application $filename"
#     adb install $malware_path/$filename


#     # Start Profiling
#     echo "=========================================================================================="
#     echo "Start Profiling"
#     echo "=========================================================================================="
#     #obtain new package list
#     adb shell pm list packages > new_packages_list
#     #obtain the number of packages newly installed
#     num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
#     num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
#     #obtain diff between two packages list
#     raw_diff=$(diff ori_packages_list new_packages_list)
#     package_name=${raw_diff#*package:}
#     bash profile4.sh $package_name $count
#     echo "=========================================================================================="
#     echo "Profiling Finished, Uninstalling Application"
#     echo "=========================================================================================="
#     adb uninstall $package_name
#     echo "=========================================================================================="
#     echo "Pulling output to Result"
#     echo "=========================================================================================="
#     adb pull /data/local/tmp/${package_name}output${count}-event_group[4] $result_path/malware4/${package_name}-${count}-event_group[4]
#     adb shell rm /data/local/tmp/${package_name}output${count}-event_group[4]
# done

# count=0
# files=$(ls $malware_path)
# for filename in $files
# do
#     count=$((count+1))
#     # Install application
#     echo "=========================================================================================="
#     echo "Start Installing Benign Application $count"
#     echo "=========================================================================================="
#     echo "Installing Application $filename"
#     adb install $malware_path/$filename
#
#
#     # Start Profiling
#     echo "=========================================================================================="
#     echo "Start Profiling"
#     echo "=========================================================================================="
#     #obtain new package list
#     adb shell pm list packages > new_packages_list
#     #obtain the number of packages newly installed
#     num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
#     num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
#     #obtain diff between two packages list
#     raw_diff=$(diff ori_packages_list new_packages_list)
#     package_name=${raw_diff#*package:}
#     bash profile5.sh $package_name $count
#     echo "=========================================================================================="
#     echo "Profiling Finished, Uninstalling Application"
#     echo "=========================================================================================="
#     adb uninstall $package_name
#     echo "=========================================================================================="
#     echo "Pulling output to Result"
#     echo "=========================================================================================="
#     adb pull /data/local/tmp/${package_name}output${count}-event_group[5] $result_path/malware5/${package_name}-${count}-event_group[5]
#     adb shell rm /data/local/tmp/${package_name}output${count}-event_group[5]
# done

# count=0
# files=$(ls $malware_path)
# for filename in $files
# do
#     count=$((count+1))
#     # Install application
#     echo "=========================================================================================="
#     echo "Start Installing Benign Application $count"
#     echo "=========================================================================================="
#     echo "Installing Application $filename"
#     adb install $malware_path/$filename
#
#
#     # Start Profiling
#     echo "=========================================================================================="
#     echo "Start Profiling"
#     echo "=========================================================================================="
#     #obtain new package list
#     adb shell pm list packages > new_packages_list
#     #obtain the number of packages newly installed
#     num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
#     num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
#     #obtain diff between two packages list
#     raw_diff=$(diff ori_packages_list new_packages_list)
#     package_name=${raw_diff#*package:}
#     bash profile6.sh $package_name $count
#     echo "=========================================================================================="
#     echo "Profiling Finished, Uninstalling Application"
#     echo "=========================================================================================="
#     adb uninstall $package_name
#     echo "=========================================================================================="
#     echo "Pulling output to Result"
#     echo "=========================================================================================="
#     adb pull /data/local/tmp/${package_name}output${count}-event_group[6] $result_path/malware6/${package_name}-${count}-event_group[6]
#     adb shell rm /data/local/tmp/${package_name}output${count}-event_group[6]
# done
