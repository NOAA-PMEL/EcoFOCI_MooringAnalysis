#!/usr/bin/env

"""
 timeseries_1varplot.py

 History:
 --------
 2016-08-03: Initial development stage.  Plot single variable against time for EcoFOCI instruments
             Move netCDF tools to wrapper functions in class of module io_util.EcoFOCI_netCDF_read
"""
#System Stack
import datetime, sys, os
import argparse

#Science Stack
import numpy as np


# User Stack
from calc.EPIC2Datetime import EPIC2Datetime, get_UDUNITS
from plots.instrument_plot import Timeseries1dStickPlot 
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 9, 11)
__modified__ = datetime.datetime(2014, 9, 11)
__version__  = "0.1.0"
__status__   = "Development"
__keywords__ = 'timeseries', 'mooring', 'epic', 'netcdf'

"""-------------------------------- helper routines---------------------------------------"""

def is_in_dic(var,dic):
    for cmd_var in var:
        if not cmd_var in dic.keys():
            print "Epic Key {0} not in data file... exiting".format(cmd_var)
            sys.exit()

"""--------------------------------main Routines---------------------------------------"""

parser = argparse.ArgumentParser(description='Timeseries plotting')
parser.add_argument('DataPath', metavar='DataPath', type=str,
               help='full path to file')
parser.add_argument('epickey', metavar='epickey', nargs=2, type=str, 
               help='epic key code of data parameter to plot')
parser.add_argument('instname', metavar='instname', type=str,
               help='instrument name')
parser.add_argument("-fp",'--full_path', action="store_true", help='provides full path to program: used if run as script')
parser.add_argument("-di",'--depth_index', type=int, help='0 indexed value for depth parameter to plot if 2d')
          
args = parser.parse_args()

#read in 1d data file
df = EcoFOCI_netCDF(args.DataPath)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
#check that variable is in data file and exit if not
is_in_dic(args.epickey,vars_dic)
ncdata = df.ncreadfile_dic()
df.close()
nctime = get_UDUNITS(EPIC2Datetime(ncdata['time'],ncdata['time2']),'days since 0001-1-1') + 1.0



if args.depth_index:
    depth_index = args.depth_index
else:
    depth_index = 0


# filter data to convert 1e35 -> np.nan
ncdata[args.epickey[0]][np.where(ncdata[args.epickey[0]][:,depth_index,0,0] >= 1e30),depth_index,0,0] = np.nan
ncdata[args.epickey[1]][np.where(ncdata[args.epickey[1]][:,depth_index,0,0] >= 1e30),depth_index,0,0] = np.nan

p1 = Timeseries1dStickPlot()
try:
    t1 = p1.add_title(mooringid=global_atts['MOORING'],
                             lat=ncdata['lat'][0],
                             lon=ncdata['lon'][0],
                             depth=ncdata['depth'][depth_index],
                             instrument=args.instname)
except KeyError:
    t1 = p1.add_title(mooringid=global_atts['MOORING'],
                             lat=ncdata['latitude'][0],
                             lon=ncdata['longitude'][0],
                             depth=ncdata['depth'][depth_index],
                             instrument=args.instname)   

plt1, fig1 = p1.plot(timedata=nctime, 
                     udata=ncdata[args.epickey[0]][:,depth_index,0,0], 
                     vdata=ncdata[args.epickey[1]][:,depth_index,0,0])


t = fig1.suptitle(t1)
t.set_y(0.06)

fig1.autofmt_xdate()
DefaultSize = fig1.get_size_inches()
fig1.set_size_inches( (DefaultSize[0]*2, DefaultSize[1]) )

if not args.full_path:
    plt1.savefig('images/'+ args.DataPath.split('/')[-1] + '_quiver.png', bbox_inches='tight', dpi = (300))
else:
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    plt1.savefig(parent_dir + '/EcoFOCI_MooringAnalysis/images/'+ args.DataPath.split('/')[-1] + '_quiver.png', bbox_inches='tight', dpi = (300))

plt1.close()

