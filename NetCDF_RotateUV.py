"""
 Background:
 ===========

 NetCDF_RotateUV.py
 
 
 Purpose:
 ========

 Rotate 1D ADCP records to specified degree 

 ToDO:
 =====

 Make valid for RCM as well

 Reference:
 ==========

 https://en.wikipedia.org/wiki/Rotation_of_axes


 History:
 ========

 2019-05-21: for timeseries plots, an error in calculation used corrected udata to correct vdata 
 	when rotating - logic was updated here to be consistent (but error was not in this utlity)

 Compatibility:
 ==============
 python >=3.6 
 python 2.7 

"""

# System Stack
import datetime
import argparse

# Science Stack
import numpy as np

# User Stack
from calc.EPIC2Datetime import EPIC2Datetime
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF
import io_utils.EcoFOCI_netCDF_write as eNCw

__author__ = "Shaun Bell"
__email__ = "shaun.bell@noaa.gov"
__created__ = datetime.datetime(2014, 1, 29)
__modified__ = datetime.datetime(2016, 9, 16)
__version__ = "0.2.0"
__status__ = "Development"
__keywords__ = "netCDF", "meta", "header"

"""------------------------------- MAIN------------------------------------------------"""

parser = argparse.ArgumentParser(
    description="Make a multidimensional nc file into multiple one dimensional files"
)
parser.add_argument("inputpath", metavar="inputpath", type=str, help="path to .nc file")
parser.add_argument(
    "-rot", "--rotate", type=float, help="rotate vectors angle provided", default=0.0
)

args = parser.parse_args()

# read in netcdf data file
df = EcoFOCI_netCDF(args.inputpath)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
data = df.ncreadfile_dic()

print(data)

if args.rotate != 0.0:
    # when rotating vectors - positive(+) rotation is equal to ccw of the axis (cw of vector)
    #                      - negative(-) rotation is equal to cw of the axis (ccw of the vector)
    print("rotating vectors")
    angle_offset_rad = np.deg2rad(args.rotate)
    uprime = data["u_1205"] * np.cos(angle_offset_rad) + data["v_1206"] * np.sin(
        angle_offset_rad
    )
    vprime = -1.0 * data["u_1205"] * np.sin(angle_offset_rad) + data["v_1206"] * np.cos(
        angle_offset_rad
    )

    data["v_1206"] = vprime
    data["u_1205"] = uprime

    time_ind = np.ones_like(data["time"], dtype=bool)
    output_file = args.inputpath.replace(
        ".nc", "_{deg}d_rot.nc".format(deg=int(args.rotate))
    )
    ncinstance = eNCw.NetCDF_Copy_Struct(savefile=output_file)
    ncinstance.file_create()
    ncinstance.sbeglobal_atts(
        raw_data_file=global_atts["DATA_CMNT"],
        Station_Name=global_atts["MOORING"],
        Water_Depth=global_atts["WATER_DEPTH"],
        Inst_Type=global_atts["INST_TYPE"],
        Water_Mass=global_atts["WATER_MASS"],
        Experiment=["EXPERIMENT"],
    )
    ncinstance.dimension_init(time_len=len(data["time"]))
    ncinstance.variable_init(vars_dic)
    try:
        ncinstance.add_coord_data(
            depth=data["depth"],
            latitude=data["lat"],
            longitude=data["lon"],
            time1=data["time"],
            time2=data["time2"],
        )
    except:
        ncinstance.add_coord_data(
            depth=data["depth"],
            latitude=data["latitude"],
            longitude=data["longitude"],
            time1=data["time"],
            time2=data["time2"],
        )
    ncinstance.add_data(data=data, depthindex=0)
    ncinstance.add_history("U,V rotated: {rotate}".format(rotate=args.rotate))
    ncinstance.close()

df.close()
