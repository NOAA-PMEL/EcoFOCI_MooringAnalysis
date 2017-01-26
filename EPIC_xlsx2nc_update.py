#!/usr/bin/env python

"""
 Background:
 --------
 EPIC_xlsx2nc_update.py
 
 
 Purpose:
 --------
 Update a netcdf file from an edited xlsx file.  

 Requirements:
 -------------
 Record length of the excel file must be the same as the netcdf file
 Only the chosen variable will be updated.

 WorkFlow -- {file}.nc ->  {file}.csv -> {file}.xlsx --> update {file}.nc

 History:
 --------
 2016-10-05: Update so missing values (NaN) are replaced by 1e35

"""

#System Stack
import os
import sys
import datetime
import argparse

#Science Stack
import numpy as np
import pandas as pd
from netCDF4 import Dataset, date2num

#User defined Stack
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF
from calc.EPIC2Datetime import EPIC2Datetime, Datetime2EPIC

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2016, 9, 30)
__modified__ = datetime.datetime(2016, 9, 30)
__version__  = "0.1.0"
__status__   = "Development"
__keywords__ = 'Mooring', 'data','netcdf','epic','excel','xlsx','update'

    
"""--------------------------------main Routines---------------------------------------"""

parser = argparse.ArgumentParser(description='Update epic flavored netcdf files fro xlsx file')
parser.add_argument('ExcelDataPath', metavar='ExcelDataPath', type=str, 
               help='full path to excel (.xlsx) data file')
parser.add_argument('ExcelSheet', metavar='ExcelSheet', type=int, 
			   help='Relevant Sheet number in workbook')
parser.add_argument('NCDataPath', metavar='NCDataPath', type=str, 
               help='full path to netcdf (.nc) file')
parser.add_argument('-ek','--EPIC_KEY', nargs='+', type=str, 
			   help='list of EPIC Keys to transfer (must be header labels in workbook)')


args = parser.parse_args()

wb = pd.read_excel(args.ExcelDataPath,sheetname=args.ExcelSheet)
wb.fillna(1e35,inplace=True)



#cycle through and build data arrays
#create a "data_dic" and associate the data with an epic key based on the header line

data_dic = {}
for column in wb.keys():
	print "{column} in file".format(column=column.strip())
	data_dic[column.strip()] = wb[column].to_dict().values()

###nc readin/out
df = EcoFOCI_netCDF(args.NCDataPath)
nchandle = df._getnchandle_()
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
data = df.ncreadfile_dic()

###replace chosen variables
if args.EPIC_KEY:
	for var_name in args.EPIC_KEY:
		try:
			nchandle.variables[var_name][:,0,0,0] = np.array(data_dic[var_name])
			print "SUCCESS: {variable} updated".format(variable=var_name)
		except:
			print "FAIL: {variable} not updated".format(variable=var_name)
else:
	print "Rerun program with an EPIC_KEY chosen from the above available keys"

df.close()
