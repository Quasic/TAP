#!/bin/bash
printf '# runtestcases.sh 0.2'
while true
do
	pwd
	if [ -f testcases.sh ]
	then
		. testcases.sh "$1"
		exit
	elif [ "$(pwd)" = / ]
	then
		read -rn1 -p 'Reached root directory without finding testcases.sh. Press a key...'
		break
	fi
	cd ..
done
