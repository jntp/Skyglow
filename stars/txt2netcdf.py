from netCDF4 import Dataset
import numpy as np
import sys


input_file = np.loadtxt('scat_data.txt', delimiter=' ')
# NC file setup
mydata = Dataset('scat_data.nc', 'w', format='NETCDF4')
mydata.description = 'Star Catalog'

# dimensions
mydata.createDimension('right_ascension',  )
mydata.createDimension('declination', )

ra = mydata.createVariable('right_ascension', 'f4', 'declination')
ra.long_name = "right ascension"
ra.units = "hours:minutes:seconds"
ra.standard_name = "right ascension"

dec = mydata.createVariable('declination', 'f4', 'right_ascension')
dec.long_name = "declination"
dec.units = "degrees:minutes:seconds"
dec.standard_name = "declination"

mag = mydata.createVariable('magnitude', 'f4', ('right_ascension', 'declination'))
mag.long_name = "apparent visual magnitude"
# apparent magnitude is unitless, so no need to denote units
mag.standard_name = "apparent magnitude"

typ = mydata.createVariable('star_type', 'f4', ('right_ascension', 'declination', 'magnitude'))
typ.long_name = "stellar classification"
# type is also unitless, so no need to denote units
typ.standard_name = "star type"
 
arcsec = mydata.createVariable('arcsecond', 'f4', ('right_ascension', 'declination', 'magnitude', 'star_type')
arcsec.long_name = "arcsecond"
arcsec.units = "arcsecond"
arcsec.standard_name = "arcsecond"

saonum = mydata.createVariable('sao_number', 'c', ('right_ascension', 'declination', 'magnitude', 'type', 'arcsecond'))
saonum.long_name = "Smithsonian Astrophysical Observatory Star Catalog Number"
# SAO number is also unitless, so need to denote units
saonum.standard_name = "SAO Number"










# You left off at FIGURING OUT THE DIMENSIONS
