#!/usr/bin/env python

"""
 Background:
 --------
 NetCDF_variable_editor.py

 
 Purpose:
 -------- 
 manually adjust values in an EPIC netcdf file via a config file

 Compatibility:
 ==============
 python >=3.7 - Tested and works, future developments
 python 2.7 - Tested, no future developments

 History:
 ========
 2020-07-27: update for python3 syntax
 2016-08-11: Migrate/integrage routines into EcoFOCI_MooringAnalysis package

"""


# Standard library.
import datetime, sys

# System Stack
import argparse
from netCDF4 import Dataset

# user stack
from io_utils import ConfigParserLocal
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF


__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 1, 13)
__modified__ = datetime.datetime(2016, 8, 11)
__version__  = "0.2.0"
__status__   = "Development"

        
"""------------------------------- MAIN--------------------------------------------"""

parser = argparse.ArgumentParser(description='Edit/View Chosen Instrument Data')
parser.add_argument('sourcefile', metavar='sourcefile', type=str, 
    help='complete path to netcdf file')
parser.add_argument('varname', metavar='varname', type=str, 
    help='name of variable to edit.  This is likely the EPIC Key.')
parser.add_argument("-s",'--screen', action="store_true", 
    help='output to screen')
parser.add_argument("-o",'--out_config', action="store_true", 
    help='output to config file')
parser.add_argument("-in",'--in_config', action="store_true", 
    help='modify using current config file')

args = parser.parse_args()


###nc readin
ncfile = args.sourcefile
df = EcoFOCI_netCDF(ncfile)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
data = df.ncreadfile_dic()
df.close()

if args.screen:
    
    for k in data.keys():
        if k == args.varname:
            data[k] = str(data[k])
            print(f"{k}: {data[args.varname]}")

if args.out_config:
    for k in data.keys():
        if k == args.varname:
            data[k] = str(data[k])
            print(f"{k}: {data[args.varname]}")
            data_write = {k:data[args.varname]}
            ConfigParserLocal.write_config("instrument_"+args.varname+"_config.yaml", data_write,'yaml')
    
if args.in_config:
    nc_meta = ConfigParserLocal.get_config("instrument_"+args.varname+"_config.yaml",'yaml')
    editvar = [float(x) for x in nc_meta[args.varname].strip('[').strip(']').split()]
    print(editvar)

    print(f"Setting {args.varname}")
    nchandle = Dataset(args.sourcefile,'a')
    nchandle.variables[args.varname][:] = editvar
    nchandle.close()

    