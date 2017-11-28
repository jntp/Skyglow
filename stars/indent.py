#!/usr/bin/python
# This script reformats scat_data.txt by converting single whitespace and triple whitespace "delimiters" to double whitespaces. The goal is for
# netcdf4-python to properly read, parse, and convert scat_data.txt to a netcdf4 file.
from astropy import units as u
from astropy.coordinates import SkyCoord


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
  
    # Convert right ascension and declination to degrees
    rascension = thestring[7:19]
    declination = thestring[21:33]
    lastindex = len(thestring) # update the lastindex variable again
    coords = SkyCoord(ra=rascension*u.hourangle, dec=declination*u.hourangle) # Create coord object to allow access to components
    
    # Replace ra and dec in text file with the newly converted units
    thestring = thestring[0:7] + coords.ra.degree + thestring[19:21] + coords.dec.degree + thestring[33:lastindex]

    # Write newly concatenated string to data and file
    data[i] = thestring
    file.write(data[i])

file.close()


# You left off at debugging the script. Get right ascension and decination converted!

