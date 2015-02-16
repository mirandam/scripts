#!/bin/bash

#verify de file as paremeter
if [ -z $1 ]; then
	echo -e "Not file added"
	exit 0
fi

#clear the alert file, this is the main file
> /tmp/no_pd_report.csv

## THIS IS THE  MAIN FUNCTION THERE IS WHERE THE DATA IS PROCCESED AND STORE INTO alert FILE

file=$1

while read line; do #read the cfg nagios file

	#save the whole alert(line per line) into /tmp/tmpalert, this file is used to read the alert data.
	# every line with the comment character will be avoid, the code: (tr -d '\r') remove the carriage return
	echo $line | egrep -v "^#" | tr -d '\r' >> /tmp/tmpalert

	#if line contains } then this is the end of the alert, so the file is ready to be read with an alert within.
	if grep -q "}" <<<$line; then

		#read the data alert from  /tmp/tmpalert.
		#write the host line into tmphost file, every host is write on a line, this way we can read each of them easily 
		`cat /tmp/tmpalert | grep host_name | sed s/host_name//g | sed "s/,/\n/g" | sed "s/^ //" >> /tmp/tmphosts`

		#service description line
		service_description=`cat /tmp/tmpalert | grep service_description | sed s/service_description//g | sed "s/^ //" `

		#contacts line
		contacts=`cat /tmp/tmpalert | grep contacts | sed s/contacts//g | sed -e "s/^ //"`

		#Pager Duty line

		if grep -q "pagerduty" <<<$contacts; then
			pd="YES"
		else
			pd="NO"
		fi

		#Read the tmphost file, in order to write every host with its details.
		while read host; do

			#write the final data into /tmp/no_pd_report.csv file
			if [ $pd = "NO" ]; then
				echo $host~ $service_description~ $contacts~ $pd >> /tmp/no_pd_report.csv
			fi
		done < /tmp/tmphosts

		#clear files
		> /tmp/tmpalert
		> /tmp/tmphosts
	fi
done < $file

cat /tmp/no_pd_report.csv

#remove tmp files
exec rm -f /tmp/tmpalert /tmp/tmphosts