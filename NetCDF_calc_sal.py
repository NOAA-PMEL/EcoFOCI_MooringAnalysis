#!/usr/bin/env python

"""
NetCDF_calc_sal.py

calculate salinity from conductivity.

"""

import datetime
import argparse

#Science Stack
from netCDF4 import Dataset
import numpy as np
import seawater as sw

#User Stack
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2016, 11, 1)
__modified__ = datetime.datetime(2016, 11, 1)
__version__  = "0.1.0"
__status__   = "Development"
__keywords__ = 'adcp', 'shear', 'vector', 'derivations'


"""------------------------------------- salinity Calc -----------------------------------"""

def salinity_calculation(conductivity, temperature, pressure, depth, no_press = False):
    """ Calculate Salinity - following sbe37 seabird calculation"""

    if (pressure == -9999.).any() | (no_press):
        history = "Salinity recalculated using nominal depth"
        salinity = sw.salt(conductivity/42.914,temperature,pressure*0 + depth)
        salinity[np.isnan(salinity)] = 1e35
    else:
        history =  "Salinity recalculated using P_1 (recorded pressure)"
        salinity = sw.salt(conductivity/42.914,temperature,pressure)

    return (salinity, history)

"""------------------------------- MAIN--------------------------------------------"""

parser = argparse.ArgumentParser(description='Calculate or update Salinity in Timeseries')
parser.add_argument('sourcefile', metavar='sourcefile', type=str,
               help='complete path to epic file')

args = parser.parse_args()


ncfile = args.sourcefile
df = EcoFOCI_netCDF(ncfile)
global_atts = df.get_global_atts()
nchandle = df._getnchandle_()
vars_dic = df.get_vars()
ncdata = df.ncreadfile_dic()

salinity_s41, salhist = salinity_calculation(conductivity=ncdata['C_50'][:,0,0,0],
                                            temperature=ncdata['T_20'][:,0,0,0],
                                            pressure=ncdata['P_1'][:,0,0,0],
                                            depth=ncdata['depth'])
nchandle.variables['S_41'][:,0,0,0] = salinity_s41

print "adding history attribute"
if not 'History' in global_atts.keys():
    histtime=datetime.datetime.utcnow()
    nchandle.setncattr('History','{histtime:%B %d, %Y %H:%M} UTC - {history} '.format(histtime=histtime,history=salhist))
else:
    histtime=datetime.datetime.utcnow()
    nchandle.setncattr('History', global_atts['History'] +'\n'+ '{histtime:%B %d, %Y %H:%M} UTC - {history}'.format(histtime=histtime,history=salhist))

df.close()    