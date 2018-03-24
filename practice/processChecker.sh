#!/bin/bash
##global variables
pid=$1
parentage=(parent grandparent great_grandparent)
level=0
function getCMD(){
	##get and return command of given pid
	cmdName=$(ps --pid $1 -ho cmd)
	echo $cmdName
}
function chkNet(){
	##try to store foreign ip and port details, if they do exist print it
	netDetails=$( sudo netstat -pant | awk '/ESTABLISHED/ && / '$1'\// {print $5} ' )
	if [ ! -z $netDetails ]
	then
		echo Network details are: $netDetails
	fi
}
function nullChk(){
	##validation function, checks if input is not a number or less than 1, if it is, exit script
	##also checks if the pid exists and exits if not
	testPattern='^[0-9]+$'
        test=$( ps -l -p $1  | awk '{ print $4 }' | sed 's/PID//' )
	if ! [[ $pid =~ $testPattern ]] || [[ "$pid" -lt 1  ]]
	then
		echo Please enter a valid integer
		exit
	fi
	if [ -z $test ]
	then
		echo this Pid does not exist
		exit
	fi
}
function getParent(){
	##gets and returns the parent pid number
	parent=$( ps -l -p $1  | awk '{ print $5 }' | sed 's/PPID//' )
	echo $parent
}
function getSelf(){
	##accumumulates information about the given pid and prints this
	selfCMD=$(getCMD $1)
	selfParent=$(getParent $1)
	echo this process is pid:$1
	echo "it's cmd is" $selfCMD
	chkNet $1
	echo "it's parent's pid:" $selfParent
}
function gatherChildren(){
	##recursive function to get all children pid's of the given pid and their children for 3 generations
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
	##function to print 3 generations of ancestors of given pid, if they exist, will not pass above pid 1
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
##main function, calls methods in correct order
nullChk $pid
grandParents $pid
getSelf $pid
echo ------------------------
gatherChildren $pid

