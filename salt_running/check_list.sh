#!/bin/bash
SALT=new_salt
> to_check
> running
while read line
do
	if grep -q "$line" $SALT; then
		echo $line >> running
	else
		echo $line >> to_check
	fi
done < new_nagios
