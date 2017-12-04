from netCDF4 import Dataset
import numpy as np
import sys


input_file = np.loadtxt('scat_data.txt', delimiter='  ')
# NC file setup
mydata = Dataset('scat_data.nc', 'w', format='NETCDF4')
mydata.description = 'Star Catalog'

# dimensions
mydata.createDimension('right_ascension', 24) # 24 hours total for right ascension
mydata.createDimension('declination', 180) # 180 degrees total for declination
mydata.createDimension('magnitude', 8)
mydata.createDimension('star_type', )
mydata.createDimension('arcsecond', 999999)
mydata.createDimension('saonum', 999999)

ra = mydata.createVariable('right_ascension', 'f4', ('right_ascension',))
ra.long_name = "right ascension"
ra.units = "hours"
ra.standard_name = "right ascension"

dec = mydata.createVariable('declination', 'f4', ('declination',))
dec.long_name = "declination"
dec.units = "degrees"
dec.standard_name = "declination"

mag = mydata.createVariable('magnitude', 'f4', ('magnitude',))
mag.long_name = "apparent visual magnitude"
# apparent magnitude is unitless, so no need to denote units
mag.standard_name = "apparent magnitude"

typ = mydata.createVariable('star_type', 'i1', ('star_type',))
typ.long_name = "stellar classification"
# type is also unitless, so no need to denote units
typ.standard_name = "star type"
 
arcsec = mydata.createVariable('arcsecond', 'f4', ('arcsecond',)
arcsec.long_name = "arcsecond"
arcsec.units = "arcsecond"
arcsec.standard_name = "arcsecond"

saonum = mydata.createVariable('sao_number', 'u4', ('right_ascension', 'declination', 'magnitude', 'type', 'arcsecond',))
saonum.long_name = "Smithsonian Astrophysical Observatory Star Catalog Number"
# SAO number is also unitless, so need to denote units
saonum.standard_name = "SAO Number"







mydata.close()



# You left off at FIGURING OUT THE DIMENSIONS
# You left off at assigning data to variables (see python-netcdf4 and numpy documentations)
