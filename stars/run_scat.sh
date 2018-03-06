#!/bin/bash


# Number of lines of radec_values from the wc command will be off; correct by adding 1
strOfRaDec=$( wc -l < radec_values.txt )
numOfRaDec=$(( $strOfRaDec + 1))

# Loop through every centered ra and dec value and run the scat command to obtain nearby stars
i=1
while [ $i -le $numOfRaDec ]
do
  radec=$( cat radec_values.txt | sed -n "$i"p )
  # echo $radec

  scat -c sao -h -m 6.0 -r 18000 $radec > nearby_stars.txt # save in text file so that wc can work
  
  nbr_num=$( wc -l < nearby_stars.txt ) # read nearby_stars.txt and display the number of lines
  # nbr_num=$(($nbr_num - 6)) # Subtract 6 since those six lines are part of a useless header

  # Take into account centered ra/dec values with no stars nearby
  # In these cases, nbr_num will equal -2. Change that to 0
  if [ $nbr_num -eq -2] 
  then
    nbr_num=0
  fi

  echo $nbr_num
  
  # Stuff each nbr_num into text file (append probably)
  sed "$i"i $nbr_num >> radec_values.txt

  ((i++))
done 



# How the hell do you append this shit to radec_values.txt?!?!
# You left off at trying to figure out how to stuff the wc output into the scat_data.txt file

# INSTRUCTIONS:
# Run scat -c sao -h -m 6.0 -r 18000 $ra $dec | m
# where 18000 = 5 deg arcseconds radius and each $ra and $dec is a line from radec_values.txt
# Store output in file?
# Run wc -l file.txt to count number of lines of output


