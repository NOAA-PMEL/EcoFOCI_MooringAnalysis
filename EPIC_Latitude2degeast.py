#!/usr/bin/env python

"""
 Background:
 --------
 EPIC_Latitude2degeast.py

 
 Purpose:
 -------- 
 manually adjust values in an EPIC netcdf file via a config file

 History:
 --------

 2016-08-11: Migrate/integrage routines into EcoFOCI_MooringAnalysis package

"""


# Standard library.
import datetime

# System Stack
import argparse
from netCDF4 import Dataset

# user stack
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF


__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 1, 13)
__modified__ = datetime.datetime(2016, 8, 11)
__version__  = "0.2.0"
__status__   = "Development"

        
"""------------------------------- MAIN--------------------------------------------"""

parser = argparse.ArgumentParser(description='Convert DegreesWest to DegreesEast inplace')
parser.add_argument('sourcefile', metavar='sourcefile', type=str, 
    help='complete path to netcdf file')


args = parser.parse_args()


###nc readin
ncfile = args.sourcefile
df = EcoFOCI_netCDF(ncfile)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
data = df.ncreadfile_dic()

df.variables['lon'][:] = -1.*df.variables['lon'][:]
vars_dic['lon'].units = 'degree_east'
df.close()



    