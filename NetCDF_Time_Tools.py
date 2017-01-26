#!/usr/bin/env python

"""
 Background:
 --------
 NetCDF_Time_Tools.py
 
 
 Purpose:
 --------
 Collection of various time tools

 Convert EPIC file to CF file (in time)
 Round to nearest Hour
 Interpolate to nearest Hour (modifies data too)

 Usage:
 ------
 nc_epic2udunits_time.py {source_file} 'time since string'
 nc_epic2udunits_time.py {source_file} 'hours since 1800-01-01'
 nc_epic2udunits_time.py {source_file} 'days since 1800-01-01'


 History:
 --------
 2016-07-25: update EPIC to CF time routines to be in EPIC2Datetime.py and removed time calls
	in this routine.
 2016-08-09: change routine references and add toe EcoFOCI_MooringAnalysis package
 2016-12-16: combine all tools for time edits together
"""

#System Stack
import datetime
import argparse

#Science Stack
from netCDF4 import Dataset
import numpy as np
import pandas as pd

#User Stack
from calc.EPIC2Datetime import EPIC2Datetime, get_UDUNITS, Datetime2EPIC
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF
from io_utils.EcoFOCI_netCDF_write import CF_NC_2D, CF_NC, NetCDF_Copy_Struct
from io_utils.time_helper import roundTime, interp2hour

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 01, 29)
__modified__ = datetime.datetime(2016, 8, 9)
__version__  = "0.3.2"
__status__   = "Development"
__keywords__ = 'netCDF','meta','header', 'QC'


"""------------------------------- MAIN--------------------------------------------"""

parser = argparse.ArgumentParser(description='Tools to manipulate Time in files')
parser.add_argument('sourcefile', metavar='sourcefile', type=str,
			   help='complete path to epic file')
parser.add_argument('operation', metavar='operation', type=str,
			   help='CF_Convert, RoundTime to nearest hour, Interpolate to nearest hour')
parser.add_argument('--time_since_str', nargs='+', type=str, help='cf compliant time since str (eg. "days since 1800-01-01"')
parser.add_argument('-is2D','--is2D', action="store_true",
			   help='convert files like ADCP that have two varying dimensions')
args = parser.parse_args()


if args.operation in ['CF','CF Convert','CF_Convert']:
	#generates near file
	if args.is2D:

		df = EcoFOCI_netCDF( args.sourcefile )
		global_atts = df.get_global_atts()
		vars_dic = df.get_vars()
		ncdata = df.ncreadfile_dic()

		#Convert two word EPIC time to python datetime.datetime representation and then format for CF standards
		dt_from_epic =  EPIC2Datetime(ncdata['time'], ncdata['time2'])
		if args.time_since_str:
			time_since_str = " ".join(args.time_since_str)
			CF_time = get_UDUNITS(dt_from_epic,time_since_str)
		else:
			time_since_str = 'days since 1900-01-01'
			CF_time = get_UDUNITS(dt_from_epic,time_since_str)

		try:
			History=global_atts['History']
		except:
			History=''
		
		###build/copy attributes and fill if empty
		try:
			data_cmnt = global_atts['DATA_CMNT']
		except:
			data_cmnt = ''

		ncinstance = CF_NC_2D(savefile=args.sourcefile.split('.nc')[0] + '.cf.nc')
		ncinstance.file_create()
		ncinstance.sbeglobal_atts(raw_data_file=data_cmnt, Station_Name=global_atts['MOORING'], 
										Water_Depth=global_atts['WATER_DEPTH'], Inst_Type=global_atts['INST_TYPE'],
										Water_Mass=global_atts['WATER_MASS'], Experiment=global_atts['EXPERIMENT'], Project=global_atts['PROJECT'], 
										History=History)
		ncinstance.dimension_init(time_len=len(CF_time),depth_len=len(ncdata['depth']))
		ncinstance.variable_init(df,time_since_str)
		try:
			ncinstance.add_coord_data(depth=ncdata['depth'], latitude=ncdata['lat'], longitude=ncdata['lon'],
											 time=CF_time)
		except KeyError:
			ncinstance.add_coord_data(depth=ncdata['depth'], latitude=ncdata['latitude'], longitude=ncdata['longitude'],
											 time=CF_time)

		ncinstance.add_data(ncdata)
		ncinstance.add_history('EPIC two time-word key converted to udunits')
		ncinstance.close()
		df.close()

	else:

		#read in 1d data file
		df = EcoFOCI_netCDF( args.sourcefile )
		global_atts = df.get_global_atts()
		vars_dic = df.get_vars()
		ncdata = df.ncreadfile_dic()


		#Convert two word EPIC time to python datetime.datetime representation and then format for CF standards
		dt_from_epic =  EPIC2Datetime(ncdata['time'], ncdata['time2'])
		if args.time_since_str:
			time_since_str = " ".join(args.time_since_str)
			CF_time = get_UDUNITS(dt_from_epic,time_since_str)
		else:
			time_since_str = 'days since 1900-01-01'
			CF_time = get_UDUNITS(dt_from_epic,time_since_str)

		try:
			History=global_atts['History']
		except:
			History=''

		###build/copy attributes and fill if empty
		try:
			data_cmnt = global_atts['DATA_CMNT']
		except:
			data_cmnt = ''
			
		ncinstance = CF_NC(savefile=args.sourcefile.split('.nc')[0] + '.cf.nc')
		ncinstance.file_create()
		ncinstance.sbeglobal_atts(raw_data_file=data_cmnt, Station_Name=global_atts['MOORING'], 
										Water_Depth=global_atts['WATER_DEPTH'], Inst_Type=global_atts['INST_TYPE'],
										Water_Mass=global_atts['WATER_MASS'], Experiment=global_atts['EXPERIMENT'], Project=global_atts['PROJECT'], 
										History=History)
		ncinstance.dimension_init(time_len=len(CF_time))
		ncinstance.variable_init(df,time_since_str)
		try:
			ncinstance.add_coord_data(depth=ncdata['depth'], latitude=ncdata['lat'], longitude=ncdata['lon'],
											 time=CF_time)
		except KeyError:
			ncinstance.add_coord_data(depth=ncdata['depth'], latitude=ncdata['latitude'], longitude=ncdata['longitude'],
											 time=CF_time)

		ncinstance.add_data(ncdata)
		ncinstance.add_history('EPIC two time-word key converted to udunits')
		ncinstance.close()
		df.close()    

elif args.operation in ['RoundTime','roundtime','round_time']:
	#Modifies original file
	#read in 1d data file

	df = EcoFOCI_netCDF( args.sourcefile )
	global_atts = df.get_global_atts()
	vars_dic = df.get_vars()
	ncdata = df.ncreadfile_dic()

	#Convert two word EPIC time to python datetime.datetime representation and then format for CF standards
	dt_from_epic =  EPIC2Datetime(ncdata['time'], ncdata['time2'])
	dt_updated = [roundTime(x,3600) for x in dt_from_epic]
	(etime1,etime2) = Datetime2EPIC(dt_updated)
	df.update_epic_time(time=etime1,time2=etime2)
	try:
		df.add_history(global_atts['History'], 'Time Round to Nearest Hour')
	except:
		print "History attribute does not exist to edit"
	df.close()

elif args.operation in ['Interpolate','interpolate']:
	#creates new file
	if args.is2D:

		#read in 2d data file
		df = EcoFOCI_netCDF( args.sourcefile )
		global_atts = df.get_global_atts()
		vars_dic = df.get_vars()
		ncdata = df.ncreadfile_dic()

		#Convert two word EPIC time to python datetime.datetime representation and then format for CF standards
		dt_from_epic =  EPIC2Datetime(ncdata['time'], ncdata['time2'])

		#interp each non-dimension variable to new time
		#put data on hourly grid
		ncdata_new = {}
		min_t = min(dt_from_epic)
		basedate = datetime.datetime( min_t.year , min_t.month , 
									  min_t.day, min_t.hour)
		rng = pd.date_range(basedate, max(dt_from_epic), freq='1H').to_pydatetime()
		trng = {k:v for k,v in enumerate(rng)}

		for key in ncdata.keys():
			if not key in ['lat','lon','depth','time','time2','dep','latitude','longitude']:
				for ii,val in enumerate(ncdata['depth']):
					temporary = interp2hour(rng, dt_from_epic, {key:ncdata[key][:,ii,0,0]},variable_name=key)
					if ii == 0: 
						ncdata_new[key] = np.ones([len(temporary[key]),len(ncdata['depth']),1,1]) * np.nan
					ncdata_new[key][:,ii,0,0] = temporary[key]

		(etime,etime2) = Datetime2EPIC(trng.values())

		try:
			History=global_atts['History']
		except:
			History=''

		###build/copy attributes and fill if empty
		try:
			data_cmnt = global_atts['DATA_CMNT']
		except:
			data_cmnt = ''
			
		ncinstance = NetCDF_Copy_Struct(savefile=args.sourcefile.split('.nc')[0] + '.interp.nc')
		ncinstance.file_create()
		ncinstance.sbeglobal_atts(raw_data_file=global_atts['DATA_CMNT'], Station_Name=global_atts['MOORING'], 
		                            Water_Depth=global_atts['WATER_DEPTH'], Inst_Type=global_atts['INST_TYPE'],
		                            Water_Mass=global_atts['WATER_MASS'], Experiment=['EXPERIMENT'],
		                            Project=global_atts['PROJECT'], History=History)
		ncinstance.dimension_init(time_len=len(etime),depth_len=len(ncdata['depth']))
		ncinstance.variable_init(vars_dic)
		try:
			ncinstance.add_coord_data(depth=ncdata['depth'], latitude=ncdata['lat'], longitude=ncdata['lon'],
		                                 time1=etime, time2=etime2)
		except:
			ncinstance.add_coord_data(depth=ncdata['depth'], latitude=ncdata['latitude'], longitude=ncdata['longitude'],
		                                 time1=etime, time2=etime2)			
		ncinstance.add_data(data=ncdata_new, is2D=True)    
		ncinstance.add_history('Data Interpolated Linearly to be on the hour')
		ncinstance.close()
		df.close()  

	else:

		#read in 1d data file
		df = EcoFOCI_netCDF( args.sourcefile )
		global_atts = df.get_global_atts()
		vars_dic = df.get_vars()
		ncdata = df.ncreadfile_dic()

		#Convert two word EPIC time to python datetime.datetime representation and then format for CF standards
		dt_from_epic =  EPIC2Datetime(ncdata['time'], ncdata['time2'])

		#interp each non-dimension variable to new time
		#put data on hourly 
		ncdata_new = {}
		min_t = min(dt_from_epic)
		basedate = datetime.datetime( min_t.year , min_t.month , 
									  min_t.day, min_t.hour)
		rng = pd.date_range(basedate, max(dt_from_epic), freq='1H').to_pydatetime()
		trng = {k:v for k,v in enumerate(rng)}
		for key in ncdata.keys():
			if not key in ['lat','lon','depth','time','time2','dep','latitude','longitude']:
				temporary = interp2hour(rng, dt_from_epic, {key:ncdata[key][:,0,0,0]},variable_name=key)
				ncdata_new[key] = np.ones([len(temporary[key]),1,1,1]) * np.nan
				ncdata_new[key][:,0,0,0] = temporary[key]

		(etime,etime2) = Datetime2EPIC(trng.values())

		try:
			History=global_atts['History']
		except:
			History=''

		###build/copy attributes and fill if empty
		try:
			data_cmnt = global_atts['DATA_CMNT']
		except:
			data_cmnt = ''
			
		ncinstance = NetCDF_Copy_Struct(savefile=args.sourcefile.split('.nc')[0] + '.interp.nc')
		ncinstance.file_create()
		ncinstance.sbeglobal_atts(raw_data_file=global_atts['DATA_CMNT'], Station_Name=global_atts['MOORING'], 
		                            Water_Depth=global_atts['WATER_DEPTH'], Inst_Type=global_atts['INST_TYPE'],
		                            Water_Mass=global_atts['WATER_MASS'], Experiment=['EXPERIMENT'],
		                            Project=global_atts['PROJECT'], History=History)
		ncinstance.dimension_init(time_len=len(etime))
		ncinstance.variable_init(vars_dic)
		try:
			ncinstance.add_coord_data(depth=ncdata['depth'], latitude=ncdata['lat'], longitude=ncdata['lon'],
		                                 time1=etime, time2=etime2)
		except:
			ncinstance.add_coord_data(depth=ncdata['depth'], latitude=ncdata['latitude'], longitude=ncdata['longitude'],
		                                 time1=etime, time2=etime2)			
		ncinstance.add_data(data=ncdata_new, is2D=False)    
		ncinstance.add_history('Data Interpolated Linearly to be on the hour')
		ncinstance.close()
		df.close()    

else:
	print "Invalid Option Selected"
