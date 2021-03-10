"""
 Background:
 ===========

 NetCDF_UV2CSCD.py
 
 
 Purpose:
 ========
 Module to convert geometric U and V current (or wind) components into 
 geographic oriented Speed (CS) and Direction (CD).

 Input is a netcdf file - output is screen or some file.

 History:
 ========

 2019-12-02 - SW Bell: python 3 modifications

 Compatibility:
 ==============
 python >=3.7 
 python 2.7  - will notify when I break it with python3 only routines

"""


import datetime
import argparse
import os

# Science Stack
from netCDF4 import Dataset
import numpy as np
import pandas as pd

# Relative User Stack
parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.sys.path.insert(1, parent_dir)
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF

__author__ = "Shaun Bell"
__email__ = "shaun.bell@noaa.gov"
__created__ = datetime.datetime(2016, 7, 21)
__modified__ = datetime.datetime(2019, 12, 2)
__version__ = "0.2.0"
__status__ = "Development"

"""------------------------------- MAIN--------------------------------------------"""

parser = argparse.ArgumentParser(
    description="RCM archive update. \
    Swap U/V, Update Direction from U and V and display info"
)
parser.add_argument(
    "sourcefile", metavar="sourcefile", type=str, help="complete path to epic file"
)
parser.add_argument(
    "-calc_speed",
    "--calc_speed",
    action="store_true",
    help="Calculate speed and dir from U/V",
)
parser.add_argument(
    "-swap_uv", "--swap_uv", action="store_true", help="Swap U and V components"
)
args = parser.parse_args()

# open and read data
ncfile = args.sourcefile
df = EcoFOCI_netCDF(ncfile)
global_atts = df.get_global_atts()
nchandle = df._getnchandle_()
vars_dic = df.get_vars()
ncdata = df.ncreadfile_dic()

####
# quick summary output
dfp = pd.DataFrame()

if len(ncdata["time"]) > 1:
    print("\n\n\n\n\n\n")
    print("Filename - {0} \n".format(args.sourcefile))
    for var in vars_dic.keys():
        v_atts = df.get_vars_attributes(var)
        try:
            ncdata[var][ncdata[var] >= 1e34] = np.nan
        except:
            pass
        try:
            dfp[var] = ncdata[var][:, 0, 0, 0]
        except:
            try:
                dfp[var] = ncdata[var]
            except:
                pass
print(dfp)


if args.swap_uv:

    # swap u and vi in archive file
    temp = ncdata["U_320"][:, 0, 0, 0]
    nchandle.variables["U_320"][:, 0, 0, 0] = ncdata["V_321"][:, 0, 0, 0]
    nchandle.variables["V_321"][:, 0, 0, 0] = temp

    update = "U and V swapped in initial archive creation.  Corrected."

if args.calc_speed:

    CD = np.zeros_like(ncdata["U_320"])
    for ind, value in enumerate(ncdata["U_320"][:, 0, 0, 0]):
        if value > 1e34:
            CD[ind, 0, 0, 0] = 1e35
        else:
            CD[ind, 0, 0, 0] = (
                np.rad2deg(
                    np.arctan2(
                        -1 * ncdata["U_320"][ind, 0, 0, 0],
                        -1 * ncdata["V_321"][ind, 0, 0, 0],
                    )
                )
                + 180
            )
    nchandle.variables["CD_310"][:, 0, 0, 0] = CD[:, 0, 0, 0]
    nchandle.variables["CS_300"][:, 0, 0, 0] = np.sqrt(
        ncdata["U_320"][:, 0, 0, 0] ** 2 + ncdata["V_321"][:, 0, 0, 0] ** 2
    )

    update = "CD - direction, recalculated from mag dec corrected U/V components "

if not "History" in global_atts.keys():
    print("adding history attribute")
    histtime = datetime.datetime.utcnow()
    nchandle.setncattr(
        "History",
        "{histtime:%B %d, %Y %H:%M} UTC - {history} ".format(
            histtime=histtime, history=update
        ),
    )
else:
    print("updating history attribute")
    histtime = datetime.datetime.utcnow()
    nchandle.setncattr(
        "History",
        global_atts["History"]
        + "\n"
        + "{histtime:%B %d, %Y %H:%M} UTC - {history}".format(
            histtime=histtime, history=update
        ),
    )


df.close()
