#!/usr/bin/env python

"""
 Background:
 --------
 NetCDF_ReplaceVarValue.py
 
 
 Purpose:
 --------
 Replaces designated variable in EPIC Format .nc files with 1e+35 (or any value)
 
 
 Usage:
 ------
 


 Built using Anaconda packaged Python:


"""

# Standard library.
import datetime, sys, os

# System Stack
import argparse
from netCDF4 import Dataset
import numpy as np

# Relative User Stack
parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.sys.path.insert(1, parent_dir)
from io_utils import ConfigParserLocal
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF


__author__ = "Shaun Bell"
__email__ = "shaun.bell@noaa.gov"
__created__ = datetime.datetime(2014, 1, 29)
__modified__ = datetime.datetime(2014, 1, 29)
__version__ = "0.2.0"
__status__ = "Development"
__keywords__ = "netCDF", "meta", "header", "QC"


def repl_var(nchandle, var_name, val=1e35):
    nchandle.variables[var_name][:] = np.ones_like(
        nchandle.variables[var_name][:]
    ) * float(val)
    return


"""------------------------------- MAIN--------------------------------------------"""

parser = argparse.ArgumentParser(
    description="Replace EPIC Variable with 1e35 for all depths"
)
parser.add_argument(
    "sourcefile", metavar="sourcefile", type=str, help="complete path to netcdf file"
)
parser.add_argument(
    "user_var", metavar="user_var", type=str, help="EPIC Key Code or variable name"
)
parser.add_argument("Value", metavar="Value", type=str, help="replacement value")

args = parser.parse_args()

###nc readin
ncfile = args.sourcefile
df = EcoFOCI_netCDF(ncfile)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
data = df.ncreadfile_dic()

print(ncfile.split("/")[-1])
repl_var(df._getnchandle_(), args.user_var, val=args.Value)

df.close()
