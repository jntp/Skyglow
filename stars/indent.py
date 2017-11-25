#!/usr/bin/python
# This script reformats scat_data.txt by converting single whitespace and triple whitespace "delimiters" to double whitespaces. The goal is for
# netcdf4-python to properly read, parse, and convert scat_data.txt to a netcdf4 file.

with open("scat_data.txt", "r+") as file:
  data = file.readlines()

  for i, thestring in enumerate(data):
    lastindex = len(thestring)

    # Delete the double space at the beginning of each string
    thestring = thestring[2:lastindex]
  
    # Find single and triple spaces and turn them into double spaces
    a = thestring.find(' ') # find the lowest index of the whitespace character
    b = a + 1 # will be used to check if adjacent character is a whitespace

    if a == ' ' and b != ' ': # For single spaces
      # Create two separate strings for concatenation
      stringone = thestring[0:a]
      print(stringone)
      stringtwo = thestring[b:lastindex]

      thestring = stringone + " " + stringtwo # insert whitespace between strings

    # Find and delete the triple space
    c = thestring.find('   ')

    if c != -1: # check if triple space exists in string
      d = c + 2 
      lastindex = len(thestring) # update the lastindex variable

      stringone = thestring[0:c]
      stringtwo = thestring[d:lastindex]

      thestring = stringone + " " + stringtwo # concatenate the two strings, inserting only one whitespace in between
    # else:
      # thestring = thestring + "\n" # only concatenate the newline character
    
    # print(thestring)

    data[i] = thestring
  
  print(data[0])
    
  file.writelines(data) # write to file

file.close()



# You left off at addressing the file.write error (should not use "r+")
# You still need to figure out why the single character space isn't becoming double
