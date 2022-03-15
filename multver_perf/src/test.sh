#!/bin/bash
num_new_packages=$(grep -o 'package' new_packages_list | wc -l)
num_ori_packages=$(grep -o 'package' ori_packages_list | wc -l)
echo $num_new_packages
echo $num_ori_packages
