#!/usr/bin/env

"""
 ArcticHeat_timeseries_1varplot.py

 History:
 --------
 2017-06-12: Modified so that instead of U,V on second plot, its salinity from mooringsite
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
from plots.instrument_plot import Timeseries1dStickPlot_2params 
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
               help='epic key code of data parameter to plot (u,v)')
parser.add_argument('instname', metavar='instname', type=str,
               help='instrument name')
parser.add_argument("-rot",'--rotate', type=float, default=0.0, help='rotate vectors angle provided')
parser.add_argument("-di",'--depth_index', type=int, default=0, help='0 indexed value for depth parameter to plot if 2d')
parser.add_argument("-second_var",'--second_var', nargs=2, type=str, help='second file and var to be plotted (file, epic_key)')

args = parser.parse_args()

depth_index = args.depth_index

#read in 1d data file
df = EcoFOCI_netCDF(args.DataPath)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
#check that variable is in data file and exit if not
is_in_dic(args.epickey,vars_dic)
ncdata = df.ncreadfile_dic()
df.close()
nctime = get_UDUNITS(EPIC2Datetime(ncdata['time'],ncdata['time2']),'days since 0001-1-1') + 1.0

if args.second_var:
    df2 = EcoFOCI_netCDF(args.second_var[0])
    global_atts = df2.get_global_atts()
    vars_dic = df2.get_vars()
    ncdata2 = df2.ncreadfile_dic()
    df2.close()
    nctime2 = get_UDUNITS(EPIC2Datetime(ncdata2['time'],ncdata2['time2']),'days since 0001-1-1') + 1.0

    ncdata2[args.second_var[1]][np.where(ncdata2[args.second_var[1]][:,depth_index,0,0] >= 1e30),depth_index,0,0] = np.nan



# filter data to convert 1e35 -> np.nan
ncdata[args.epickey[0]][np.where(ncdata[args.epickey[0]][:,depth_index,0,0] >= 1e30),depth_index,0,0] = np.nan
ncdata[args.epickey[1]][np.where(ncdata[args.epickey[1]][:,depth_index,0,0] >= 1e30),depth_index,0,0] = np.nan

p1 = Timeseries1dStickPlot_2params()
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
                     vdata=ncdata[args.epickey[1]][:,depth_index,0,0],
                     rotate=args.rotate,
                     timedata2=nctime2,data2=ncdata2[args.second_var[-1]])


t = fig1.suptitle(t1)
t.set_y(0.06)

fig1.autofmt_xdate()
DefaultSize = fig1.get_size_inches()
fig1.set_size_inches( (DefaultSize[0]*2, DefaultSize[1]) )

plt1.savefig('images/'+ args.DataPath.split('/')[-1] + '_quiver.png', bbox_inches='tight', dpi = (300))
plt1.savefig('images/'+ args.DataPath.split('/')[-1] + '_quiver.svg', bbox_inches='tight', dpi = (300))

plt1.close()

