#!/usr/bin/python3.6
import math
import numpy as np

# Create right ascension and declination arrays
# Each index contains the centered ra and dec values for each grid 

raDeg = np.zeros(72) # create array of zeros which will contain 72 indices
for i, val in enumerate(raDeg):
  if i == 0: # set value of first index
    prev_val = 2.5

  raDeg[i] = prev_val
  prev_val = prev_val + 5 # add 5 to obtain the value of the following index

ra = raDeg / 15 # Convert from degrees to hours by dividing by 15

# dec = [-87.5:87.5:5] # -90 to +90 degrees

# Convert ra and dec to time format (hh:mm:ss for ra and deg:mm:ss for dec)
raTime = ["" for x in range(72)] # create "empty" string array of 72 indices
for i, val in enumerate(ra):
  ra_hr = math.floor(val) # retrieve whole number of ra
  ra_dec = val - ra_hr # subtract ra value by its whole number to obtain decimal

  ra_min = ra_dec * 60
  ra_min_str = str(ra_min) # convert to string early to allow for string operations
  # can neglect ra_sec because they would all equal to zero (decimals of ra_min are all zero)

  ra_str = str(ra_hr) + ":" + ra_min_str[0:2] + ":" + "00" # Convert and concatenate to obtain "hh:mm:ss" format
  print(ra_str)

  raTime[i] = ra_str # store in a new array







# You left off at creating the declination array using the for loop method


  
