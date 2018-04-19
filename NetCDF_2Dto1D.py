#!/usr/bin/env python

"""
 Background:
 --------
 NetCDF_2Dto1D.py
 
 
 Purpose:
 --------
 Split a netcdf file from two dimensional (Usually Time and Depth) to one dimensional (time)
 	and into multiple files for each depth.

 Modifications:
 --------------

 2016-11-01 - SW Bell: include 'lat','latitude' variations of spelling
 2016-09-16 - SW Bell: Migrate and update routine to be consistent with EcoFOCI_MooringAnalysis package
 2016-07-29 - SW Bell: simplify EPIC->python time conversion


"""

#System Stack
import datetime
import argparse

#Science Stack
import numpy as np

# User Stack
from calc.EPIC2Datetime import EPIC2Datetime
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF
import io_utils.EcoFOCI_netCDF_write as eNCw

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 01, 29)
__modified__ = datetime.datetime(2016, 9, 16)
__version__  = "0.2.0"
__status__   = "Development"
__keywords__ = 'netCDF','meta','header'

"""------------------------------- MAIN------------------------------------------------"""

parser = argparse.ArgumentParser(description='Make a multidimensional nc file into multiple one dimensional files')
parser.add_argument('inputpath', metavar='inputpath', type=str, help='path to .nc file')
parser.add_argument('outputpath', metavar='outputpath', type=str, help='path to .nc file')
parser.add_argument('-d', '--depth', action="store_true", help='split file on depths')

args = parser.parse_args()

#read in netcdf data file
df = EcoFOCI_netCDF(args.inputpath)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
data = df.ncreadfile_dic()

print data
if args.depth:
	if 'dep' in data.keys():
		epic_depth_str = 'dep'
	else:
		epic_depth_str = 'depth'

	for ind_depth, val_depth in enumerate(data[epic_depth_str]):
		time_ind = np.ones_like(data['time'],dtype=bool)
		output_file = args.outputpath+args.inputpath.split('/')[-1].split('.nc')[0]+'_'+str(int(val_depth))+'.nc'
		ncinstance = eNCw.NetCDF_Copy_Struct(savefile=output_file)
		ncinstance.file_create()
		ncinstance.sbeglobal_atts(raw_data_file=global_atts['DATA_CMNT'], Station_Name=global_atts['MOORING'], 
		                            Water_Depth=global_atts['WATER_DEPTH'], Inst_Type=global_atts['INST_TYPE'],
		                            Water_Mass=global_atts['WATER_MASS'], Experiment=['EXPERIMENT'])
		ncinstance.dimension_init(time_len=len(data['time']))
		ncinstance.variable_init(vars_dic)
		try:
			ncinstance.add_coord_data(depth=val_depth, latitude=data['lat'], longitude=data['lon'],
		                                 time1=data['time'], time2=data['time2'])
		except:
			ncinstance.add_coord_data(depth=val_depth, latitude=data['latitude'], longitude=data['longitude'],
		                                 time1=data['time'], time2=data['time2'])			
		ncinstance.add_data(data=data,depthindex=ind_depth)    
		ncinstance.add_history('Depths split from {file}'.format(file=args.inputpath.split('/')[-1]))
		ncinstance.close()

df.close()
