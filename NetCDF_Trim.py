#!/usr/bin/env python

"""
 Background:
 --------
 Trim_netcdf.py
 
 
 Purpose:
 --------
 Find beginning and ending missing values due to deployment start and end times and recreate nc file
 
 Modifications:
 --------------

 2017-04-05 - SW Bell: Rename utility and remove mooring id requirement
 2016-11-14 - SW Bell: add options to trim based on first/last good time
 2016-09-12 - SW Bell: move to EcoFOCI_MooringAnalysis package and keep only index option for now
 2016-07-29 - SW Bell: simplify EPIC->python time conversion

"""

#System Stack
import datetime
import argparse
import pymysql

#Science Stack
from netCDF4 import Dataset
import numpy as np

#User Stack
import io_utils.ConfigParserLocal as ConfigParserLocal
from calc.EPIC2Datetime import EPIC2Datetime
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF
from io_utils.EcoFOCI_netCDF_write import NetCDF_Trimmed

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 01, 29)
__modified__ = datetime.datetime(2016, 9, 12)
__version__  = "0.2.0"
__status__   = "Development"
__keywords__ = 'netCDF','meta','header', 'deployment', 'recovery'



"""------------------------------- MAIN------------------------------------------------"""

parser = argparse.ArgumentParser(description='Trim NC files')
parser.add_argument('inputpath', metavar='inputpath', type=str, help='path to .nc file')
parser.add_argument('-sd','--start_date',  nargs='+', type=str, help='date of first good point YYYY-MM-DD HH:MM:SS')
parser.add_argument('-ed','--end_date',  nargs='+', type=str, help='date of last good point YYYY-MM-DD HH:MM:SS')
parser.add_argument('--index',  nargs='+', type=int, help='use initial and final index values (0 starting) to trim data')

args = parser.parse_args()

###nc readin/out
ncfile = args.inputpath
df = EcoFOCI_netCDF(ncfile)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
data = df.ncreadfile_dic()

#check for History and make blank if none
if not 'History' in global_atts.keys():
    global_atts['History'] = ''
    
#converttime to datetime
data_dati = EPIC2Datetime(data['time'], data['time2'])
data_dati = np.array(data_dati)


if args.index:
        
    #ranges = 
    time_ind = np.zeros_like(data['time'],dtype=bool)
    time_ind[args.index[0]:args.index[1]] = True
    
    #create new netcdf file
    ncinstance = NetCDF_Trimmed(savefile=ncfile.split('.nc')[0] + '.trimmed_missing.nc')
    ncinstance.file_create()      
    ncinstance.sbeglobal_atts(raw_data_file=global_atts['DATA_CMNT'], Station_Name=global_atts['MOORING'], 
                                Water_Depth=global_atts['WATER_DEPTH'], Inst_Type=global_atts['INST_TYPE'],
                                Water_Mass=global_atts['WATER_MASS'], Experiment=global_atts['EXPERIMENT'], 
                                Project=global_atts['PROJECT'], History=global_atts['History'])
    ncinstance.dimension_init(time_len=len(data['time'][time_ind]))
    ncinstance.variable_init(df._getnchandle_())

    ncinstance.add_coord_data(depth=data['depth'], latitude=data['lat'], longitude=data['lon'],
                                     time1=data['time'][time_ind], time2=data['time2'][time_ind])
    ncinstance.add_data(data=data, trim_index=time_ind)    
    
    ncinstance.close()

if args.start_date and args.end_date:

    time_ind = (data_dati >= datetime.datetime.strptime(" ".join(args.start_date),'%Y-%m-%d %H:%M:%S') ) & \
                            (data_dati <= datetime.datetime.strptime(" ".join(args.end_date),'%Y-%m-%d %H:%M:%S') ) 

    #create new netcdf file
    ncinstance = NetCDF_Trimmed(savefile=ncfile.split('.nc')[0] + '.trimmed_missing.nc')
    ncinstance.file_create()
    ncinstance.sbeglobal_atts(raw_data_file=global_atts['DATA_CMNT'], Station_Name=global_atts['MOORING'], 
                                Water_Depth=global_atts['WATER_DEPTH'], Inst_Type=global_atts['INST_TYPE'],
                                Water_Mass=global_atts['WATER_MASS'], Experiment=global_atts['EXPERIMENT'],
                                Project=global_atts['PROJECT'], History=global_atts['History'])
    ncinstance.dimension_init(time_len=len(data['time'][time_ind]))
    ncinstance.variable_init(df._getnchandle_())

    ncinstance.add_coord_data(depth=data['depth'], latitude=data['lat'], longitude=data['lon'],
                                     time1=data['time'][time_ind], time2=data['time2'][time_ind])
    ncinstance.add_data(data=data, trim_index=time_ind)    
    
    ncinstance.close()

#close file
df.close()
