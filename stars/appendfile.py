#!/usr/bin/python3.6
# Appends data from nbr_num to radec_decimals.txt
import math


# Read data from nbr_num.txt
with open("nbr_num.txt", "r") as file:
  nbr_num = file.readlines()
file.close()

# Read data from radec_decimals.txt
with open("radec_decimals.txt", "r") as file:
  coords = file.readlines()
file.close()

# Write nbr_num data to radec_decimals.txt
with open("radec_decimals.txt", "w") as file:  
  # Append nbr_num data to text file
  for i, line in enumerate(coords):
    # Strip off newlines off line and nbr_num
    line = line.strip('\n')
    nbr_num[i] = nbr_num[i].strip('\n')
    
    # Convert nbr_num (star density) to number of stars per sterradian
    # Add 5 and subtract 5 degrees to get fringe values
    # math.sin() then calculate sterradians

    # Convert right ascension to degrees longitude
    setValues = line.split(" ")
    deg_lon = float(setValues[0]) * 15

    # Concatenate converted ra as well as the star density to string
    str_lon = str(deg_lon) # convert deg_lon to string and store in a variable

    len_str = len(str_lon)
    if len_str < 8: # for formatting purposes, ensure "shorter" decimals are the same length as the longer ones
      digits = 8 - len_str # find the number of zeros that need to be added after the decimal

      # Add the zeros as determined by "digits"
      for j in range(0, digits):
        str_lon = str_lon + "0"

    line = str_lon[0:8] + " " + setValues[1] + " " + nbr_num[i] + "\n" 

    # Write newly concatenated string to coords and file
    coords[i] = line
    file.write(coords[i])
file.close()

# You left off at dividing star density by number of stars per sterradian
