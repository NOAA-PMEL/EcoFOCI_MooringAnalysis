#!/usr/bin/env python

"""
 Background:
 ===========

 NetCDF_Time_Tools.py
 
 
 Purpose:
 ======== 
 Collection of various time tools

 Convert EPIC file to CF file (in time)
 Round to nearest Hour
 Interpolate to nearest Hour (modifies data too)
 Trim to specified start and end dates

 Usage:
 ======



 History:
 ========
 2018-08-17: merge trim tools into this routine, make trim tools to be 2D (ADCP)
 2016-07-25: update EPIC to CF time routines to be in EPIC2Datetime.py and removed time calls
    in this routine.
 2016-08-09: change routine references and add toe EcoFOCI_MooringAnalysis package
 2016-12-16: combine all tools for time edits together

 Compatibility:
 ==============
 python >=3.6 ? 
 python 2.7 - Tested

"""

# System Stack
import datetime
import argparse
import sys

# Science Stack
from netCDF4 import Dataset, date2num, num2date

import numpy as np


import warnings

warnings.filterwarnings(action="ignore", message="numpy.dtype size changed,")

import pandas as pd

# User Stack
from calc.EPIC2Datetime import EPIC2Datetime, get_UDUNITS, Datetime2EPIC
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF
from io_utils.EcoFOCI_netCDF_write import (
    NetCDF_Copy_Struct,
    NetCDF_Trimmed,
    NetCDF_Trimmed_2D,
)
from io_utils.EcoFOCI_netCDF_write import (
    CF_NC_2D,
    CF_NC,
    CF_NC_Profile,
    CF_NetCDF_Trimmed,
)
from io_utils.time_helper import roundTime, interp2hour

__author__ = "Shaun Bell"
__email__ = "shaun.bell@noaa.gov"
__created__ = datetime.datetime(2014, 1, 29)
__modified__ = datetime.datetime(2016, 8, 9)
__version__ = "0.4.0"
__status__ = "Development"
__keywords__ = "netCDF", "meta", "header", "QC"


"""------------------------------- MAIN--------------------------------------------"""

parser = argparse.ArgumentParser(description="Tools to manipulate Time in files")
parser.add_argument(
    "sourcefile", metavar="sourcefile", type=str, help="complete path to epic file"
)
parser.add_argument(
    "operation",
    metavar="operation",
    type=str,
    help='"CF_Convert", "RoundTime" to nearest hour, \
        "Interpolate" to nearest hour, Add "Offset", \
        "Trim" to start and end dates',
)
parser.add_argument(
    "--time_since_str",
    nargs="+",
    type=str,
    help='CF_Convert: cf compliant time since str (eg. "days since 1800-01-01"',
)
parser.add_argument(
    "-is2D",
    "--is2D",
    action="store_true",
    help="convert files like ADCP that have two varying dimensions",
)
parser.add_argument(
    "-isProfile",
    "--isProfile",
    action="store_true",
    help="convert files like CTD data that have one time entry",
)
parser.add_argument(
    "--offset", type=int, help="Offset: offset in seconds if chosen as operation"
)
parser.add_argument(
    "--featureType", type=str, help="DSG featureType - see CF standards"
)
parser.add_argument(
    "--trim_bounds",
    nargs=2,
    type=str,
    help="Trim: start and end boundarys for trimming (inclusive)\
        Format: yyyy-mm-ddThh:mm:ss start-date end-date",
)
parser.add_argument(
    "--iscf",
    action="store_true",
    help="if netcdf file is CF compliant time, this will use CF flavored tools",
)

args = parser.parse_args()


if args.featureType:
    featureType = args.featureType
else:
    featureType = ""


if (args.operation in ["CF", "CF Convert", "CF_Convert"]) and not args.iscf:
    # generates near file
    if args.is2D:

        df = EcoFOCI_netCDF(args.sourcefile)
        global_atts = df.get_global_atts()
        vars_dic = df.get_vars()
        ncdata = df.ncreadfile_dic()

        # Convert two word EPIC time to python datetime.datetime representation and then format for CF standards
        dt_from_epic = EPIC2Datetime(ncdata["time"], ncdata["time2"])
        if args.time_since_str:
            time_since_str = " ".join(args.time_since_str)
            CF_time = get_UDUNITS(dt_from_epic, time_since_str)
        else:
            time_since_str = "days since 1900-01-01"
            CF_time = get_UDUNITS(dt_from_epic, time_since_str)

        try:
            History = global_atts["History"]
        except:
            History = ""

        ###build/copy attributes and fill if empty
        try:
            data_cmnt = global_atts["DATA_CMNT"]
        except:
            data_cmnt = ""

        try:
            data_mooring = global_atts["MOORING"]
        except:
            data_mooring = ""

        ncinstance = CF_NC_2D(savefile=args.sourcefile.replace(".nc", ".cf.nc"))
        ncinstance.file_create()
        ncinstance.sbeglobal_atts(
            raw_data_file=data_cmnt,
            Station_Name=data_mooring,
            Water_Depth=global_atts["WATER_DEPTH"],
            Instrument_Type=global_atts["INST_TYPE"],
            Water_Mass=global_atts["WATER_MASS"],
            Experiment=global_atts["EXPERIMENT"],
            Project=global_atts["PROJECT"],
            History=History,
            featureType=featureType,
        )
        ncinstance.dimension_init(time_len=len(CF_time), depth_len=len(ncdata["depth"]))
        ncinstance.variable_init(df, time_since_str)
        try:
            ncinstance.add_coord_data(
                depth=ncdata["depth"],
                latitude=ncdata["lat"],
                longitude=ncdata["lon"],
                time=CF_time,
            )
        except KeyError:
            ncinstance.add_coord_data(
                depth=ncdata["depth"],
                latitude=ncdata["latitude"],
                longitude=ncdata["longitude"],
                time=CF_time,
            )

        ncinstance.add_data(ncdata)
        ncinstance.add_history("EPIC two time-word key converted to udunits")
        ncinstance.close()
        df.close()

    elif args.isProfile:

        df = EcoFOCI_netCDF(args.sourcefile)
        global_atts = df.get_global_atts()
        vars_dic = df.get_vars()
        ncdata = df.ncreadfile_dic()

        # Convert two word EPIC time to python datetime.datetime representation and then format for CF standards
        dt_from_epic = EPIC2Datetime(ncdata["time"], ncdata["time2"])
        if args.time_since_str:
            time_since_str = " ".join(args.time_since_str)
            CF_time = get_UDUNITS(dt_from_epic, time_since_str)
        else:
            time_since_str = "days since 1900-01-01"
            CF_time = get_UDUNITS(dt_from_epic, time_since_str)

        ###build/copy attributes and fill if empty
        try:
            History = global_atts["History"]
        except:
            History = ""

        try:
            data_cmnt = global_atts["DATA_CMNT"]
        except:
            data_cmnt = ""

        try:
            data_mooring = global_atts["MOORING"]
        except:
            data_mooring = ""

        try:
            data_insttype = global_atts["INST_TYPE"]
            data_experiment = global_atts["EXPERIMENT"]
            data_project = global_atts["PROJECT"]
        except:
            data_insttype = ""
            data_experiment = ""
            data_project = ""

        try:
            station_name = global_atts["STATION_NAME"]
        except:
            try:
                station_name = global_atts["STATION"]
            except:
                station_name = ""

        if "depth" in ncdata.keys():
            depthkey = "depth"
        else:
            depthkey = "dep"

        ncinstance = CF_NC_Profile(savefile=args.sourcefile.replace(".nc", ".cf.nc"))
        ncinstance.file_create()
        ncinstance.sbeglobal_atts(
            raw_data_file=data_cmnt,
            Station_Name=station_name,
            Water_Depth=global_atts["WATER_DEPTH"],
            Instrument_Type=global_atts["INST_TYPE"],
            Water_Mass=global_atts["WATER_MASS"],
            History=History,
            featureType=featureType,
            barometer=global_atts["BAROMETER"],
            wind_dir=global_atts["WIND_DIR"],
            wind_speed=global_atts["WIND_SPEED"],
            air_temp=global_atts["AIR_TEMP"]
        )
        ncinstance.dimension_init(depth_len=len(ncdata[depthkey]))
        ncinstance.variable_init(df, time_since_str)

        try:
            ncinstance.add_coord_data(
                depth=ncdata[depthkey],
                latitude=ncdata["lat"],
                longitude=ncdata["lon"],
                time=CF_time,
            )
        except KeyError:
            ncinstance.add_coord_data(
                depth=ncdata[depthkey],
                latitude=ncdata["latitude"],
                longitude=ncdata["longitude"],
                time=CF_time,
            )

        ncinstance.add_data(ncdata)
        ncinstance.add_history("EPIC two time-word key converted to udunits")
        ncinstance.close()
        df.close()

    else:

        # read in 1d data file
        df = EcoFOCI_netCDF(args.sourcefile)
        global_atts = df.get_global_atts()
        vars_dic = df.get_vars()
        ncdata = df.ncreadfile_dic()

        # Convert two word EPIC time to python datetime.datetime representation and then format for CF standards
        dt_from_epic = EPIC2Datetime(ncdata["time"], ncdata["time2"])
        if args.time_since_str:
            time_since_str = " ".join(args.time_since_str)
            CF_time = get_UDUNITS(dt_from_epic, time_since_str)
        else:
            time_since_str = "days since 1900-01-01"
            CF_time = get_UDUNITS(dt_from_epic, time_since_str)

        try:
            History = global_atts["History"]
        except:
            History = ""

        ###build/copy attributes and fill if empty
        try:
            data_cmnt = global_atts["DATA_CMNT"]
        except:
            data_cmnt = ""

        try:
            data_mooring = global_atts["MOORING"]
        except:
            data_mooring = ""

        try:
            data_insttype = global_atts["INST_TYPE"]
            data_experiment = global_atts["EXPERIMENT"]
            data_project = global_atts["PROJECT"]
        except:
            data_insttype = ""
            data_experiment = ""
            data_project = ""

        ncinstance = CF_NC(savefile=args.sourcefile.replace(".nc", ".cf.nc"))
        ncinstance.file_create()
        ncinstance.sbeglobal_atts(
            raw_data_file=data_cmnt,
            Station_Name=data_mooring,
            Water_Depth=global_atts["WATER_DEPTH"],
            Instrument_Type=data_insttype,
            Water_Mass=global_atts["WATER_MASS"],
            Experiment=data_experiment,
            Project=data_project,
            History=History,
            featureType=featureType,
        )
        ncinstance.dimension_init(time_len=len(CF_time))
        ncinstance.variable_init(df, time_since_str)
        try:
            ncinstance.add_coord_data(
                depth=ncdata["depth"],
                latitude=ncdata["lat"],
                longitude=ncdata["lon"],
                time=CF_time,
            )
        except KeyError:
            ncinstance.add_coord_data(
                depth=ncdata["depth"],
                latitude=ncdata["latitude"],
                longitude=ncdata["longitude"],
                time=CF_time,
            )

        ncinstance.add_data(ncdata)
        ncinstance.add_history("EPIC two time-word key converted to udunits")
        ncinstance.close()
        df.close()

elif (args.operation in ["RoundTime", "roundtime", "round_time"]) and not args.iscf:
    # Modifies original file
    # read in 1d data file

    df = EcoFOCI_netCDF(args.sourcefile)
    global_atts = df.get_global_atts()
    vars_dic = df.get_vars()
    ncdata = df.ncreadfile_dic()

    # Convert two word EPIC time to python datetime.datetime representation and then format for CF standards
    dt_from_epic = EPIC2Datetime(ncdata["time"], ncdata["time2"])
    dt_updated = [roundTime(x, 3600) for x in dt_from_epic]
    (etime1, etime2) = Datetime2EPIC(dt_updated)
    df.update_epic_time(time=etime1, time2=etime2)
    try:
        df.add_history(global_atts["History"], "Time Round to Nearest Hour")
    except:
        print("History attribute does not exist to edit")
    df.close()

elif (args.operation in ["offset", "Offset"]) and not args.iscf:
    # Modifies original file
    # read in 1d data file

    df = EcoFOCI_netCDF(args.sourcefile)
    global_atts = df.get_global_atts()
    vars_dic = df.get_vars()
    ncdata = df.ncreadfile_dic()

    # Convert two word EPIC time to python datetime.datetime representation and then format for CF standards
    dt_from_epic = EPIC2Datetime(ncdata["time"], ncdata["time2"])
    dt_updated = [x + datetime.timedelta(seconds=args.offset) for x in dt_from_epic]
    (etime1, etime2) = Datetime2EPIC(dt_updated)
    df.update_epic_time(time=etime1, time2=etime2)
    try:
        df.add_history(
            global_atts["History"], "Time Offset Applied (seconds):" + args.offset
        )
    except:
        print("History attribute does not exist to edit")
    df.close()

elif (args.operation in ["Interpolate", "interpolate"]) and not args.iscf:
    # creates new file
    if args.is2D:

        # read in 2d data file
        df = EcoFOCI_netCDF(args.sourcefile)
        global_atts = df.get_global_atts()
        vars_dic = df.get_vars()
        ncdata = df.ncreadfile_dic()

        # Convert two word EPIC time to python datetime.datetime representation and then format for CF standards
        dt_from_epic = EPIC2Datetime(ncdata["time"], ncdata["time2"])

        # interp each non-dimension variable to new time
        # put data on hourly grid
        ncdata_new = {}
        min_t = min(dt_from_epic)
        basedate = datetime.datetime(min_t.year, min_t.month, min_t.day, min_t.hour)
        rng = pd.date_range(basedate, max(dt_from_epic), freq="1H").to_pydatetime()
        trng = {k: v for k, v in enumerate(rng)}

        for key in ncdata.keys():
            if not key in [
                "lat",
                "lon",
                "depth",
                "time",
                "time2",
                "dep",
                "latitude",
                "longitude",
            ]:
                for ii, val in enumerate(ncdata["depth"]):
                    temporary = interp2hour(
                        rng, dt_from_epic, {key: ncdata[key][:, ii, 0, 0]}, vlist=[key]
                    )
                    if ii == 0:
                        ncdata_new[key] = (
                            np.ones([len(temporary[key]), len(ncdata["depth"]), 1, 1])
                            * np.nan
                        )
                    ncdata_new[key][:, ii, 0, 0] = temporary[key]

        (etime, etime2) = Datetime2EPIC(trng.values())

        try:
            History = global_atts["History"]
        except:
            History = ""

        ###build/copy attributes and fill if empty
        try:
            data_cmnt = global_atts["DATA_CMNT"]
        except:
            data_cmnt = ""

        ncinstance = NetCDF_Copy_Struct(
            savefile=args.sourcefile.replace(".nc", ".interp.nc")
        )
        ncinstance.file_create()
        ncinstance.sbeglobal_atts(
            raw_data_file=global_atts["DATA_CMNT"],
            Station_Name=global_atts["MOORING"],
            Water_Depth=global_atts["WATER_DEPTH"],
            Instrument_Type=global_atts["INST_TYPE"],
            Water_Mass=global_atts["WATER_MASS"],
            Experiment=["EXPERIMENT"],
            Project=global_atts["PROJECT"],
            History=History,
            featureType=featureType,
        )
        ncinstance.dimension_init(time_len=len(etime), depth_len=len(ncdata["depth"]))
        ncinstance.variable_init(vars_dic)
        try:
            ncinstance.add_coord_data(
                depth=ncdata["depth"],
                latitude=ncdata["lat"],
                longitude=ncdata["lon"],
                time1=etime,
                time2=etime2,
            )
        except:
            ncinstance.add_coord_data(
                depth=ncdata["depth"],
                latitude=ncdata["latitude"],
                longitude=ncdata["longitude"],
                time1=etime,
                time2=etime2,
            )
        ncinstance.add_data(data=ncdata_new, is2D=True)
        ncinstance.add_history("Data Interpolated Linearly to be on the hour")
        ncinstance.close()
        df.close()

    else:

        # read in 1d data file
        df = EcoFOCI_netCDF(args.sourcefile)
        global_atts = df.get_global_atts()
        vars_dic = df.get_vars()
        ncdata = df.ncreadfile_dic()

        # Convert two word EPIC time to python datetime.datetime representation and then format for CF standards
        dt_from_epic = EPIC2Datetime(ncdata["time"], ncdata["time2"])

        # interp each non-dimension variable to new time
        # put data on hourly
        ncdata_new = {}
        min_t = min(dt_from_epic)
        basedate = datetime.datetime(min_t.year, min_t.month, min_t.day, min_t.hour)
        rng = pd.date_range(basedate, max(dt_from_epic), freq="1H").to_pydatetime()
        trng = {k: v for k, v in enumerate(rng)}
        for key in ncdata.keys():
            if not key in [
                "lat",
                "lon",
                "depth",
                "time",
                "time2",
                "dep",
                "latitude",
                "longitude",
            ]:
                temporary = interp2hour(
                    rng, dt_from_epic, {key: ncdata[key][:, 0, 0, 0]}, vlist=[key]
                )
                ncdata_new[key] = np.ones([len(temporary[key]), 1, 1, 1]) * np.nan
                ncdata_new[key][:, 0, 0, 0] = temporary[key]

        (etime, etime2) = Datetime2EPIC(trng.values())

        try:
            History = global_atts["History"]
        except:
            History = ""

        ###build/copy attributes and fill if empty
        try:
            data_cmnt = global_atts["DATA_CMNT"]
        except:
            data_cmnt = ""

        ncinstance = NetCDF_Copy_Struct(
            savefile=args.sourcefile.replace(".nc", ".interp.nc")
        )
        ncinstance.file_create()
        ncinstance.sbeglobal_atts(
            raw_data_file=global_atts["DATA_CMNT"],
            Station_Name=global_atts["MOORING"],
            Water_Depth=global_atts["WATER_DEPTH"],
            Instrument_Type=global_atts["INST_TYPE"],
            Water_Mass=global_atts["WATER_MASS"],
            Experiment=["EXPERIMENT"],
            Project=global_atts["PROJECT"],
            History=History,
            featureType=featureType,
        )
        ncinstance.dimension_init(time_len=len(etime))
        ncinstance.variable_init(vars_dic)
        try:
            ncinstance.add_coord_data(
                depth=ncdata["depth"],
                latitude=ncdata["lat"],
                longitude=ncdata["lon"],
                time1=etime,
                time2=etime2,
            )
        except:
            ncinstance.add_coord_data(
                depth=ncdata["depth"],
                latitude=ncdata["latitude"],
                longitude=ncdata["longitude"],
                time1=etime,
                time2=etime2,
            )
        ncinstance.add_data(data=ncdata_new, is2D=False)
        ncinstance.add_history("Data Interpolated Linearly to be on the hour")
        ncinstance.close()
        df.close()

elif (args.operation in ["Trim", "trim"]) and not args.iscf:

    if not args.trim_bounds:
        sys.exit("Must pass the --trim_bounds flag")

    if len(args.trim_bounds[0]) <= 8:
        sys.exit("Time format should be yyy-mm-ddThh:mm:ss")

    if args.is2D:

        df = EcoFOCI_netCDF(args.sourcefile)
        global_atts = df.get_global_atts()
        vars_dic = df.get_vars()
        ncdata = df.ncreadfile_dic()

        if "lat" in vars_dic:
            lat = "lat"
            lon = "lon"
        elif "latitude" in vars_dic:
            lat = "latitude"
            lon = "longitude"

        # converttime to datetime
        data_dati = EPIC2Datetime(ncdata["time"], ncdata["time2"])
        data_dati = np.array(data_dati)

        time_ind = (
            data_dati
            >= datetime.datetime.strptime(args.trim_bounds[0], "%Y-%m-%dT%H:%M:%S")
        ) & (
            data_dati
            <= datetime.datetime.strptime(args.trim_bounds[1], "%Y-%m-%dT%H:%M:%S")
        )

        # create new netcdf file
        ncinstance = NetCDF_Trimmed_2D(
            savefile=(args.sourcefile).replace(".nc", ".trimmed_missing.nc")
        )
        ncinstance.file_create()
        ncinstance.sbeglobal_atts(
            raw_data_file=global_atts["DATA_CMNT"],
            Station_Name=global_atts["MOORING"],
            Water_Depth=global_atts["WATER_DEPTH"],
            Instrument_Type=global_atts["INST_TYPE"],
            Water_Mass=global_atts["WATER_MASS"],
            Experiment=global_atts["EXPERIMENT"],
            Project=global_atts["PROJECT"],
        )
        ncinstance.dimension_init(
            time_len=len(ncdata["time"][time_ind]), depth_len=len(ncdata["depth"])
        )
        ncinstance.variable_init(df._getnchandle_())

        ncinstance.add_coord_data(
            depth=ncdata["depth"],
            latitude=ncdata[lat],
            longitude=ncdata[lon],
            time1=ncdata["time"][time_ind],
            time2=ncdata["time2"][time_ind],
        )
        ncinstance.add_data(data=ncdata, trim_index=time_ind)
        ncinstance.add_history(df._getnchandle_(), new_history="Data Trimmed")

        ncinstance.close()

    elif args.isProfile:
        sys.exit(
            "Profiles rarely can be trimmed by date unless prawler or glider - exiting"
        )

    else:

        df = EcoFOCI_netCDF(args.sourcefile)
        global_atts = df.get_global_atts()
        vars_dic = df.get_vars()
        ncdata = df.ncreadfile_dic()

        if "lat" in vars_dic:
            lat = "lat"
            lon = "lon"
        elif "latitude" in vars_dic:
            lat = "latitude"
            lon = "longitude"

        # converttime to datetime
        data_dati = EPIC2Datetime(ncdata["time"], ncdata["time2"])
        data_dati = np.array(data_dati)

        time_ind = (
            data_dati
            >= datetime.datetime.strptime(args.trim_bounds[0], "%Y-%m-%dT%H:%M:%S")
        ) & (
            data_dati
            <= datetime.datetime.strptime(args.trim_bounds[1], "%Y-%m-%dT%H:%M:%S")
        )

        # create new netcdf file
        ncinstance = NetCDF_Trimmed(
            savefile=(args.sourcefile).replace(".nc", ".trimmed_missing.nc")
        )
        ncinstance.file_create()
        ncinstance.sbeglobal_atts(
            raw_data_file=global_atts["DATA_CMNT"],
            Station_Name=global_atts["MOORING"],
            Water_Depth=global_atts["WATER_DEPTH"],
            Instrument_Type=global_atts["INST_TYPE"],
            Water_Mass=global_atts["WATER_MASS"],
            Experiment=global_atts["EXPERIMENT"],
            Project=global_atts["PROJECT"],
        )
        ncinstance.dimension_init(time_len=len(ncdata["time"][time_ind]))
        ncinstance.variable_init(df._getnchandle_())

        ncinstance.add_coord_data(
            depth=ncdata["depth"],
            latitude=ncdata[lat],
            longitude=ncdata[lon],
            time1=ncdata["time"][time_ind],
            time2=ncdata["time2"][time_ind],
        )
        ncinstance.add_data(data=ncdata, trim_index=time_ind)
        ncinstance.add_history(df._getnchandle_(), new_history="Data Trimmed")

        ncinstance.close()

    # close file
    df.close()

### is a cf file
elif (args.operation in ["Trim", "trim"]) and args.iscf:

    if not args.trim_bounds:
        sys.exit("Must pass the --trim_bounds flag")

    if len(args.trim_bounds[0]) <= 8:
        sys.exit("Time format should be yyy-mm-ddThh:mm:ss")

    if args.is2D:
        sys.exit("2D CF compliant trim not yet implemented - exiting")

    elif args.isProfile:
        sys.exit(
            "Profiles rarely can be trimmed by date unless prawler or glider - exiting"
        )

    else:

        df = EcoFOCI_netCDF(args.sourcefile)
        global_atts = df.get_global_atts()
        vars_dic = df.get_vars()
        ncdata = df.ncreadfile_dic()

        if "lat" in vars_dic:
            lat = "lat"
            lon = "lon"
        elif "latitude" in vars_dic:
            lat = "latitude"
            lon = "longitude"

        # converttime to datetime
        data_dati = num2date(ncdata["time"], args.time_since_str[0])
        data_dati = np.array(data_dati)

        time_ind = (
            data_dati
            >= datetime.datetime.strptime(args.trim_bounds[0], "%Y-%m-%dT%H:%M:%S")
        ) & (
            data_dati
            <= datetime.datetime.strptime(args.trim_bounds[1], "%Y-%m-%dT%H:%M:%S")
        )

        # create new netcdf file
        ncinstance = CF_NetCDF_Trimmed(
            savefile=(args.sourcefile).replace(".nc", ".trimmed.nc")
        )
        ncinstance.file_create()
        ncinstance.cp_global_atts(df._getnchandle_())
        ncinstance.dimension_init(time_len=len(ncdata["time"][time_ind]))
        ncinstance.variable_init(df._getnchandle_())

        ncinstance.add_coord_data(
            depth=ncdata["depth"],
            latitude=ncdata[lat],
            longitude=ncdata[lon],
            time=ncdata["time"][time_ind],
        )
        ncinstance.add_data(data=ncdata, trim_index=time_ind)
        ncinstance.add_history(df._getnchandle_(), new_history="Data Trimmed")

        ncinstance.close()

    # close file
    df.close()

else:
    print("Invalid Option or combination of options Selected")
