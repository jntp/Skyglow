from netCDF4 import Dataset
import numpy as np
import sys


input_file = np.loadtxt('scat_data.txt', delimiter=' ')
# NC file setup
mydata = Dataset('scat_data.nc', 'w', format='NETCDF4')
mydata.description = 'Star Catalog'

# dimensions
mydata.createDimension(














# You left off at FIGURING OUT THE DIMENSIONS
