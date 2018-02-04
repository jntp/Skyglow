#!/usr/bin/python3.6
# This script creates two arrays containing centered right ascension (ra) and declination (dec) values. All ra and dec values are written in a time
# format (hh:mm:ss or +-deg:mm:ss). The script then writes the values (as strings) to a text file.

import math
import numpy as np


# Create right ascension and declination arrays
# Each index contains the centered ra and dec values for each grid 
raDeg = np.zeros(72) # create array of zeros which will contain 72 indices
for i, val in enumerate(raDeg):
  if i == 0: # set value of first index
    prev_val = 2.5

  raDeg[i] = prev_val
  prev_val += 5 # add 5 to obtain the value of the following index

ra = raDeg / 15 # Convert from degrees to hours by dividing by 15

dec = np.zeros(36)
for i, val in enumerate(dec):
  if i == 0:
    prev_val = -87.5

  dec[i] = prev_val
  prev_val += 5

# Convert ra and dec to time format (hh:mm:ss for ra and deg:mm:ss for dec)
raTime = ["" for x in range(72)] # create "empty" string array of 72 indices
for i, val in enumerate(ra):
  ra_hr = math.floor(val) # retrieve the whole number of ra
  ra_dec = val - ra_hr # subtract ra value by its whole number to obtain decimal

  ra_min = ra_dec * 60
  ra_min_str = str(ra_min) # convert to string early to allow for string operations
  # can neglect ra_sec because they would all equal to zero (decimals of ra_min are all zero)

  ra_str = str(ra_hr) + ":" + ra_min_str[0:2] + ":" + "00" # Convert and concatenate to obtain "hh:mm:ss" format

  raTime[i] = ra_str # store in a new array

decTime = ["" for x in range(36)]
for i, val in enumerate(dec):
  # Declination values between -9 and +9 will have a 0 appended to the front
  if val > -10 and val < 10:
    dec_str = "0"
  else:
    dec_str = "" # don't add anything

  # The declination string will always start with a + or - sign. See if adding a + sign is needed.
  if val < 0: # for negative numbers
    dec_whole = math.ceil(val) # retrieve the whole number of dec; use ceil for negative numbers
    dec_whole_str = str(dec_whole) # store in separate variable to allow flexibility in string operations
    dec_str = dec_whole_str[0] + dec_str + dec_whole_str[1:] + ":30:00" # minus sign already exists; no need to add anything
  else: # for positive numbers 
    dec_whole = math.floor(val) # use floor for positive numbers
    dec_str = "+" + dec_str + str(dec_whole) + ":30:00" # add a plus sign

  decTime[i] = dec_str

# Write centered ra and dec values to a new file
with open("radec_values.txt", "w") as file:
  # Loop through raTime
  for j, strLine in enumerate(raTime):
    file.write(raTime[j] + "\n")

  file.write("\n") # add empty line to separate ra and dec values

  # Loop through decTime
  for j, strLine in enumerate(decTime):
    file.write(decTime[j] + "\n")

file.close() 
