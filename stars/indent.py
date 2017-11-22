#!/usr/bin/python
# This script reformats scat_data.txt by converting single whitespace and triple whitespace "delimiters" to double whitespaces. The goal is for
# netcdf4-python to properly read, parse, and convert scat_data.txt to a netcdf4 file.

with open("scat_data.txt") as file:
  data = file.readlines()
  i = 0 # for keeping track of the indices during the for loop

  for thestring in data:
    lastindex = len(thestring) - 1 

    # Delete the double space at the beginning of each string
    data[i].lstrip() 
  
    # Find single and triple spaces and turn them into double spaces
    a = thestring.find(' ') # find the lowest index of the whitespace character
    b = a + 1 # will be used to check if adjacent character is a whitespace

    if a == ' ' and b != ' ': # For single spaces
      # Create two separate strings for concatenation
      stringone = thestring[0:a]
      stringtwo = thestring[b:lastindex]

      thestring = stringone + " " + stringtwo # insert whitespace between strings

    # Find and delete the triple space
    c = thestring.find('   ')
    d = c + 2 
    lastindex = len(thestring) # update the lastindex variable

    stringone = thestring[0:c]
    stringtwo = thestring[d:lastindex]

    thestring = stringone + stringtwo # simply concatenate the two strings, skipping the index between c and d
    data[i] = thestring # end product

    file.write(thestring) # write to file

file.close()

# You left off at addressing the file.write error
