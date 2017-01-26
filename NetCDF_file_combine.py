#!/usr/bin/env python

"""
 Background:
 --------
 NetCDF_file_combine.py
 
 
 Purpose:
 --------
 combine multple files into one netcdf 
 
 must have all the same variables

 Modifications:
 --------------

 2016-09-16 - SW Bell: migrate routine to EcoFOCI_MooringAnalysis and update routines
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
__modified__ = datetime.datetime(2014, 01, 29)
__version__  = "0.2.0"
__status__   = "Development"
__keywords__ = 'netCDF','meta','header'



"""------------------------------- MAIN------------------------------------------------"""

parser = argparse.ArgumentParser(description='Trim NC files')
parser.add_argument('-i','--inputfiles', nargs='+', type=str, help='full path to each file seperated by a space')
parser.add_argument('-o','--outputfile', type=str, help='name of output file')
parser.add_argument('-ek','--EPIC_KEY', nargs='+', help='EPIC Keys to keep')

args = parser.parse_args()

data={}
for ncfile in args.inputfiles:
    print "Reading {file}".format(file=ncfile)
    ###nc readin/out
    df = EcoFOCI_netCDF(ncfile)
    global_atts = df.get_global_atts()
    vars_dic = df.get_vars()
    tempdata = df.ncreadfile_dic()

    for key in vars_dic.keys():
        if not key in ['lat','lon','depth']: #non-increasing dimensions should be skipped
            try:
                data[key] = np.concatenate((data[key],tempdata[key]))
            except:
                data[key] = tempdata[key]
        else:                               #only one value should be kept for non-increasing dimensions
                data[key] = tempdata[key]

    #df.close()


time_ind = np.ones_like(data['time'],dtype=bool)

ncinstance = eNCw.NetCDF_Copy_Struct(savefile=args.outputfile)
ncinstance.file_create()
ncinstance.sbeglobal_atts(raw_data_file=global_atts['DATA_CMNT'], Station_Name=global_atts['MOORING'], 
                            Water_Depth=global_atts['WATER_DEPTH'], Inst_Type=global_atts['INST_TYPE'],
                            Water_Mass=global_atts['WATER_MASS'], Experiment=['EXPERIMENT'])
ncinstance.dimension_init(time_len=len(data['time'][time_ind]))
ncinstance.variable_init(vars_dic)
ncinstance.add_coord_data(depth=data['depth'], latitude=data['lat'], longitude=data['lon'],
                                 time1=data['time'][time_ind], time2=data['time2'][time_ind])
ncinstance.add_data(data=data, trim_index=time_ind)    
ncinstance.add_history('Merged files: {0}'.format(",".join(args.inputfiles)))
ncinstance.close()

