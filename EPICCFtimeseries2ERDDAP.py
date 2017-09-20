#!/usr/bin/env python

"""
 Background:
 --------
 EPICCFtimeseries2ERDDAP.py


 Purpose:
 --------
 Add a variable to a netcdf file

 History:
 --------

 2016-06-10: Update program so that it pulls possible new variables from epic.json file
 2016-08-10: transfer routine to EcoFOCI_MooringAnalysis package to simplify and unify

"""

#System Stack
import datetime
import argparse
import os

#Science Stack
from netCDF4 import Dataset
import numpy as np

#User Defined Stack
from io_utils import ConfigParserLocal
from io_utils.EcoFOCI_to_ERDDAP_nc import timeseries_to_ERDDAP_nc
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF


__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 01, 29)
__modified__ = datetime.datetime(2016, 8, 10)
__version__  = "0.2.0"
__status__   = "Development"
__keywords__ = 'netCDF','meta','header'



"""------------------------------- MAIN------------------------------------------------"""

parser = argparse.ArgumentParser(description='add a variable to a .nc file')
parser.add_argument('sourcefile', metavar='sourcefile', type=str, help='path to .nc files')
parser.add_argument('--add_dsg_idvar', type=str, help='name of dsg style id variable')
parser.add_argument('--fill_value', type=str, help='station_name prefill value')

args = parser.parse_args()

# If these variables are not defined, no data will be archived into the nc file for that parameter.

###nc readin
df = EcoFOCI_netCDF(args.sourcefile)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
nchandle = df._getnchandle_()
data = df.ncreadfile_dic()

ncinstance = timeseries_to_ERDDAP_nc(savefile=args.sourcefile.split('.cf.nc')[0] + '.cf1d.nc')
ncinstance.file_create()
ncinstance.sbeglobal_atts(raw_data_file=global_atts['DATA_CMNT'], Station_Name=global_atts['MOORING'], 
                                Water_Depth=global_atts['WATER_DEPTH'], Inst_Type=global_atts['INST_TYPE'],
                                Water_Mass=global_atts['WATER_MASS'], Experiment=global_atts['EXPERIMENT'], Project=global_atts['PROJECT'], 
                                History=global_atts['History'],featureType=global_atts['featureType'])
ncinstance.dimension_init(recnum_len=len(data['time']),str_len=len(args.fill_value))
ncinstance.variable_init(nchandle)

ncinstance.add_data(data)
ncinstance.add_history('nc file converted to one dim')
ncinstance.close()
df.close()

"---"
df = EcoFOCI_netCDF(args.sourcefile.replace('.cf.nc','.cf1d.nc'))
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
nchandle = df._getnchandle_()
data = df.ncreadfile_dic()

if args.add_dsg_idvar:
    try :
        print "Adding {0}".format(args.add_dsg_idvar)
        try:
            newvar = nchandle.createVariable( args.add_dsg_idvar,'S1',('id_strlen'))
        except:
            newvar = nchandle.createVariable( args.add_dsg_idvar,'S1',('id_strlen'))
        newvar.long_name = 'station name'
        newvar.cf_role = 'timeseries_id'

        print "adding history attribute"
        if not 'History' in global_atts.keys():
            histtime=datetime.datetime.utcnow()
            nchandle.setncattr('History','{histtime:%B %d, %Y %H:%M} UTC {variable} added'.format(histtime=histtime,variable=args.add_dsg_idvar))
        else:
            histtime=datetime.datetime.utcnow()
            nchandle.setncattr('History', global_atts['History'] +'\n'+ '{histtime:%B %d, %Y %H:%M} UTC {variable} added'.format(histtime=histtime,variable=args.add_dsg_idvar))

    except:
        print "{0} - not added".format(args.add_dsg_idvar)

if args.fill_value:
    #fill with default values
    nchandle.variables[args.add_dsg_idvar][:,0,0,0] = len(nchandle.variables[args.add_dsg_idvar][:,0,0,0] ) * args.fill_value

    print "{0} prefilled with {1}".format(args.add_dsg_idvar,args.fill_value)

df.close()
