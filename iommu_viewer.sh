#!/bin/bash

echo "Please be patient. This may take a couple seconds."



	#Initializing the list of all IOMMU groups
	GROUP=`find /sys/kernel/iommu_groups/ -type l | cut -d '/' -f 5,7 --output-delimiter='-'`


	for i in $GROUP; do


		#K holds the group number
		k=`echo $i | cut -d '-' -f 1`

		#L holds the address
		l=`echo $i | cut -d '-' -f 2`

		#J holds the part of the address that's pasted into lspci to get the name
		j=`echo $i | cut -d ':' -f 2,3,4`
		
		#M holds the kernel driver in use
		m=`lspci -k -s $j | grep "Kernel driver in use"`
		
		echo -n  "Group: "

		#This if-statement is here for proper alignment. If group is less than 10, a space is added.
		if [ $k -lt 10 ]
			then
				echo -n " $k  "
			else
				echo -n " $k "
		fi

		#Outputting the address
		echo -n " $l "

		#Outputting the name and id
		echo -n "`lspci -nn | grep $j | cut -d ' ' -f 2-`"
		
		#Only displays "   Driver:" if m is not an empty string
		if ! [ -z "$m" ]
			then
				echo -n "   Driver:"
		fi
		
		#Outputting the kernel driver in use
		echo "$m" | cut -d ':' -f 2


	#The output is sorted numerically based on the second space-separated field.
	done | sort -nk2
