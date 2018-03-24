#!/bin/bash

path=$1
echo this is the given path $path

function getData(){
##depth take recursively listed ls, replace / with - , removes unnecessary :, removes characters except - to denote depth
##and remove unnecessary extra -
##fileName take in similar method to above but only return file names of folder
if [ -z $path ]
then
	depth=$(ls -mR | grep ./ | sed -e 's/\//-/g' -e 's/://g' -e 's/[a-zA-Z0-9_]//g' -e 's/\-//' -e 's/\-//')
	fileName=$(ls -mR | grep ./ | tr ' ' '\n' | sed -e 's/\//-/g' -e 's/://g' -e 's@.*-@@')
else
	#remove 1 less dash for different formatting
	depth=$(ls -mR $path | grep ./ | sed -e 's/\//-/g' -e 's/://g' -e 's/[a-zA-Z0-9_]//g' -e 's/\-//')
	fileName=$(ls -mR $path | grep ./ | tr ' ' '\n' | sed -e 's/\//-/g' -e 's/://g' -e 's@.*-@@')
fi
}
function setVars(){
##fills arrays with the results, space automatically act as a delimiter
depthArr=(`echo $depth`)
fileArr=(`echo $fileName`)
##get length of array for loop
length=$(echo $fileName | wc -w)
}
function meshLists(){
##loop whilst printing first array element then second on the same line
for (( i=1;i<=$length;i++ ))
do
        echo -n ${depthArr[$i]}
        echo ${fileArr[$i]}
done

}

getData $1
setVars
meshLists

