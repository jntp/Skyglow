from netCDF4 import Dataset

#NC file setup
root_grp = Dataset('test.nc', 'w', format='NETCDF4')
root_grp.createDimension('star', None)

#Create variables
sao_number = root_grp.createVariable('sao_number', 'i8', ('star',))
ra2000 = root_grp.createVariable('ra2000', 'f8', ('star',))
dec2000 = root_grp.createVariable('dec2000', 'f8', ('star',))
mag = root_grp.createVariable('mag', 'f8', ('star',))
typeClass = root_grp.createVariable('typeClass', 'S2', ('star',))
typeNumber = root_grp.createVariable('typeNumber', 'S2', ('star',))
arcsec = root_grp.createVariable('arcsec', 'f8', ('star',))

#copy data
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

#close netcdf file to save it
root_grp.close()
