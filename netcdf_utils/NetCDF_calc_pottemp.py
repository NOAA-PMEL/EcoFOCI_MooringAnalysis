#!/usr/bin/env python

"""
NetCDF_calc_pottemp.py

calculate  potential temperature.

"""

import datetime
import argparse

# Science Stack
from netCDF4 import Dataset
import numpy as np
import seawater as sw

# User Stack
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF

__author__ = "Shaun Bell"
__email__ = "shaun.bell@noaa.gov"
__created__ = datetime.datetime(2016, 11, 1)
__modified__ = datetime.datetime(2016, 11, 1)
__version__ = "0.1.0"
__status__ = "Development"
__keywords__ = "adcp", "shear", "vector", "derivations"


"""------------------------------------- salinity Calc -----------------------------------"""


def pottemp_calculation(salinity, temperature, pressure, depth, no_press=False):
    """ Calculate Potenital Temperature - Following EOS-80 standards (ITS-90 temp and PSS-78 sal)"""

    if (pressure == -9999.0).any() | (no_press):
        history = "ITS90 Pot. Temp calculated using nominal depth"
        pot_temp = sw.ptmp(salinity, temperature, pressure * 0 + depth)
        pot_temp[np.isnan(pot_temp)] = 1e35
    else:
        history = "ITS90 Pot. Temp calculated using P_1 (recorded pressure)"
        pot_temp = sw.ptmp(salinity, temperature, pressure)

    return (pot_temp, history)


"""------------------------------- MAIN--------------------------------------------"""

parser = argparse.ArgumentParser(
    description="Calculate or update Potential Temperature in Timeseries"
)
parser.add_argument(
    "sourcefile", metavar="sourcefile", type=str, help="complete path to epic file"
)

args = parser.parse_args()


ncfile = args.sourcefile
df = EcoFOCI_netCDF(ncfile)
global_atts = df.get_global_atts()
nchandle = df._getnchandle_()
vars_dic = df.get_vars()
ncdata = df.ncreadfile_dic()

ptem_38, pothist = salinity_calculation(
    ncdata["S_41"][:, 0, 0, 0],
    ncdata["T_20"][:, 0, 0, 0],
    ncdata["P_1"][:, 0, 0, 0],
    ncdata["depth"],
)
nchandle.variables["P_38"][:, 0, 0, 0] = salinity_s41

print("adding history attribute")
if not "History" in global_atts.keys():
    histtime = datetime.datetime.utcnow()
    nchandle.setncattr(
        "History",
        "{histtime:%B %d, %Y %H:%M} UTC - {history} ".format(
            histtime=histtime, history=pothist
        ),
    )
else:
    histtime = datetime.datetime.utcnow()
    nchandle.setncattr(
        "History",
        global_atts["History"]
        + "\n"
        + "{histtime:%B %d, %Y %H:%M} UTC - {history}".format(
            histtime=histtime, history=pothist
        ),
    )

df.close()
