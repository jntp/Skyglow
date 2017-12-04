from netCDF4 import Dataset
from astropy.io import ascii

#Read input file
data = ascii.read('scat_data.txt')

#NC file setup
root_grp = Dataset('scat.nc', 'w', format='NETCDF4')
root_grp.createDimension('star', None)

#Create variables
sao_number = root_grp.createVariable('sao_number', 'i8', ('star',))
ra2000 = root_grp.createVariable('ra2000', 'f8', ('star',))
dec2000 = root_grp.createVariable('dec2000', 'f8', ('star',))
mag = root_grp.createVariable('mag', 'f8', ('star',))
typeClass = root_grp.createVariable('typeClass', 'S1', ('star',))
typeNumber = root_grp.createVariable('typeNumber', 'S1', ('star',))
arcsec = root_grp.createVariable('arcsec', 'f8', ('star',))

#copy data
for i in data:
    sao_number[:] = data['SAO_number']
    ra2000[:] = data['RA2000']
    dec2000[:] = data['Dec2000']
    mag[:] = data['Mag']
    typeClass[:] = data['Type1']
    typeNumber[:] = data['Type2']
    arcsec[:] = data['Arcsec']

#close netcdf file to save it
root_grp.close()

