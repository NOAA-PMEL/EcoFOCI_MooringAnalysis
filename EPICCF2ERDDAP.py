#!/usr/bin/env python

"""
 Background:
 --------
 EPICCF2ERDDAP.py


 Purpose:
 --------
 Add the cdm/cf_role datatype for erddap compatibility
    - add variable and string length dimension
    - populate variable with id value

 Documentation:
 --------------
the cdm_data_type (which meaets the ACDDD metadata standard) complies with the Discrete
    Sampling Geometry of the CF 1.6 standards

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
    "cdm_data_type",
    metavar="cdm_data_type",
    type=str,
    help="""add global attribute field for discrete sampling geometry.
            Options: Point, TimeSeries, Trajectory, 
            Profile, TimeSeriesProfile, TrajectoryProfile, Other""",
)
parser.add_argument(
    "ind_dim",
    metavar="ind_dim",
    type=str,
    help="indexing dimension - eg. record_number, depth, time",
)
parser.add_argument(
    "ind_val",
    metavar="ind_val",
    type=str,
    help="indexing value - eg. divenumber, mooringid, ctd cast number",
)
args = parser.parse_args()


def choose_cdm(cdm_type=None):
    if cdm_type in ["Point"]:
        cf_role = None
        id_name = None
    elif cdm_type in ["Profile"]:
        cf_role = "profile_id"
        id_name = "profile_id"
    elif cdm_type in ["TimeSeries"]:
        cf_role = "timeseries_id"
        id_name = "station_id"
    elif cdm_type in ["TimeSeriesProfile"]:
        cf_role = "profile_id"
        id_name = "station_id"
    elif cdm_type in ["Trajectory"]:
        cf_role = "trajectory_id"
        id_name = "trajectory_id"
    elif cdm_type in ["TrajectoryProfile"]:
        cf_role = "profile_id"
        id_name = "station_id"
    elif cdm_type in ["Other"]:
        cf_role = "other"
        id_name = "id"
    else:
        cf_role = None
        id_name = None

    return (cf_role, id_name)


"---"

df = EcoFOCI_netCDF(args.sourcefile)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
nchandle = df._getnchandle_()
data = df.ncreadfile_dic()

(cf_role, id_name) = choose_cdm(args.cdm_data_type)

print(id_name)
try:
    nchandle.createDimension("id_strlen", len(args.ind_val))
    nchandle.createVariable(id_name, "S1", dimensions=(args.ind_dim, "id_strlen"))
    nchandle.variables[id_name].cf_role = cf_role
    nchandle.variables[id_name].long_name = cf_role
except:
    print(f"Dimension: {args.cdm_data_type}, Variable: {args.ind_dim} - not added")

# fill with default values
print(args.ind_val)
nchandle.variables[id_name][:] = stringtochar(
    np.array(len(nchandle.dimensions[args.ind_dim]) * [args.ind_val])
)


# add missing value attribute
for key, val in enumerate(vars_dic):
    nchandle.variables[val].fill_value = 1.0e35


df.close()
