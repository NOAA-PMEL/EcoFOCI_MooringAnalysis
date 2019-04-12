#!/usr/bin/env python

"""
 Background:
 ========
 EPICCFgliderprofile2ERDDAP.py


 Purpose:
 ========
 Add a variable to a netcdf file

 History:
 ========

 2019-04-12: Modify for 2019 glider data (only use *.timeseries.nc files)
 2018-07-02: Fork and make so that glider with multiple time variables creates multiple id's

 2016-06-10: Update program so that it pulls possible new variables from epic.json file
 2016-08-10: transfer routine to EcoFOCI_MooringAnalysis package to simplify and unify

 Compatibility:
 ==============
 python >=3.6 ?
 python 2.7 

"""

#System Stack
import datetime
import argparse
import os, sys

#Science Stack
from netCDF4 import Dataset
from netCDF4 import stringtochar
import numpy as np

#User Defined Stack
from io_utils import ConfigParserLocal
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF


__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 1, 29)
__modified__ = datetime.datetime(2016, 8, 10)
__version__  = "0.2.0"
__status__   = "Development"
__keywords__ = 'netCDF','meta','header'



"""------------------------------- MAIN------------------------------------------------"""

parser = argparse.ArgumentParser(description='convert netcdf file to erddap formatted file')
parser.add_argument('sourcefile', metavar='sourcefile', type=str, help='path to .nc files')
parser.add_argument('add_dsg_idvar', metavar='add_dsg_idvar', type=str, help='name of dsg style id variable')

args = parser.parse_args()


"---"
df = EcoFOCI_netCDF(args.sourcefile)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
nchandle = df._getnchandle_()
data = df.ncreadfile_dic()

profileid = args.sourcefile.split('/')[-1].split('.nc')[0]
print profileid

try :
    nchandle.createDimension('id_strlen',8)
    nchandle.createVariable('profileid','S1',dimensions=('ctd_data_point','id_strlen'))
    nchandle.variables['profileid'].cf_role = args.add_dsg_idvar
    nchandle.variables['profileid'].long_name = 'profile_id'

except:
    print "{0} - not added".format(args.add_dsg_idvar)
    sys.exit()

#fill with default values
nchandle.variables['profileid'][:]=stringtochar(np.array(len(nchandle.dimensions['ctd_data_point']) * [profileid]))



"--- Cycle through list of instruments and add id for each , treat as 'other'--"

for instr in ['PAR','WetLABS','AandOxy']:
	if instr in ['PAR']:
		pro_id = 'profileid_par'
		dim_len = 'scicon_satpar_satPAR_data_point'
	elif instr in ['WetLABS']:
		pro_id = 'profileid_wetlabs'
		dim_len = 'wlbb2fl_data_point'
	elif instr in ['AandOxy']:
		pro_id = 'profileid_aand'
		dim_len = 'aa4330_data_point'

	try :
	    nchandle.createVariable(pro_id,'S1',dimensions=(dim_len,'id_strlen'))
	    nchandle.variables[pro_id].cf_role = args.add_dsg_idvar
	    nchandle.variables[pro_id].long_name = 'profile_id'

	except:
	    print "{0} - not added".format(args.add_dsg_idvar)
	    sys.exit()


	#nchandle.variables[pro_id][:]=stringtochar(np.array(len(nchandle.dimensions[dim_len]) * [profileid]))
	#if just using the timeseries file
	nchandle.variables[pro_id][:]=nchandle.variables['dive_number']

#add missing value attribute
for key,val in enumerate(vars_dic):
    nchandle.variables[val].fill_value = 1.0e35


df.close()
