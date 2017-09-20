#!/usr/bin/env python

"""
 Background:
 --------
 NetCDF_variable_add.py


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
parser.add_argument('sourcedir', metavar='sourcedir', type=str, help='path to .nc files')
parser.add_argument('--add_epic_var', type=str, help='name of new epic variable')

args = parser.parse_args()

# If these variables are not defined, no data will be archived into the nc file for that parameter.

###nc readin
df = EcoFOCI_netCDF(args.sourcedir)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
nchandle = df._getnchandle_()
data = df.ncreadfile_dic()

if args.add_epic_var:
    EPIC_VARS_dict = ConfigParserLocal.get_config('EcoFOCI_config/epickeys/epickey.json','json')
    try :
        epic_var_ind = (args.add_epic_var).split('_')[1]
        print "Adding {0} by searching for {1}".format(args.add_epic_var, epic_var_ind)
        try:
            newvar = nchandle.createVariable(EPIC_VARS_dict[epic_var_ind]['EPIC_KEY'],'f4',('time','depth','lat','lon'))
        except:
            newvar = nchandle.createVariable(EPIC_VARS_dict[epic_var_ind]['EPIC_KEY'],'f4',('time','dep','lat','lon'))
        newvar.setncattr('name',EPIC_VARS_dict[epic_var_ind]['NAME'])
        newvar.long_name = EPIC_VARS_dict[epic_var_ind]['LONGNAME']
        newvar.generic_name = EPIC_VARS_dict[epic_var_ind]['GENERIC_NAME']
        newvar.units = EPIC_VARS_dict[epic_var_ind]['UNITS']
        newvar.FORTRAN_format = EPIC_VARS_dict[epic_var_ind]['FORMAT']
        newvar.epic_code = int(epic_var_ind)

        print "adding history attribute"
        if not 'History' in global_atts.keys():
            histtime=datetime.datetime.utcnow()
            nchandle.setncattr('History','{histtime:%B %d, %Y %H:%M} UTC {variable} added'.format(histtime=histtime,variable=args.add_epic_var))
        else:
            histtime=datetime.datetime.utcnow()
            nchandle.setncattr('History', global_atts['History'] +'\n'+ '{histtime:%B %d, %Y %H:%M} UTC {variable} added'.format(histtime=histtime,variable=args.add_epic_var))

    except:
        print "{0} - not added".format(args.add_epic_var)

df.close()
