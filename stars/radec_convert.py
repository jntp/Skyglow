#!/usr/bin/python3.6
# Converts centered right ascension and declination values in radec_values.txt to decimal form and prints them into a new text file.


# Read in data from file-to-be-formatted
with open("radec_values.txt", "r") as file:
  data = file.readlines()
file.close()

with open("radec_decimals.txt", "w") as file:
  for i, coordstring in enumerate(data):
    # Convert right ascension to decimal form
    ra = coordstring[0:8]
    
    # Parse the string and convert to float to allow for mathematical operations
    ra_hr = float(ra[0:2])
    ra_min = float(ra[3:5])
    # no need to convert ra_sec; they're all zero

    ra_min = ra_min / 60 # Convert minutes to hour form

    ra_new = ra_hr + ra_min # add to obtain the decimal form
    ra = str(ra_new)
    
    # Make sure each string has 8 characters
    ra = ra[0:8]
   
    # Add zeros to numbers (strings) with only a tenths place after the decimal
    ra_length = len(ra)
    if ra_length != 8:
      addon = 8 - ra_length # determine how many zeros to "add on"

      for x in range(0, addon):
        ra = ra + "0" # tack on the zeros

    # Convert declination to decimal form
    dec = coordstring[9:18]
    dec = dec[0:3] + ".00000" # easy to convert since all numbers have 0 arcmins and arcsecs

    coordstring = ra + " " + dec + "\n" # write newly converted ra and dec values to string

    # Write newly concatenated string to data and file
    data[i] = coordstring
    file.write(data[i])
    
file.close()
