from netCDF4 import Dataset

#NC file setup
root_grp = Dataset('test.nc', 'w', format='NETCDF4')
root_grp.createDimension('star', None)
root_grp.createDimension('nbr_ra', None)
root_grp.createDimension('nbr_dec', None)

#Create variables
sao_number = root_grp.createVariable('sao_number', 'i8', ('star',))
ra2000 = root_grp.createVariable('ra2000', 'f8', ('star',))
dec2000 = root_grp.createVariable('dec2000', 'f8', ('star',))
mag = root_grp.createVariable('mag', 'f8', ('star',))
typeClass = root_grp.createVariable('typeClass', 'S2', ('star',))
typeNumber = root_grp.createVariable('typeNumber', 'S2', ('star',))
arcsec = root_grp.createVariable('arcsec', 'f8', ('star',))
centerRa = root_grp.createVariable('centerCoords', 'f8', ('nbr_ra'))
centerDec = root_grp.createVariable('centerDec', 'f8', ('nbr_dec',))
starDensity = root_grp.createVariable('starDensity', 'i8', ('nbr_ra', 'nbr_dec',)) 

centerCoords.long_name = "Centered Right Ascension and Declination Coordinates"
starDensity.long_name = "Star Density of Centered Right Ascension and Declination Coordinates" 

#copy data from scat_data.txt
ip_file = open('scat_data.txt', 'r')
ip_file.readline() #exclude the header

i = 0

for line in ip_file:
    line = line.strip()
    columns = line.split()
    
    sao_number[i] = columns[0]
    ra2000[i] = columns[1]
    dec2000[i] = columns[2]
    mag[i] = columns[3]
    typeClass[i] = columns[4]
    typeNumber[i] = columns[5]
    arcsec[i] = columns[6]
    i += 1

ip_file.close()

#copy data from radec_decimals.txt
ip_file2 = open('radec_decimals.txt', 'r')
ip_file2.readline()

for i, line in enumerate(ip_file2):
    line = line.strip()
    columns = line.split()

    centerRa[i] = columns[0]
    centerDec[i] = columns[1]
    
    starDensity[i][0] = columns[3] # ??????
    starDensity[i][1] = columns[0] # ??????
    starDensity[i][2] = columns[1] # ??????

ip_file2.close()

#close netcdf file to save it
root_grp.close()
