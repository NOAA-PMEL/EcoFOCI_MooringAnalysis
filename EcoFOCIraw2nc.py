#!/usr/bin/env python

"""
 Background:
 --------
 EcoFOCIraw2nc.py
 
 
 Purpose:
 --------
 Convert raw data to EPIC (or eventually COARDS/CF) standard netcdf files
 
 History:
 --------

  2017-02-08 : Correct Vector2Wind conversion to get met wind conventions from cartesion vectors
 2016-10-31 : Add RCM-SG
 2016-12-09 : Add ADCP Icetracking datastream
"""

#System Stack
import os
import sys
import datetime
import argparse

#Science Stack
import numpy as np

#User defined Stack
from io_utils.ConfigParserLocal import get_config
from io_utils.EcoFOCI_netCDF_write import NetCDF_Create_Timeseries
import io_utils.instr_data_ingest as instr_data_ingest
from calc.EPIC2Datetime import EPIC2Datetime, Datetime2EPIC
import calc.geomag.geomag.geomag as geomag

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2016, 8, 11)
__modified__ = datetime.datetime(2016, 8, 11)
__version__  = "0.1.0"
__status__   = "Development"
__keywords__ = 'Mooring', 'data','netcdf','epic'

"""--------------------------------helper Routines---------------------------------------"""
"""---------------------------convert input to boolean-----------------------------------"""

def to_bool(value):
    """
       Converts 'something' to boolean. Raises exception for invalid formats
           Possible True  values: 1, True, "1", "TRue", "yes", "y", "t"
           Possible False values: 0, False, None, [], {}, "", "0", "faLse", "no", "n", "f", 0.0, ...
    """
    if str(value).lower() in ("yes", "y", "true",  "t", "1"): return True
    if str(value).lower() in ("no",  "n", "false", "f", "0", "0.0", "", "none", "[]", "{}"): return False
    raise Exception('Invalid value for boolean conversion: ' + str(value))

    
"""------------------------------- rotate ----------------------------------------"""

def wind2vector(ws,wd):
    """ 
   
    """
    u_ind = (ws == 1e35)
    v_ind = (wd == 1e35)
    
    uu = -1. * ws * np.sin(wd * np.pi / 180.)
    vv = -1. * ws * np.cos(wd * np.pi / 180.)

    uu[u_ind] = 1e35
    vv[u_ind] = 1e35

    return (uu, vv)

def vector2wind(u,v,firstdefinition=False):
	""" 
	Update: 

	conversion available from:
	https://www.e-education.psu.edu/meteo300/node/719
	http://tornado.sfsu.edu/geosciences/classes/m430/Wind/WindDirection.html
	"""
	u_ind = (u == 1e35)
	v_ind = (v == 1e35)

	ws = np.sqrt(u*u + v*v)
	if firstdefinition:
		wd = 270. - np.rad2deg(np.arctan2(v,u))
		wd[np.where(wd<0)] = wd[np.where(wd<0)] + 360.
	else:
		wd = np.rad2deg(np.arctan2(u,v))+180

	ws[u_ind] = 1e35
	wd[u_ind] = 1e35
	ws[v_ind] = 1e35
	wd[v_ind] = 1e35


	return (ws, wd)


def rotate_coord(u,v, declination_corr=0):
    """ 
    Positive corr for east
    
    """
    u_ind = (u == 1e35)
    v_ind = (v == 1e35)
    mag = np.sqrt(u**2 + v**2)
    direc = np.arctan2(u,v)
    direc =  direc + np.deg2rad(declination_corr)
    uu = mag * np.sin(direc)
    vv = mag * np.cos(direc)
    
    uu[u_ind] = 1e35
    vv[v_ind] = 1e35
    return (uu, vv)

"""------------------------------- lat/lon ----------------------------------------"""

def latlon_dm2dd(Mooring_Lat, Mooring_Lon, pos_dir='W'):
    """
    Convert Postitive Latitude or Longitude from degrees and decimal minutes
      to decimal degrees
    """
    
    lat = float(Mooring_Lat[0]) + float(Mooring_Lat[1]) / 60.
        
    lon = float(Mooring_Lon[0]) + float(Mooring_Lon[1]) / 60.
    if pos_dir == 'E':
        lon = -1 * lon
        
    return (lat, lon)

"""--------------------------------main Routines---------------------------------------"""

parser = argparse.ArgumentParser(description='Convert raw data from variety of instruments to netcdf archive format')
parser.add_argument('DataFile', metavar='DataFile', type=str,
               help='full path to data file')
parser.add_argument('OutDataFile', metavar='OutDataFile', type=str, 
               help='full path to output data file')
parser.add_argument('InstType', metavar='InstType', type=str, 
               help='Instrument Type - run program with -ih flag to get list')
parser.add_argument('InstDepth', metavar='InstDepth', type=int, 
               help='Nominal Instrument Depth')
parser.add_argument('-ih','--InstTypeHelp', action="store_true",
               help='Instrument Type - run program with -ih flag to get list')
parser.add_argument('-dec','--declination', nargs=2, type=float,
               help='magnetic declination correction [lat.dd lon.dd] +N,+W')
parser.add_argument('-kw','--keywordargs', nargs='+', type=str,
               help='instrument dependent kword args - see readme for help')
parser.add_argument('-latlon','--latlon', nargs='+', type=str,
               help='add to output file variables [lat mm.mm lon mm.mm] +N,+W')
parser.add_argument('-add_meta','--add_meta', nargs=3, type=str,
               help='MooringID serial_no water_depth')
args = parser.parse_args()

### Extra help for available instruments to process and varias accepted names
if args.InstTypeHelp:
	print instr_data_ingest.available_data_sources().keys()
	sys.exit()

if args.InstType in ['MTR','mtr']:
	config_file = instr_data_ingest.data_source_instrumentconfig('yaml').get(args.InstType)
	Dataset = instr_data_ingest.get_inst_data(args.DataFile, 
										 source=args.InstType,
										 add_seconds=args.keywordargs[0],
										 mtr_coef=args.keywordargs[1:4],
										 tenmin_interp=to_bool(args.keywordargs[4]))


	EPIC_VARS_dict = get_config('EcoFOCI_config/instr_config/' + config_file, 'yaml')

	#cycle through and build data arrays
	#create a "data_dic" and associate the data with an epic key
	#this key needs to be defined in the EPIC_VARS dictionary in order to be in the nc file
	# if it is defined in the EPIC_VARS dic but not below, it will be filled with missing values
	# if it is below but not the epic dic, it will not make it to the nc file
	data_dic = {}
	try:
		data_dic['T_20'] = np.array(Dataset['temperature'].values(), dtype='f8')
		data_dic['T_20'][np.isnan(data_dic['T_20'])] = 1e35
	except:
		try:
			data_dic['T_20'] = np.array(Dataset['temperature'], dtype='f8')
		except:
			data_dic['T_20'] = np.ones_like(Dataset['time'].values())*1e35

	### Time should be consistent in all files as a datetime object
	time1, time2 = np.array(Datetime2EPIC(Dataset['time'].values()), dtype='f8')

	(lat,lon) = (-9999, -9999)

elif args.InstType in ['prawler','PRAWLER','Prawler']:
	config_file = instr_data_ingest.data_source_instrumentconfig('yaml').get(args.InstType)
	Dataset = instr_data_ingest.get_inst_data(args.DataFile, 
										 source=args.InstType,
										 prawler_interp_time=args.keywordargs[0],
										 prawler_grid_press=args.keywordargs[1])  

	EPIC_VARS_dict = get_config('EcoFOCI_config/instr_config/' + config_file, 'yaml')

	#cycle through and build data arrays
	#create a "data_dic" and associate the data with an epic key
	#this key needs to be defined in the EPIC_VARS dictionary in order to be in the nc file
	# if it is defined in the EPIC_VARS dic but not below, it will be filled with missing values
	# if it is below but not the epic dic, it will not make it to the nc file
	data_dic = {}
	try:
		temp = np.array(Dataset['temperature'].values(), dtype='f8')
		temp[np.isnan(temp)] = 1e35
		data_dic['T_20']= temp
	except KeyError:
		print "No temperature in this file"


	### Time should be consistent in all files as a datetime object
	time1, time2 = np.array(Datetime2EPIC(Dataset['time'].values()), dtype='f8')

	(lat,lon) = (-9999, -9999)

elif args.InstType in ['sbe56','sbe-56','SBE56','SBE-56','s56']:
	config_file = instr_data_ingest.data_source_instrumentconfig('yaml').get(args.InstType)
	Dataset = instr_data_ingest.get_inst_data(args.DataFile, 
										 source=args.InstType,
										 roundTime=to_bool(args.keywordargs[0]),
										 filetype=args.keywordargs[1])


	EPIC_VARS_dict = get_config('EcoFOCI_config/instr_config/' + config_file, 'yaml')


	#cycle through and build data arrays
	#create a "data_dic" and associate the data with an epic key
	#this key needs to be defined in the EPIC_VARS dictionary in order to be in the nc file
	# if it is defined in the EPIC_VARS dic but not below, it will be filled with missing values
	# if it is below but not the epic dic, it will not make it to the nc file
	data_dic = {}
	try:
		temp = np.array(Dataset['temperature'].values(), dtype='f8')
		temp[np.isnan(temp)] = 1e35
		data_dic['T_20']= temp
	except KeyError:
		print "No temperature in this file"

	### Time should be consistent in all files as a datetime object
	time1, time2 = np.array(Datetime2EPIC(Dataset['time'].values()), dtype='f8')

	(lat,lon) = (-9999, -9999)

elif args.InstType in ['sbe39','sbe-39','SBE39','SBE-39','s39']:
	config_file = instr_data_ingest.data_source_instrumentconfig('yaml').get(args.InstType)
	Dataset = instr_data_ingest.get_inst_data(args.DataFile, 
										 source=args.InstType,
										 truncate_seconds=to_bool(args.keywordargs[0]))


	EPIC_VARS_dict = get_config('EcoFOCI_config/instr_config/' + config_file, 'yaml')


	#cycle through and build data arrays
	#create a "data_dic" and associate the data with an epic key
	#this key needs to be defined in the EPIC_VARS dictionary in order to be in the nc file
	# if it is defined in the EPIC_VARS dic but not below, it will be filled with missing values
	# if it is below but not the epic dic, it will not make it to the nc file
	data_dic = {}
	try:
		data_dic['T_20'] = np.array(Dataset['Temperature'].values(), dtype='f8')
		data_dic['T_20'][np.isnan(data_dic['T_20'])] = 1e35
	except:
		data_dic['T_20'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['P_1'] = np.array(Dataset['Pressure'].values(), dtype='f8')
	except:
		data_dic['P_1'] = np.ones_like(Dataset['time'].values())*1e35

	### Time should be consistent in all files as a datetime object
	time1, time2 = np.array(Datetime2EPIC(Dataset['time'].values()), dtype='f8')

	(lat,lon) = (-9999, -9999)

elif args.InstType in ['microcat','sbe37','sbe-37','SBE37','SBE-37','s37']:
	config_file = instr_data_ingest.data_source_instrumentconfig('yaml').get(args.InstType)
	Dataset = instr_data_ingest.get_inst_data(args.DataFile, 
										 source=args.InstType,
										 truncate_seconds=to_bool(args.keywordargs[0]))


	EPIC_VARS_dict = get_config('EcoFOCI_config/instr_config/' + config_file, 'yaml')


	#cycle through and build data arrays
	#create a "data_dic" and associate the data with an epic key
	#this key needs to be defined in the EPIC_VARS dictionary in order to be in the nc file
	# if it is defined in the EPIC_VARS dic but not below, it will be filled with missing values
	# if it is below but not the epic dic, it will not make it to the nc file
	data_dic = {}
	try:
		data_dic['T_20'] = np.array(Dataset['Temperature'].values(), dtype='f8')
		data_dic['T_20'][np.isnan(data_dic['T_20'])] = 1e35
	except:
		data_dic['T_20'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['P_1'] = np.array(Dataset['Pressure'].values(), dtype='f8')
	except:
		data_dic['P_1'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['C_50'] = np.array(Dataset['Conductivity'].values(), dtype='f8')
	except:
		data_dic['C_50'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['S_41'] = np.array(Dataset['Salinity'].values(), dtype='f8')
	except:
		data_dic['S_41'] = np.ones_like(Dataset['time'].values())*1e35

	### Time should be consistent in all files as a datetime object
	time1, time2 = np.array(Datetime2EPIC(Dataset['time'].values()), dtype='f8')

	(lat,lon) = (-9999, -9999)

elif args.InstType in ['seacat','sbe16','sbe-16','SBE16','SBE-16','sc']:
	config_file = instr_data_ingest.data_source_instrumentconfig('yaml').get(args.InstType)
	Dataset = instr_data_ingest.get_inst_data(args.DataFile, 
										 source=args.InstType,
										 add_seconds=args.keywordargs[0],
									 	 time_stamp=args.keywordargs[1],
										 hourly_interp=to_bool(args.keywordargs[2]))


	EPIC_VARS_dict = get_config('EcoFOCI_config/instr_config/' + config_file, 'yaml')


	#cycle through and build data arrays
	#create a "data_dic" and associate the data with an epic key
	#this key needs to be defined in the EPIC_VARS dictionary in order to be in the nc file
	# if it is defined in the EPIC_VARS dic but not below, it will be filled with missing values
	# if it is below but not the epic dic, it will not make it to the nc file
	data_dic = {}
	try:
		data_dic['T_20'] = np.array(Dataset['Temperature'], dtype='f8')
		data_dic['T_20'][np.isnan(data_dic['T_20'])] = 1e35
	except:
		data_dic['T_20'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['P_1'] = np.array(Dataset['Pressure'], dtype='f8')
		if (len(data_dic['P_1']) == 0):
			data_dic['P_1'] = np.ones_like(Dataset['time'].values())*1e35
	except:
		data_dic['P_1'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['C_50'] = np.array(Dataset['Conductivity'], dtype='f8')
	except:
		data_dic['C_50'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['S_41'] = np.array(Dataset['Salinity'], dtype='f8')
	except:
		data_dic['S_41'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['Fch_906'] = np.array(Dataset['Chlor_a'], dtype='f8')
		if (len(data_dic['Fch_906']) == 0):
			data_dic['Fch_906'] = np.ones_like(Dataset['time'].values())*1e35
	except:
		data_dic['Fch_906'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['PAR_908'] = np.array(Dataset['PAR'], dtype='f8')
		if (len(data_dic['PAR_908']) == 0):
			data_dic['PAR_908'] = np.ones_like(Dataset['time'].values())*1e35
	except:
		data_dic['PAR_908'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['V0_3333'] = np.array(Dataset['V0'], dtype='f8')
		if (len(data_dic['V0_3333']) == 0):
			data_dic['V0_3333'] = np.ones_like(Dataset['time'].values())*1e35
	except:
		data_dic['V0_3333'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['OST_62'] = np.array(Dataset['AAN_OXY'], dtype='f8')
		if (len(data_dic['OST_62']) == 0):
			data_dic['OST_62'] = np.ones_like(Dataset['time'].values())*1e35
	except:
		data_dic['OST_62'] = np.ones_like(Dataset['time'].values())*1e35

	### Time should be consistent in all files as a datetime object
	time1, time2 = np.array(Datetime2EPIC(Dataset['time'].values()), dtype='f8')

	(lat,lon) = (-9999, -9999)

elif args.InstType in ['sg','rcm_sg','rcmsg','rcm-sg']:
	config_file = instr_data_ingest.data_source_instrumentconfig('yaml').get(args.InstType)
	Dataset = instr_data_ingest.get_inst_data(args.DataFile, 
										 source=args.InstType,
										 turbidity=to_bool(args.keywordargs[0]),
										 pressure=to_bool(args.keywordargs[1]))


	EPIC_VARS_dict = get_config('EcoFOCI_config/instr_config/' + config_file, 'yaml')


	#cycle through and build data arrays
	#create a "data_dic" and associate the data with an epic key
	#this key needs to be defined in the EPIC_VARS dictionary in order to be in the nc file
	# if it is defined in the EPIC_VARS dic but not below, it will be filled with missing values
	# if it is below but not the epic dic, it will not make it to the nc file
	data_dic = {}
	try:
		data_dic['T_20'] = np.array(Dataset['Temperature'].values(), dtype='f8')
	except:
		data_dic['T_20'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['P_1'] = np.array(Dataset['Pressure'].values(), dtype='f8')
		### pressure is in kPa (or MPa) and needs to be converted to dbar
		### also needs to have the atm pressure removed
		### TODO: build a constants file --> constants.standard_atm_pres = 1013.25 mbar

		atm_sealevel=1013.25 #mbar
		data_dic['P_1'] = (data_dic['P_1']- (atm_sealevel/10.)) /10.	
	except:
		data_dic['P_1'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['U_320'] = np.array(Dataset['North'].values(), dtype='f8')
	except:
		data_dic['U_320'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['V_321'] = np.array(Dataset['East'].values(), dtype='f8')
	except:
		data_dic['V_321'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['O_65'] = np.array(Dataset['O2Concentration'].values(), dtype='f8')
	except:
		data_dic['O_65'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['OST_62'] = np.array(Dataset['AirSaturation'].values(), dtype='f8')
	except:
		data_dic['OST_62'] = np.ones_like(Dataset['time'].values())*1e35

	### currently - calculated by seaguard but does not have mag declination correction
	# calculate the current speed and dir seperately with corrected components
	data_dic['CS_300'] = np.ones_like(Dataset['time'].values())*1e35
	data_dic['CD_310'] = np.ones_like(Dataset['time'].values())*1e35

	### Time should be consistent in all files as a datetime object
	time1, time2 = np.array(Datetime2EPIC(Dataset['time'].values()), dtype='f8')


	#magnetic declination correction
	if args.declination:
		(lat,lon) = (args.declination[0], args.declination[1])
		t = geomag.GeoMag()
		dec = t.GeoMag(lat,-1 * lon,time=Dataset['time'].values()[0].date()).dec

		# apply magnetic declination correction
		vel1,vel2 = rotate_coord(data_dic['U_320'],data_dic['V_321'],dec)
		data_dic['U_320'] = vel1
		data_dic['V_321'] = vel2
		data_dic['CS_300'] = np.sqrt(vel1**2 + vel2**2)
		data_dic['CD_310'] = 180+np.rad2deg(np.arctan2(-1*vel1,-1*vel2))

		new_history = True
		history_string = 'Magnetic Declination Correction {dec} applied (+E)'.format(dec=dec)
	else:
		(lat,lon) = (-9999, -9999)

elif args.InstType in ['eco','ecf','fluor','ecofluor','fluor','ecoflntu']:
	config_file = instr_data_ingest.data_source_instrumentconfig('yaml').get(args.InstType)
	Dataset = instr_data_ingest.get_inst_data(args.DataFile, 
										 source=args.InstType,
										 add_seconds=args.keywordargs[0],
										 ave_scheme=args.keywordargs[1],
										 scale_factor=float(args.keywordargs[2]),
										 dark_count=float(args.keywordargs[3]),
										 hourly_interp=to_bool(args.keywordargs[4]),
										 verbose=True)


	EPIC_VARS_dict = get_config('EcoFOCI_config/instr_config/' + config_file, 'yaml')


	#cycle through and build data arrays
	#create a "data_dic" and associate the data with an epic key
	#this key needs to be defined in the EPIC_VARS dictionary in order to be in the nc file
	# if it is defined in the EPIC_VARS dic but not below, it will be filled with missing values
	# if it is below but not the epic dic, it will not make it to the nc file
	data_dic = {}
	try:
		data_dic['fluor_3031'] = np.array(Dataset['counts'], dtype='f8')
	except:
		data_dic['fluor_3031'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['fluorstd_2031'] = np.array(Dataset['counts_std'], dtype='f8')
	except:
		data_dic['fluorstd_2031'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['Fch_906'] = np.array(Dataset['chlor'], dtype='f8')
	except:
		data_dic['Fch_906'] = np.ones_like(data_dic['fluor_3031'])*1e35

	### Time should be consistent in all files as a datetime object
	time1, time2 = np.array(Datetime2EPIC(Dataset['time'].values()), dtype='f8')

	(lat,lon) = (-9999, -9999)

elif args.InstType in ['wpak','met']:
	config_file = instr_data_ingest.data_source_instrumentconfig('yaml').get(args.InstType)
	Dataset = instr_data_ingest.get_inst_data(args.DataFile, 
										 source=args.InstType,
										 argos_file=to_bool(args.keywordargs[0]))

	EPIC_VARS_dict = get_config('EcoFOCI_config/instr_config/' + config_file, 'yaml')

	#cycle through and build data arrays
	#create a "data_dic" and associate the data with an epic key
	#this key needs to be defined in the EPIC_VARS dictionary in order to be in the nc file
	# if it is defined in the EPIC_VARS dic but not below, it will be filled with missing values
	# if it is below but not the epic dic, it will not make it to the nc file
	data_dic = {}
	data_dic['BP_915'] = np.array(Dataset['BP'].values(), dtype='f8')
	data_dic['AT_21'] = np.array(Dataset['TA'].values(), dtype='f8')
	data_dic['BAT_106'] = np.array(Dataset['BT'].values(), dtype='f8')
	data_dic['Teq_1800'] = np.array(Dataset['TI'].values(), dtype='f8')
	data_dic['RH_910'] = np.array(Dataset['RH'].values(), dtype='f8')
	data_dic['WS_401'] = np.array(Dataset['WS'].values(), dtype='f8')
	data_dic['WD_410'] = np.array(Dataset['WD'].values(), dtype='f8')
	data_dic['Qs_133'] = np.array(Dataset['SR'].values(), dtype='f8')
	data_dic['comp_1404'] = np.array(Dataset['AZ'].values(), dtype='f8')

	### Time should be consistent in all files as a datetime object
	time1, time2 = np.array(Datetime2EPIC(Dataset['time'].values()), dtype='f8')

	#magnetic declination correction for winds
	if args.declination:
		(lat,lon) = (args.declination[0], args.declination[1])
		t = geomag.GeoMag()
		dec = t.GeoMag(lat,-1 * lon,time=Dataset['time'].values()[0].date()).dec

		wu,wv=wind2vector(data_dic['WS_401'],data_dic['WD_410'])
		data_dic['WU_422'],data_dic['WV_423']=rotate_coord(wu,wv, declination_corr=dec)
		data_dic['WS_401'],data_dic['WD_410']=vector2wind(data_dic['WU_422'],data_dic['WV_423'])

		new_history = True
		history_string = 'Magnetic Declination Correction {dec} applied (+E)'.format(dec=dec)
	else:
		(lat,lon) = (-9999, -9999)

elif args.InstType in ['adcp_ice']:
	config_file = instr_data_ingest.data_source_instrumentconfig('yaml').get(args.InstType)
	Dataset = instr_data_ingest.get_inst_data(args.DataFile, 
										 source=args.InstType,
										 roundTime=to_bool(args.keywordargs[0]))


	EPIC_VARS_dict = get_config('EcoFOCI_config/instr_config/' + config_file, 'yaml')


	#cycle through and build data arrays
	#create a "data_dic" and associate the data with an epic key
	#this key needs to be defined in the EPIC_VARS dictionary in order to be in the nc file
	# if it is defined in the EPIC_VARS dic but not below, it will be filled with missing values
	# if it is below but not the epic dic, it will not make it to the nc file
	data_dic = {}
	try:
		data_dic['u_1205'] = np.array(Dataset['U'].values(), dtype='f8')
	except:
		data_dic['u_1205'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['v_1206'] = np.array(Dataset['V'].values(), dtype='f8')
	except:
		data_dic['v_1206'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['w_1204'] = np.array(Dataset['W'].values(), dtype='f8')
	except:
		data_dic['w_1204'] = np.ones_like(Dataset['time'].values())*1e35
	try:
		data_dic['Werr_1201'] = np.array(Dataset['Werr'].values(), dtype='f8')
	except:
		data_dic['Werr_1201'] = np.ones_like(Dataset['time'].values())*1e35

	### currently - calculated by adcp but does not have mag declination correction
	# calculate the current speed and dir seperately with corrected components
	data_dic['CS_300'] = np.ones_like(Dataset['time'].values())*1e35
	data_dic['CD_310'] = np.ones_like(Dataset['time'].values())*1e35

	### Time should be consistent in all files as a datetime object
	time1, time2 = np.array(Datetime2EPIC(Dataset['time'].values()), dtype='f8')


	#magnetic declination correction
	if args.declination:
		(lat,lon) = (args.declination[0], args.declination[1])
		t = geomag.GeoMag()
		dec = t.GeoMag(lat,-1 * lon,time=Dataset['time'].values()[0].date()).dec

		# apply magnetic declination correction
		vel1,vel2 = rotate_coord(data_dic['u_1205'],data_dic['v_1206'],dec)
		data_dic['u_1205'] = vel1
		data_dic['v_1206'] = vel2
		data_dic['CS_300'] = np.sqrt(vel1**2 + vel2**2)
		data_dic['CD_310'] = 180+np.rad2deg(np.arctan2(-1*vel1,-1*vel2))

		new_history = True
		history_string = 'Magnetic Declination Correction {dec} applied (+E)'.format(dec=dec)
	else:
		(lat,lon) = (-9999, -9999)
else:
	print "No valid instrument provided"
	sys.exit()

# dont update lat/lon if declination correction is requested
if args.latlon and not args.declination:
	(lat,lon) = latlon_dm2dd(args.latlon[0:2],args.latlon[3:5])

### Add some cmd line meta information
if args.add_meta:
	(MooringID, serial_no, water_depth) = args.add_meta
else:
	(serial_no, water_depth) = ['',9999]
		
"-----------------------------------------------"
" write value to file after readin is successful"

ncinstance = NetCDF_Create_Timeseries(savefile=args.OutDataFile)
ncinstance.file_create()
ncinstance.sbeglobal_atts(raw_data_file=args.DataFile.split('/')[-1],
						  Water_Depth=water_depth,
						  Station_Name=MooringID,
						  Instrument_Type=args.InstType,
						  SerialNumber=serial_no)
ncinstance.dimension_init(time_len=len(time1))
ncinstance.variable_init(EPIC_VARS_dict)
ncinstance.add_coord_data(depth=args.InstDepth, 
						  latitude=lat, 
						  longitude=lon, 
						  time1=time1, 
						  time2=time2)
ncinstance.add_data(EPIC_VARS_dict,data_dic=data_dic)
try:
	ncinstance.add_history(new_history=history_string)
except NameError:
	pass
ncinstance.close()
