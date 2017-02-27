#!/usr/bin/env

"""
 Background:
 --------
 ExportMooringMultiInst.py
 
 
 Purpose:
 --------
 Export Multiple Timeseries in same excel document.  

 	Use Case1:
 		Save the same parameter (eg temperature) from multiple instruments on same mooring from 
 		different depths. e.g. temperature from every MTR depth of a mooring deployment

 	Use Case2:
 		Save the same parameter from different moorings at the same depth (not restricted to this).
 		e.g. temperature from the instrument closest to the surface over multiple deployments (onrunning SST plots)

 	Use Case3 (with -ctd flag):
 		Save the discrete point from a ctd cast (nearby is most relevant) for QC puposes

 Modifications:
 --------------

 2017-02-23: Use PlotMooringMultiInst.py as basis for routines to export instead
 2016-09-16: SW Bell - Add support for parsing yaml files and translating between yaml and json/pyini
 					Begin code cleanup from previous iterations of the routine.  Merge so that one program can provide ctd cal
 					overlays.
  

"""

#System Stack
import datetime, sys, os
import argparse

#Science Stack
from netCDF4 import Dataset
import numpy as np
import pandas as pd

# User Stack
from io_utils import ConfigParserLocal
from calc.EPIC2Datetime import EPIC2Datetime, get_UDUNITS
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF

__author__   = 'Shaun Bell'
__email__	= 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 9, 11)
__modified__ = datetime.datetime(2016, 9, 5)
__version__  = "0.1.0"
__status__   = "Development"
__keywords__ = 'Mooring', 'comparisons', 'Cruise', 'plots'


"""--------------------------------main Routines---------------------------------------"""

parser = argparse.ArgumentParser(description='SBE56 plotting')
parser.add_argument('PointerFile', 
	metavar='PointerFile', 
	type=str, 
	help='full path to pointer file')
parser.add_argument("-multi",'--multiplot', 
	action="store_true", 
	help='plot multiple mooring data on one panel')
parser.add_argument("-ctd",'--ctd_calibration_plots', 
	action="store_true", 
	help='plot CTD calibration point on timeseries')

args = parser.parse_args()

"""---------------------------------------------------------------------------------------
Get parameters from specified pointerfile - 
an example is shown in the header description of
this program.  It can be of the .pyini (json) form or .yaml form

"""
if args.PointerFile.split('.')[-1] == 'pyini':
	pointer_file = ConfigParserLocal.get_config(args.PointerFile)
elif args.PointerFile.split('.')[-1] == 'yaml':
	pointer_file = ConfigParserLocal.get_config_yaml(args.PointerFile)
else:
	print "PointerFile format not recognized"
	sys.exit()

MooringID = pointer_file['MooringID']
color_options = pointer_file['colors']
label = pointer_file['legend']
legend_loc = pointer_file['legend_loc']
legend_off = pointer_file['legend_off']
datatype = pointer_file['dtype']
plot_var = pointer_file['EPIC_Key']
plot_var_ctd = pointer_file['EPIC_Key_ctd']
LocatorInterval = pointer_file['Date_Ticks']
Ylabel = pointer_file['Ylabel']
output_type = pointer_file['output_type']

MooringDataPath = pointer_file['mooring_data_path']
files = pointer_file['mooring_files']
files_path = [a+b for a,b in zip(MooringDataPath,files)]

CTDDataPath = pointer_file['ctd_data_path']
ctd_files = pointer_file['ctd_files']
ctd_files_path = [a+b for a,b in zip(CTDDataPath,ctd_files)]



"""---------------------------------------------------------------------------------------
		Plot Multiple Mooring Datastreams on one panel
"""
databounds={}

if args.multiplot:


	### cycle through all files, retrieve data and plot
	print files_path
	writer = pd.ExcelWriter('data/'+MooringID+'_'+plot_var+'.xlsx', engine='xlsxwriter', datetime_format='YYYY-MM-DD HH:MM:SS')
	label_thin = []
	for ind, ncfile in enumerate(files_path):
		print "Working on {activefile}".format(activefile=ncfile)

		#open/read netcdf files
		df = EcoFOCI_netCDF(ncfile)
		global_atts = df.get_global_atts()
		vars_dic = df.get_vars()
		ncdata = df.ncreadfile_dic()
		df.close()

		nctime = EPIC2Datetime(ncdata['time'],ncdata['time2'])

		#find and replace missing values with nans so they don't plot
		try:
			ncdata[plot_var][np.where(ncdata[plot_var] >1e30)] = np.nan
			try:
				label_thin = label_thin + [label[ind]]
			except TypeError:
				label_thin = label_thin + ['']

		except KeyError:
			pass

		try:
			df = pd.DataFrame(ncdata[plot_var][:,0,0,0], index=nctime, columns=[plot_var])
			df.to_excel(writer, sheet_name=files[ind].split('.')[0])
		except KeyError: #if the file doesn't have the specified epic_key it will through an exception
			print "Failed to save {0}".format(plot_var)
			continue

	writer.save()


### individual calibration plots with mooring data files
# generate independant plots for each file in pointer file
# include calibration casts at specified depths, assume all ctd files start at zero so that the 
# index of the depth to be plotted is equivalent to the depth listed in the label parameter
if args.ctd_calibration_plots:

	writer = pd.ExcelWriter('data/'+MooringID+'_'+plot_var+'.xlsx', engine='xlsxwriter', datetime_format='YYYY-MM-DD HH:MM:SS')
	label_thin = []
	for ind, ncfile in enumerate(files_path):
		### mooring data retrieval
		print "Working on {activefile}".format(activefile=ncfile)
		df = EcoFOCI_netCDF(ncfile)
		global_atts = df.get_global_atts()
		vars_dic = df.get_vars()
		ncdata = df.ncreadfile_dic()
		df.close()
		nctime = EPIC2Datetime(ncdata['time'],ncdata['time2'])

		#find and replace missing values with nans so they don't plot
		try:
			ncdata[plot_var][np.where(ncdata[plot_var] >1e30)] = np.nan
			try:
				label_thin = label_thin + [label[ind]]
			except TypeError:
				label_thin = label_thin + ['']

		except KeyError:
			pass

		try:
			df = pd.DataFrame(ncdata[plot_var][:,0,0,0], index=nctime, columns=[plot_var])
			df.to_excel(writer, sheet_name=files[ind].split('.')[0])
		except KeyError: #if the file doesn't have the specified epic_key it will through an exception
			print "Failed to save {0}".format(plot_var)
			continue



	### CTD cal data retrieval
	for ind_ctd, ncfile_ctd in enumerate(ctd_files_path):
		print "Adding CTD cast {active_ctd_file}".format(active_ctd_file=ncfile_ctd)
		df_ctd = EcoFOCI_netCDF(ncfile_ctd)
		global_atts = df_ctd.get_global_atts()
		vars_dic = df_ctd.get_vars()
		ncdata_ctd = df_ctd.ncreadfile_dic()
		df_ctd.close()
		nctime_ctd = EPIC2Datetime(ncdata_ctd['time'],ncdata_ctd['time2'])

		try:
			#	plt.scatter(nctime_ctd, ncdata_ctd[plot_var_ctd][0,int(label[ind].split('m')[0]),0,0],s=200,edgecolor='r',facecolor='none')

			df = pd.DataFrame(np.hstack((np.array([nctime_ctd]*len(ncdata_ctd['dep'])),ncdata_ctd[plot_var_ctd][0,:,:,0])), index=ncdata_ctd['dep'][:], columns=['time',plot_var])
			df.to_excel(writer, sheet_name=ctd_files[ind_ctd].split('.')[0])
		except IndexError:
			print "Likely no matching depth {0} - cast only reaches {1}m".format(int(label[ind].split('m')[0]),len(ncdata_ctd[plot_var_ctd][0,:,0,0])-1)
			continue
	writer.save()

