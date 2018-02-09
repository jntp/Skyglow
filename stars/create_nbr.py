#!/usr/bin/python3.6
# This script creates two arrays containing centered right ascension (ra) and declination (dec) values. All ra and dec values are written in a time
# format (hh:mm:ss or +-deg:mm:ss). The script then writes the values (as strings) to a text file.

import math
import numpy as np


# Create right ascension and declination arrays
# Each index contains the fringe ra and dec values for each grid 
raDeg = np.zeros(72) # create array of zeros which will contain 72 indices
raCen = np.zeros(71) # also create the centered ra array
for i, val in enumerate(raDeg):
  if i == 0: # set value of first index
    prev_val = 2.5

  raDeg[i] = prev_val
  prev_val += 5 # add 5 to obtain the value of the following index

  # Calculate the centered ra value
  if i >= 1: 
    # Calculate the midpoint
    raCen[i-1] = (raDeg[i-1] + raDeg[i]) / 2 # store newly obtained centered ra value in raCen array

raCen = raCen / 15 # Convert from degrees to hours by dividing by 15

dec = np.zeros(36)
decCen = np.zeros(35)
for i, val in enumerate(dec):
  if i == 0:
    prev_val = -87.5

  dec[i] = prev_val
  prev_val += 5

  # Calculate the centered dec value
  if i >= 1:
    decCen[i-1] = (dec[i-1] + dec[i]) / 2

# Convert ra and dec to time format (hh:mm:ss for ra and deg:mm:ss for dec)
raTime = ["" for x in range(71)] # create "empty" string array of 72 indices
for i, val in enumerate(raCen):
  # Right ascension values from 0 to 9 will have a 0 appended to the front
  if val >= 0 and val < 10:
    ra_str = "0"
  else:
    ra_str = "" # don't add anything

  ra_hr = math.floor(val) # retrieve the whole number of ra
  ra_dec = val - ra_hr # subtract ra value by its whole number to obtain decimal

  ra_min = ra_dec * 60
  ra_min_str = str(ra_min) # convert to string early to allow for string operations
  # can neglect ra_sec because they would all equal to zero (decimals of ra_min are all zero)

  # Take into account when ra_min == 0; this can cause inconsistencies when converting to time format
  if ra_min == 0:
    ra_str = ra_str + str(ra_hr) + ":00:00" # Convert and concatenate to obtain "hh:mm:ss" format
  else:
    ra_str = ra_str + str(ra_hr) + ":" + ra_min_str[0:2] + ":" + "00"

  raTime[i] = ra_str # store in a new array

decTime = ["" for x in range(35)]
for i, val in enumerate(decCen):
  # Declination values between -9 and +9 will have a 0 appended to the front
  if val > -10 and val < 10:
    dec_str = "0"
  else:
    dec_str = "" # don't add anything

  # The declination string will always start with a + or - sign. See if adding a + sign is needed.
  if val < 0: # for negative numbers
    dec_whole = math.ceil(val) # retrieve the whole number of dec; use ceil for negative numbers
    dec_whole_str = str(dec_whole) # store in separate variable to allow flexibility in string operations
    dec_str = dec_whole_str[0] + dec_str + dec_whole_str[1:] + ":00:00" # minus sign already exists; no need to add anything
  else: # for positive numbers 
    dec_whole = math.floor(val) # use floor for positive numbers
    dec_str = "+" + dec_str + str(dec_whole) + ":00:00" # add a plus sign

  decTime[i] = dec_str

# Write centered ra and dec values to a new file
with open("radec_values.txt", "w") as file:
  # Each line will contain the centered coordinate of each gridpoint: raTime, decTime
  for i, strRa in enumerate(raTime):
    for j, strDec in enumerate(decTime):
      file.write(raTime[i] + " " + decTime[j] + "\n")

file.close() 
