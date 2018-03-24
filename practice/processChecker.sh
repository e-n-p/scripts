#!/bin/bash
pid=$1
parentage=(parent grandparent great_grandparent)
level=0
function getCMD(){
	cmdName=$(ps --pid $1 -ho cmd)
	echo $cmdName
}
function chkNet(){
	netDetails=$( sudo netstat -pant | awk '/ESTABLISHED/ && / '$1'\// {print $5} ' )
#	echo netDetails $netDetails
	if [ ! -z $netDetails ]
	then
		echo Network details are: $netDetails
	fi
}
function nullChk(){
	##write code to throw error on string input
	if [[ "$pid" -lt 1  ]]
	then
		echo nullChk break
		exit
	fi
        test=$( ps -l -p $1  | awk '{ print $4 }' | sed 's/PID//' )
	if [ -z $test ]
	then
		echo this Pid does not exist
		exit
	fi
}
function getParent(){
	parent=$( ps -l -p $1  | awk '{ print $5 }' | sed 's/PPID//' )
	echo $parent
}
function getSelf(){
	selfCMD=$(getCMD $1)
	selfParent=$(getParent $1)
	echo this process is pid:$1
	echo "it's cmd is" $selfCMD
	chkNet $1
	echo "it's parent's pid:" $selfParent
}
function gatherChildren(){
	level=$(($level+1))
	childrenHold=$(ps -eo pid,ppid | awk -v var="$1" '$2 == var' | awk '{ print $1 }' | paste -s)
	childrenArr=$(echo $childrenHold)
	echo
	for child in $childrenArr
        do
    	        echo this is at level $level
               	getSelf $child
		if [ $level -lt 3 ]
	        then
			gatherChildren $child
			echo
		fi
	done
	level=$(($level - 1))
}
function grandParents(){
	hold=$pid
	echo "Grandparents of PID:-"$hold
	echo ---------------------------
	for (( i=0;i<3;i++  ))
	do
		parent=$(getParent $hold)
		hold=$(echo $parent)
		if [ $hold -lt 1 ]
		then
			echo "Pid has no more valid ancestors"
                        echo "-----------------------------"
                        break
                fi
		echo ${parentage[$i]}
		getSelf $hold
                echo
	done
	echo
	echo "The following is the details of the given PID"
	echo ---------------------------
}
nullChk $pid
grandParents $pid
getSelf $pid
echo ------------------------
gatherChildren $pid

