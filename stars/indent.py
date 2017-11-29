#!/usr/bin/python3.6
# This script reformats scat_data.txt by converting single whitespace and triple whitespace "delimiters" to double whitespaces. The goal is for
# netcdf4-python to properly read, parse, and convert scat_data.txt to a netcdf4 file.


# Read in data from file-to-be-reformatted
with open("scat_data.txt", "r") as file:
  data = file.readlines()
file.close()

# Perform operations then write to file (will replace old file)
with open("scat_data.txt", "w") as file:
  for i, thestring in enumerate(data):
    lastindex = len(thestring)

    # Delete the double space at the beginning of each string
    thestring = thestring[2:lastindex]
  
    # Find single and triple spaces and turn them into double spaces
    if thestring[20] == ' ' and thestring[21] != ' ': # For single spaces
      # Create two separate strings for concatenation
      stringone = thestring[0:20]
      stringtwo = thestring[21:lastindex]

      thestring = stringone + "  " + stringtwo # insert whitespace between strings

    # Find and delete the triple space
    c = thestring.find('   ')

    if c != -1: # check if triple space exists in string
      d = c + 2 
      lastindex = len(thestring) # update the lastindex variable

      stringone = thestring[0:c]
      stringtwo = thestring[d:lastindex]

      thestring = stringone + " " + stringtwo # concatenate the two strings, inserting only one whitespace in between
  
    # Convert right ascension to decimal form
    ra = thestring[8:20] # get right ascension in string form

    # Parse the string and convert to float to allow for mathematical operation
    ra_hr = float(ra[0:2])
    ra_min = float(ra[3:5])
    ra_sec = float(ra[6:12])

    ra_min = ra_min / 60    # Convert minutes to hour form
    ra_sec = ra_sec / 3600  # Convert seconds to hour form

    ra_new = ra_hr + ra_min + ra_sec # add to obtain the decimal form
    ra = str(ra_new)

    # Convert declination to decimal form
    dec = thestring[22:34]

    dec_sign = dec[0]
    dec_deg = float(dec[1:3])
    dec_arcmin = float(dec[4:6])
    dec_arcsec = float(dec[7:12])

    dec_arcmin = dec_arcmin / 60    # Convert arcminutes to degree form
    dec_arcsec = dec_arcsec / 3600  # Convert arcseconds to degree form

    dec_new = dec_deg + dec_arcmin + dec_arcsec # add to obtain the decimal form
    dec = dec_sign + str(dec_new) # concatenate the new string number with the sign

    lastindex = len(thestring) # update the lastindex variable again
    
    # Replace ra and dec in text file with the newly converted units
    thestring = thestring[0:7] + " " + ra[0:7] + thestring[19:21] + " " + dec[0:7] + thestring[33:lastindex]

    # Write newly concatenated string to data and file
    data[i] = thestring
    file.write(data[i])

file.close()


# You left off at debugging the script. Get right ascension and decination converted!

