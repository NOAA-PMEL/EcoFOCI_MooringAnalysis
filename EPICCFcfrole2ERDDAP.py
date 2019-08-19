#!/usr/bin/env python

"""
 Background:
 --------
 EPICCFcfrole2ERDDAP.py

 Usage:
 ------

 python EPICCFcfrole2ERDDAP.py {file} depth DY1701 

 Purpose:
 --------
 Add a variable to a netcdf file

 History:
 --------

 2016-06-10: Update program so that it pulls possible new variables from epic.json file
 2016-08-10: transfer routine to EcoFOCI_MooringAnalysis package to simplify and unify

"""

# System Stack
import datetime
import argparse
import os

# Science Stack
from netCDF4 import Dataset
from netCDF4 import stringtochar
import numpy as np

# User Defined Stack
from io_utils import ConfigParserLocal
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF


__author__ = "Shaun Bell"
__email__ = "shaun.bell@noaa.gov"
__created__ = datetime.datetime(2014, 1, 29)
__modified__ = datetime.datetime(2016, 8, 10)
__version__ = "0.2.0"
__status__ = "Development"
__keywords__ = "netCDF", "meta", "header"


"""------------------------------- MAIN------------------------------------------------"""

parser = argparse.ArgumentParser(
    description="convert netcdf file to erddap formatted file"
)
parser.add_argument(
    "sourcefile", metavar="sourcefile", type=str, help="path to .nc files"
)
parser.add_argument(
    "record_var",
    metavar="record_var",
    type=str,
    help="variable name of length variable",
)
parser.add_argument(
    "varidname", metavar="varidname", type=str, help="value of id variable"
)
parser.add_argument(
    "cdm_data_type",
    metavar="cdm_data_type",
    type=str,
    help="""add global attribute field for discrete sampling geometry.
            Options: Point, TimeSeries, Trajectory, 
            Profile, TimeSeriesProfile, TrajectoryProfile""",
)

args = parser.parse_args()


def choose_cdm(cdm_type=None):
    if cdm_type in ["Point"]:
        cf_role = None
    elif cdm_type in ["Profile"]:
        cf_role = "profile_id"
    elif cdm_type in ["TimeSeries"]:
        cf_role = "timeseries_id"
    elif cdm_type in ["TimeSeriesProfile"]:
        cf_role = "profile_id"
    elif cdm_type in ["Trajectory"]:
        cf_role = "trajectory_id"
    elif cdm_type in ["TrajectoryProfile"]:
        cf_role = "profile_id"
    else:
        cf_role = None
    return cf_role


"---"
df = EcoFOCI_netCDF(args.sourcefile)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
nchandle = df._getnchandle_()
data = df.ncreadfile_dic()

cf_role = choose_cdm(args.cdm_data_type)

try:
    nchandle.createDimension("id_strlen", len(args.varidname))
except:
    pass

try:
    nchandle.createVariable(cf_role, "S1", dimensions=(args.record_var, "id_strlen"))
    nchandle.variables[cf_role].cf_role = cf_role
    nchandle.variables[cf_role].long_name = cf_role

except:
    print("{0} - not added".format(cf_role))

# fill with default values
print(args.varidname)
nchandle.variables[cf_role][:] = stringtochar(
    np.array(len(nchandle.dimensions[args.record_var]) * [args.varidname])
)


# add missing value attribute
for key, val in enumerate(vars_dic):
    nchandle.variables[val].fill_value = 1.0e35


df.close()
