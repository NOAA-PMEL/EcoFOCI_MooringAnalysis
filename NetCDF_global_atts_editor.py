#!/usr/bin/env python

"""
 Background:
 --------
 NetCDF_global_atts_editor.py

 
 Purpose:
 -------- 
 manually adjust global attributes in an EPIC netcdf file via a config file

 History:
 --------

 2016-08-11: Migrate/integrage routines into EcoFOCI_MooringAnalysis package

"""

# Standard library.
import datetime, sys

# System Stack
import argparse

# Scientific stack.
from netCDF4 import Dataset

# user stack
from io_utils import ConfigParserLocal
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF


__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 01, 13)
__modified__ = datetime.datetime(2014, 01, 29)
__version__  = "0.2.0"
__status__   = "Development"

"""--------------------------------netcdf Routines---------------------------------------"""

def set_global_atts(nchandle, g_atts):

    for name in g_atts.keys():
        g_atts[name] = nchandle.setncattr(name,g_atts[name])
        
"""------------------------------- MAIN--------------------------------------------"""

parser = argparse.ArgumentParser(description='Edit/View NetCDF header information')
parser.add_argument('sourcefile', metavar='sourcefile', type=str, 
                    help='complete path to netcdf file')
parser.add_argument("-s",'--screen', action="store_true", 
                    help='output to screen')
parser.add_argument("-ah",'--add_history', action="store_true", 
                    help='add global attribute field for history')
parser.add_argument("-adsg",'--add_dsg', type=str, 
                    help='''add global attribute field for discrete sampling geometry.
                    Options: point, timeSeries, trajectory, profile, timeSeriesProfile, trajectoryProfile''')
parser.add_argument("-o",'--out_config', action="store_true", 
                    help='output to config file')
parser.add_argument("-in",'--in_config', action="store_true", 
                    help='modify using current config file')

args = parser.parse_args()


###nc readin
ncfile = args.sourcefile
df = EcoFOCI_netCDF(ncfile)
global_atts = df.get_global_atts()
df.close()

if args.screen:
    
    for k in global_atts.keys():
        print "{0}: {1}".format(k,global_atts[k])
        
if args.out_config:
    for k in global_atts.keys():
        global_atts[k] = str(global_atts[k])
        print "{0}: {1}".format(k,global_atts[k])

    ConfigParserLocal.write_config("header_config.yaml", global_atts,'yaml')
    
if args.in_config:
    nc_meta = ConfigParserLocal.get_config('header_config.yaml','yaml')
    print nc_meta

    print "Setting attributes"
    nchandle = Dataset(args.sourcefile,'a')
    set_global_atts(nchandle, nc_meta)
    nchandle.close()

if args.add_history:

    print "adding history attribute"
    nchandle = Dataset(args.sourcefile,'a')
    nchandle.setncattr('history','')
    nchandle.close()

if args.add_dsg:

    print "adding dsg attribute"
    nchandle = Dataset(args.sourcefile,'a')
    nchandle.setncattr('featureType',args.add_dsg)
    nchandle.close()
