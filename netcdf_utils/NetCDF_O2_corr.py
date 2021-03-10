#!/usr/bin/env python

"""
 NetCDF_O2_corr.py

 calculate salinity from conductivity.

 History:
 ========

 2019-01-03 Put in flag for correcting Aandera optode values vs SBE-43 values (mmole/l vs umole/kg)


 Compatibility:
 ==============
 python >=3.6 - not tested, unlikely to work without updates
 python 2.7 - Tested and developed for

"""

import datetime
import argparse
import sys

# Science Stack
from netCDF4 import Dataset
import numpy as np
import seawater as sw

# User Stack
import calc.aanderaa_corrO2_sal as O2_sal_corr
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF

__author__ = "Shaun Bell"
__email__ = "shaun.bell@noaa.gov"
__created__ = datetime.datetime(2016, 11, 1)
__modified__ = datetime.datetime(2016, 11, 1)
__version__ = "0.1.0"
__status__ = "Development"
__keywords__ = "O2", "salinity correction"


"""------------------------------- MAIN--------------------------------------------"""

parser = argparse.ArgumentParser(
    description="Correct Oxygen in Timeseries using salinity but not depth"
)
parser.add_argument(
    "sourcefile", metavar="sourcefile", type=str, help="complete path to epic file"
)
parser.add_argument(
    "sal_source",
    metavar="sal_source",
    type=str,
    help="quick description of source of salinity for correction",
)
parser.add_argument(
    "-aanderaa",
    "--aanderaa",
    action="store_true",
    help="aanderaa optode with Molar output",
)
parser.add_argument(
    "-sbe43", "--sbe43", action="store_true", help="sbe43 optode with Mmkg output"
)
args = parser.parse_args()


ncfile = args.sourcefile
df = EcoFOCI_netCDF(ncfile)
global_atts = df.get_global_atts()
nchandle = df._getnchandle_()
vars_dic = df.get_vars()
ncdata = df.ncreadfile_dic()

O2_corr = O2_sal_corr.O2_sal_comp(
    oxygen_conc=ncdata["O_65"][:, 0, 0, 0],
    salinity=ncdata["S_41"][:, 0, 0, 0],
    temperature=ncdata["T_20"][:, 0, 0, 0],
)

O2psat_corr = O2_sal_corr.O2PercentSat(
    oxygen_conc=O2_corr,
    temperature=ncdata["T_20"][:, 0, 0, 0],
    salinity=ncdata["S_41"][:, 0, 0, 0],
    pressure=ncdata["depth"][:],
)

if args.aanderaa:
    O2_corr_umkg = O2_sal_corr.O2_molar2umkg(
        oxygen_conc=O2_corr,
        temperature=ncdata["T_20"][:, 0, 0, 0],
        salinity=ncdata["S_41"][:, 0, 0, 0],
        pressure=ncdata["depth"][:],
    )
if args.sbe43:
    sys.exit("Correction not currently valid for SBE-43.")


O2_corr_umkg[np.where(np.isnan(O2_corr_umkg))] = 1e35
O2psat_corr[np.where(np.isnan(O2psat_corr))] = 1e35

nchandle.variables["O_65"][:, 0, 0, 0] = O2_corr_umkg
nchandle.variables["OST_62"][:, 0, 0, 0] = O2psat_corr

update = "Oxygen Concentration and Saturation corrected for salinity using {0}".format(
    args.sal_source
)

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
