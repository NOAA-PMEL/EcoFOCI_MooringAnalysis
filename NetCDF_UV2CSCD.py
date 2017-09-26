# filename: NetCDF_UV2CSCD.py
r'''Module to convert geometric U and V current (or wind) components into geographic oriented Speed (CS) and Direction (CD).

Input is a netcdf file - output is screen or some file.
'''

import datetime
import argparse

#Science Stack
from netCDF4 import Dataset
import numpy as np

#User Stack
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2016, 07, 21)
__modified__ = datetime.datetime(2016, 07, 21)
__version__  = "0.1.0"
__status__   = "Development"

"""------------------------------- MAIN--------------------------------------------"""

parser = argparse.ArgumentParser(description='Update Direction from U and V')
parser.add_argument('sourcefile', metavar='sourcefile', type=str,
               help='complete path to epic file')
parser.add_argument('-update','--update', action="store_true",
               help='update netcdf file')
args = parser.parse_args()


if args.update:

    ncfile = args.sourcefile
    df = EcoFOCI_netCDF(ncfile)
    global_atts = df.get_global_atts()
    nchandle = df._getnchandle_()
    vars_dic = df.get_vars()
    ncdata = df.ncreadfile_dic()

    CD = np.zeros_like(ncdata['U_320'])
    for ind, value in enumerate(ncdata['U_320'][:,0,0,0]):
        if value > 1e34:
            CD[ind,0,0,0] = 1e35
        else:
            CD[ind,0,0,0] = np.rad2deg(np.arctan2(-1*ncdata['U_320'][ind,0,0,0],-1*ncdata['V_321'][ind,0,0,0]))+180
    nchandle.variables['CD_310'][:,0,0,0] = CD[:,0,0,0]

update = 'CD - direction, recalculated from mag dec corrected U/V components '

if not 'History' in global_atts.keys():
    print "adding history attribute"
    histtime=datetime.datetime.utcnow()
    nchandle.setncattr('History','{histtime:%B %d, %Y %H:%M} UTC - {history} '.format(histtime=histtime,history=update))
else:
    print "updating history attribute"
    histtime=datetime.datetime.utcnow()
    nchandle.setncattr('History', global_atts['History'] +'\n'+ '{histtime:%B %d, %Y %H:%M} UTC - {history}'.format(histtime=histtime,history=update))


df.close()