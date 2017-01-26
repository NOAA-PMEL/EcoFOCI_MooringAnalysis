#!/usr/bin/env

"""
ncgridded2image.py

Usage:
------


 History:
 --------
 2016-08-02: update EPIC to CF time routines to be in EPIC2Datetime.py and removed time calls
    in this routine.

 2016-08-10: convert to use gridded data files

"""

#System Stack
import os
import datetime
import argparse

#Science Stack
from netCDF4 import Dataset, num2date, date2num
import numpy as np

# Visualization Stack
import matplotlib as mpl
#mpl.use('Agg') 
import matplotlib.pyplot as plt
from matplotlib.dates import YearLocator, MonthLocator, DayLocator, HourLocator, DateFormatter
import matplotlib.ticker as ticker
import cmocean

# Relative User Stack
parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.sys.path.insert(1, parent_dir)
from calc.EPIC2Datetime import EPIC2Datetime
import io_utils.ConfigParserLocal as ConfigParserLocal
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 9, 11)
__modified__ = datetime.datetime(2015, 2, 5)
__version__  = "0.1.0"
__status__   = "Development"
__keywords__ = 'Mooring', 'gridded', '2d', 'plots'

    
"""--------------------------------main Routines---------------------------------------"""

parser = argparse.ArgumentParser(description='Grid and plot data from multiple instruments on a mooring')
parser.add_argument('gridded_file', metavar='gridded_file', type=str, 
               help='full path to gridded_file file')
parser.add_argument('plot_var', metavar='plot_var', type=str, 
               help='EPIC Key to plot')
parser.add_argument('depth_m', metavar='depth_m', type=int, 
               help='local max depth')
parser.add_argument('-fg','--FillGaps', action="store_true",
               help='Interpolate and Fill Gaps in bin averaged data')            
args = parser.parse_args()


print "Working on {0}".format(args.gridded_file)
df = EcoFOCI_netCDF(args.gridded_file)
vars_dic = df.get_vars()
ncdata = df.ncreadfile_dic()
df.close()

depth_array = np.arange(0,args.depth_m+1,1)

###build empty array
gridarray = np.ones((len(ncdata['time']),len(depth_array)))*np.nan
for i,v in enumerate(ncdata['depth']):
    if v in ncdata['depth']:
        print "copying {0}".format(v)
        gridarray[:,int(v)] = ncdata[args.plot_var][:,i,0,0]
        
extent=[np.min(ncdata['time']),np.max(ncdata['time']),np.min(depth_array),np.max(depth_array)]
#plt.imshow(gridarray.transpose(),extent=extent)
plt.contourf(ncdata['time'],depth_array,gridarray.transpose())
if args.FillGaps:
    ###Find times with no data to replace with nans or zeros later
    
    ### make top and bottom same as closest mooring instrument
    gridarray[:,0] = ncdata[args.plot_var][:,0,0,0]
    gridarray[:,-1] = ncdata[args.plot_var][:,-1,0,0]

    mask = np.isnan(gridarray)
    gridarray[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), gridarray[~mask])    