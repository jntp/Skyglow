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

    # Convert right ascension to degrees longitude
    setValues = line.split(" ")
    deg_lon = float(setValues[0]) * 15

    # Convert nbr_num (star density) to number of stars per sterradian
    # Add 5 and subtract 5 degrees to get fringe values
    # math.sin() then calculate sterradians
    ra_upper = deg_lon + 5
    ra_lower = deg_lon - 5
    if ra_lower < 0: # adjust to zero if the lower ra value ends up less than zero
      ra_lower = 0

    dec_upper = float(setValues[1]) + 5
    dec_lower = float(setValues[1]) - 5

    # Plug in mathematical formula to find the sterradian for each centered ra and dec value
    # Originally taking the integral of r^2*cos(y)dydx
    # After integrating, you get [sin(y2) - sin(y1)]*[x2 - x1]
    delta_sin_y = math.sin(dec_upper) - math.sin(dec_lower)
    delta_x = ra_upper - ra_lower
    sterradian = delta_sin_y * delta_x

    # Divide nbr_num by sterradian to obtain proper units
    starDensity = float(nbr_num[i]) / sterradian
    print(starDensity)
    nbr_num[i] = str(int(starDensity))
    print(nbr_num[i])

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
# What? Why are you getting negative numbers
