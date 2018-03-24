#!/usr/bin/python3.6
# Appends data from nbr_num to radec_decimals.txt


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
    print(setValues[0])

    line = line + " " + nbr_num[i] + "\n" 

    # Write newly concatenated string to coords and file
    coords[i] = line
    file.write(coords[i])
file.close()

# You left off at converting ra to degrees longitude
