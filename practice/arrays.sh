#!/bin/bash

list1Arr=(aaa bbb ccc)
list2Arr=(111 222 333)
#list1Arr=$(echo $list1)
#list2Arr=$(echo $list2)

length=${#list1Arr[@]}
echo length $length

for (( i=0;i<$length;i++ ))
do

	echo -n ${list1Arr[$i]}
	echo ${list2Arr[$i]}
done
