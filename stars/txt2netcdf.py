from netCDF4 import Dataset
import numpy as np
import sys


input_file = np.loadtxt('scat_data.txt', delimiter=' ')
# NC file setup
mydata = Dataset('scat_data.nc', 'w', format='NETCDF4')
mydata.description = 'Star Catalog'

# dimensions
mydata.createDimension('right_ascension', )
mydata.createDimension('declination', )

ra = mydata.createVariable('right_ascension', 'f4', 'declination')
ra.long_name = "right ascension"
ra.units = "hours:minutes:seconds"
ra.standard_name = "right ascension"

dec = mydata.createVariable('declination', 'f4', 'right_ascension')
dec.long_name = "declination"
dec.units = "degrees:minutes:seconds"
dec.standard_name = "declination"

mag = mydata.createVariable('magnitude', 'f4', ( ), fill_value= )
mag.long_name = "apparent visual magnitude"
# apparent magnitude is unitless, so no need to denote units
mag.standard_name = "apparent magnitude"

type = mydata.createVariable('type', 'f4', ( ), fill_value= )
type.long_name = 












# You left off at FIGURING OUT THE DIMENSIONS
