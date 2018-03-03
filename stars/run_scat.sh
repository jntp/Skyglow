#!/bin/bash


# Number of lines of radec_values from the wc command will be off; correct by adding 1
strOfRaDec=$( wc -l < radec_values.txt )
numOfRaDec=$(( $strOfRaDec + 1))

# Loop through every centered ra and dec value and run the scat command to obtain nearby stars
i=1
while [ $i -le $numOfRaDec ]
do
  radec=$( cat radec_values.txt | sed -n "$i"p )
  
  scat -c sao -h -m 6.0 -r 1800 $radec > nearby_stars.txt # save in text file so that wc can work
  nbr_num=$( wc -l < nearby_stars.txt )

  # Stuff each nbr_num into text file (append probably)

  ((i++))
done 




# You left off at trying to figure out how to stuff the wc output into the scat_data.txt file

# INSTRUCTIONS:
# Run scat -c sao -h -m 6.0 -r 18000 $ra $dec | m
# where 18000 = 5 deg arcseconds radius and each $ra and $dec is a line from radec_values.txt
# Store output in file?
# Run wc -l file.txt to count number of lines of output


