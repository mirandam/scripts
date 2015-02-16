#!/bin/bash

#clear the alert file, this is the main file
> /tmp/alerts_report.csv

## THIS IS THE  MAIN FUNCTION THERE IS WHERE THE DATA IS PROCCESED AND STORE INTO alert FILE

function main {

file=$1

	while read line; do 

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

				#write the final data into /tmp/alerts_report.csv file
				echo $host~ $service_description~ $contacts~ $pd >> /tmp/alerts_report.csv
			done < /tmp/tmphosts

			#clear files
			> /tmp/tmpalert
			> /tmp/tmphosts
		fi
	done < $file
}

#list of the files to process on the current folder 
#save list of files into /tmp/tmp_cfg_files
`ls | col | egrep -v "tmp*" | egrep "*.cfg" >> /tmp/tmp_cfg_files `

while read line; do
	#Call function and send every .cfg file found to process.
	if [ -z $line ]; then
		echo -e "There are not .cfg files on the current folder: " `pwd`
		exit 0
	fi
	echo $line
	main $line

done < /tmp/tmp_cfg_files

#remove tmp files
exec rm -f /tmp/tmpalert /tmp/tmphosts /tmp/tmp_cfg_files