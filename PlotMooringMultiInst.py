#!/usr/bin/env

"""
 Background:
 --------
 PlotMooringMultiInst.py
 
 
 Purpose:
 --------
 Plot Multiple Timeseries on same panel.  MULTIPLOT Overlay

 	Use Case1:
 		Plot the same parameter (eg temperature) from multiple instruments on same mooring from 
 		different depths. e.g. temperature from every MTR depth of a mooring deployment

 	Use Case2:
 		Plot the same parameter from different moorings at the same depth (not restricted to this).
 		e.g. temperature from the instrument closest to the surface over multiple deployments (onrunning SST plots)

 	Use Case3 (with -ctd flag):
 		Plot the discrete point from a ctd cast (nearby is most relevant) for QC puposes

 Modifications:
 --------------

 2016-09-16: SW Bell - Add support for parsing yaml files and translating between yaml and json/pyini
 					Begin code cleanup from previous iterations of the routine.  Merge so that one program can provide ctd cal
 					overlays.
  

"""

#System Stack
import datetime, bisect, sys, os
import argparse

#Science Stack
from netCDF4 import Dataset
import numpy as np

# Visual Stack
import matplotlib as mpl
mpl.use('Agg') 
import matplotlib.pyplot as plt
from matplotlib.dates import YearLocator, WeekdayLocator, MonthLocator, DayLocator, HourLocator, DateFormatter
import matplotlib.ticker as ticker

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
parser.add_argument("-mt",'--manual_timebounds', 
	nargs=2, 
	type=str, 
	help='set times to specified values (d-m-Y)')
parser.add_argument("-md",'--manual_databounds', 
	nargs=2, 
	type=float, 
	help='set databounds to specified values')
parser.add_argument("-multi",'--multiplot_overlay', 
	action="store_true", 
	help='plot multiple mooring data on one panel')
parser.add_argument("-ctd",'--ctd_calibration_plots', 
	action="store_true", 
	help='plot CTD calibration point on timeseries')
parser.add_argument("-overlay","--timeseries_overlay",
	action="store_true", 
	help='plot timeseries over each other')	
args = parser.parse_args()

"""---------------------------------------------------------------------------------------
Get parameters from specified pointerfile - 
an example is shown in the header description of
this program.  It can be of the .pyini (json) form or .yaml form

"""
if args.PointerFile.split('.')[-1] == 'pyini':
	pointer_file = ConfigParserLocal.get_config(args.PointerFile,'yaml')
elif args.PointerFile.split('.')[-1] == 'yaml':
	pointer_file = ConfigParserLocal.get_config(args.PointerFile,'yaml')
else:
	print "PointerFile format not recognized"
	sys.exit()

MooringID = pointer_file['MooringID']
color = pointer_file['colors']
linestyle = pointer_file['linestyle']
label = pointer_file['legend']
nominal_depth = pointer_file['nominal_depth']
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

### some mpl specif settings for fonts and plot style
mpl.rcParams['svg.fonttype'] = 'none'
plt.style.use(pointer_file['plot_stylesheet'])
#seaborn-poster -- fonts are smaller
#ggplot -- grey border, better axis frame
#bmh -- slightly heavier than ggplot for line weights


"""---------------------------------------------------------------------------------------
		Plot Multiple Mooring Datastreams on one panel
"""
databounds={}


if args.multiplot_overlay:
	### set title for plot
	ptitle = ("Plotted on: {timestr} \n from {mooringid} ").format(timestr=datetime.datetime.now().strftime('%Y/%m/%d %H:%M'), 
													 mooringid=MooringID )

	### initialize plot
	fig = plt.figure()
	plt.subplot2grid((3, 1), (1, 0), colspan=1, rowspan=3)

	### set arbitrary max and min bounds to be changed later based on data bounds
	databounds['max_t'] = 0
	databounds['min_t'] = 100000000
	databounds['max_v'] = -50
	databounds['min_v'] = 50
	label_thin = []

	### cycle through all files, retrieve data and plot
	print files_path
	for ind, ncfile in enumerate(files_path):
		print "Working on {activefile}".format(activefile=ncfile)

		#open/read netcdf files
		df = EcoFOCI_netCDF(ncfile)
		global_atts = df.get_global_atts()
		vars_dic = df.get_vars()
		ncdata = df.ncreadfile_dic()
		df.close()

		if args.timeseries_overlay:
			nctime = EPIC2Datetime(ncdata['time'],ncdata['time2'])

			def set_year_even(x):
				if x.year % 2 == 0:
					return x.replace(year=2000) 
				elif x.year %2 ==1:
					return x.replace(year=2001) 
			def set_year_odd(x):
				if x.year % 2 == 0:
					return x.replace(year=2000) 
				elif x.year %2 ==1:
					return x.replace(year=1999) 
			if nctime[0].year %2 ==0:
				nctime = [set_year_even(x) for x in nctime]
				start_year ='Even'
			elif nctime[0].year %2 ==1:
				nctime = [set_year_odd(x) for x in nctime]
				start_year ='Odd'
			#nctime = get_UDUNITS(nctime,'days since 0001-01-01') + 1.
		else:
			nctime = get_UDUNITS(EPIC2Datetime(ncdata['time'],ncdata['time2']),'days since 0001-01-01') + 1.

		#find and replace missing values with nans so they don't plot
		try:
			ncdata[plot_var][np.where(ncdata[plot_var] >1e30)] = np.nan
			try:
				label_thin = label_thin + [label[ind]]
			except TypeError:
				label_thin = label_thin + ['']

		except KeyError:
			pass

		#Plot data
		#plt.hold(True)
		if args.timeseries_overlay:
			if start_year == 'Even':
				year_ind = bisect.bisect_left(nctime, datetime.datetime(2001,1,1))
				plot_time = [x.replace(year=2000) for x in nctime]
				plt.plot(plot_time[:year_ind], ncdata[plot_var][:year_ind,0,0,0],color=color[ind],linestyle=linestyle[ind],linewidth=0.25)
				plt.plot(plot_time[year_ind:], ncdata[plot_var][year_ind:,0,0,0],color=color[ind+1],linestyle=linestyle[ind+1],linewidth=0.25)
			elif start_year == 'Odd':
				year_ind = bisect.bisect_left(nctime, datetime.datetime(2000,1,1))
				plot_time = [x.replace(year=2000) for x in nctime]
				plt.plot(plot_time[:year_ind], ncdata[plot_var][:year_ind,0,0,0],color=color[ind+1],linestyle=linestyle[ind+1],linewidth=0.25)
				plt.plot(plot_time[year_ind:], ncdata[plot_var][year_ind:,0,0,0],color=color[ind],linestyle=linestyle[ind],linewidth=0.25)
			nctime = get_UDUNITS(plot_time,'days since 0001-01-01') + 1.
		else:

			try:
				plt.plot(nctime, ncdata[plot_var][:,0,0,0],color=color[ind],linestyle=linestyle[ind],linewidth=0.25,markersize=1)
			except KeyError: #if the file doesn't have the specified epic_key it will through an exception
				print "Failed to plot {0}".format(plot_var)
				continue


		#setup bouds
		if nctime.max() > databounds['max_t']:
			databounds['max_t'] = nctime.max()
		if nctime.min() < databounds['min_t']:
			databounds['min_t'] = nctime.min()
		if np.nanmax(ncdata[plot_var][:,0,0,0]) > databounds['max_v']:
			databounds['max_v'] = np.nanmax(ncdata[plot_var][:,0,0,0])
		if np.nanmin(ncdata[plot_var][:,0,0,0]) < databounds['min_v']:
			databounds['min_v'] = np.nanmin(ncdata[plot_var][:,0,0,0])

	#set bounds if estabilshed by user
	if args.manual_timebounds:
		databounds['min_t'] = datetime.datetime.strptime(args.manual_timebounds[0],'%Y-%m-%d').toordinal()
		databounds['max_t'] = datetime.datetime.strptime(args.manual_timebounds[1],'%Y-%m-%d').toordinal()

	#set bounds if estabilshed by user
	if args.manual_databounds:
		databounds['min_v'] = args.manual_databounds[0]
		databounds['max_v'] = args.manual_databounds[1]
		

	ax2 = plt.gca()
	ax2.set_ylim(databounds['min_v'],databounds['max_v'])
	ax2.set_xlim([databounds['min_t'],databounds['max_t']])

	if not legend_off:
		leg = ax2.legend(label_thin, loc=legend_loc, ncol=6, fontsize=8)
		for legobj in leg.legendHandles:
			legobj.set_linewidth(2.0)
		
	plt.ylabel(Ylabel)
	if LocatorInterval == 'multi_year':
		ax2.xaxis.set_major_locator(YearLocator())
		ax2.xaxis.set_minor_locator(MonthLocator(bymonth=6))
		ax2.xaxis.set_major_formatter(ticker.NullFormatter())
		ax2.xaxis.set_minor_formatter(DateFormatter('%Y'))
		ax2.tick_params(axis='both', which='minor', labelsize=12)
	elif LocatorInterval == 'multi_day':
		ax2.xaxis.set_major_locator(MonthLocator())
		ax2.xaxis.set_minor_locator(DayLocator())
		ax2.xaxis.set_major_formatter(DateFormatter('%b'))
		ax2.xaxis.set_minor_formatter(DateFormatter('%d'))
		ax2.tick_params(axis='both', which='minor', labelsize=12)
	elif LocatorInterval == 'multi_month':
		ax2.xaxis.set_major_locator(MonthLocator())
		ax2.xaxis.set_minor_locator(MonthLocator(bymonth=[1,2,3,4,5,6,7,8,9,10,11,12], bymonthday=15))
		ax2.xaxis.set_major_formatter(ticker.NullFormatter())
		ax2.xaxis.set_minor_formatter(DateFormatter('%b'))
		ax2.tick_params(axis='both', which='minor', labelsize=12)		
	else:
		ax2.xaxis.set_major_locator(MonthLocator())
		ax2.xaxis.set_minor_locator(MonthLocator(bymonth=[1,3,5,7,9,11], bymonthday=15))
		ax2.xaxis.set_major_formatter(ticker.NullFormatter())
		ax2.xaxis.set_minor_formatter(DateFormatter('%b %y'))
		ax2.tick_params(axis='both', which='minor', labelsize=12)

	t = fig.suptitle(ptitle, fontsize=8)
	t.set_y(0.03)

	#fig.autofmt_xdate()
	DefaultSize = fig.get_size_inches()
	fig.set_size_inches( (DefaultSize[0], DefaultSize[1]) )
	plt.savefig('images/'+ MooringID + '_'+plot_var+'_'+datatype+'_all.'+output_type, bbox_inches='tight', dpi = (300))
	plt.close()

### individual calibration plots with mooring data files
# generate independant plots for each file in pointer file
# include calibration casts at specified depths, assume all ctd files start at zero so that the 
# index of the depth to be plotted is equivalent to the depth listed in the label parameter
if args.ctd_calibration_plots:
	
	for ind, ncfile in enumerate(files_path):

		fig = plt.figure()
		plt.subplot2grid((3, 1), (1, 0), colspan=1, rowspan=3)

		### set arbitrary max and min bounds to be changed later based on data bounds
		databounds['max_t'] = 0
		databounds['min_t'] = 100000000
		databounds['max_v'] = -50
		databounds['min_v'] = 50
		label_thin = []


		### mooring data retrieval
		print "Working on {activefile}".format(activefile=ncfile)
		df = EcoFOCI_netCDF(ncfile)
		global_atts = df.get_global_atts()
		vars_dic = df.get_vars()
		ncdata = df.ncreadfile_dic()
		df.close()
		nctime = get_UDUNITS(EPIC2Datetime(ncdata['time'],ncdata['time2']),'days since 0001-01-01') + 1.

		#find and replace missing values with nans so they don't plot
		try:
			ncdata[plot_var][np.where(ncdata[plot_var] >1e30)] = np.nan
			try:
				label_thin = label_thin + [label[ind]]
			except TypeError:
				label_thin = label_thin + ['']
		except KeyError:
			pass

		ptitle = ("Plotted on: {timestr} \n from {mooringid} for {depth}").format(timestr=datetime.datetime.now().strftime('%Y/%m/%d %H:%M'), 
					mooringid=MooringID, 
					depth=" ".join(ncfile.split('.')[0].split('_')[-2:]) )
		

			
		### plot mooring
		#plt.hold(False)
		try:
			plt.plot(nctime, ncdata[plot_var][:,0,0,0],'k', linewidth=0.5)
		except KeyError: #if the file doesn't have the specified epic_key it will through an exception
			print "Failed to plot {0}: variable likely not in timeseries".format(plot_var)
			continue

		#setup bouds
		if nctime.max() > databounds['max_t']:
			databounds['max_t'] = nctime.max()
		if nctime.min() < databounds['min_t']:
			databounds['min_t'] = nctime.min()
		if np.nanmax(ncdata[plot_var][:,0,0,0]) > databounds['max_v']:
			databounds['max_v'] = np.nanmax(ncdata[plot_var][:,0,0,0])
		if np.nanmin(ncdata[plot_var][:,0,0,0]) < databounds['min_v']:
			databounds['min_v'] = np.nanmin(ncdata[plot_var][:,0,0,0])

		### CTD cal data retrieval
		for ind_ctd, ncfile_ctd in enumerate(ctd_files_path):
			print "Adding CTD cast {active_ctd_file} at depth {depth}".format(active_ctd_file=ncfile_ctd,
				depth=int(nominal_depth[ind]))
			df_ctd = EcoFOCI_netCDF(ncfile_ctd)
			global_atts = df_ctd.get_global_atts()
			vars_dic = df_ctd.get_vars()
			ncdata_ctd = df_ctd.ncreadfile_dic()
			df_ctd.close()
			nctime_ctd = get_UDUNITS(EPIC2Datetime(ncdata_ctd['time'],ncdata_ctd['time2']),'days since 0001-01-01') + 1.

			### plot ctd data on top of mooring data
			#plt.hold(True)
			try:
				plt.scatter(nctime_ctd, ncdata_ctd[plot_var_ctd][0,int(nominal_depth[ind]),0,0],s=200,edgecolor='r',facecolor='none')
				plt.scatter(nctime_ctd, ncdata_ctd[plot_var_ctd][0,int(nominal_depth[ind]),0,0],s=50,edgecolor='r',facecolor='r',marker='+')
				print ncdata_ctd[plot_var_ctd][0,int(nominal_depth[ind]),0,0]
			except IndexError:
				print "Likely no matching depth {0} - cast only reaches {1}m".format(int(nominal_depth[ind]),len(ncdata_ctd[plot_var_ctd][0,:,0,0])-1)
				continue

		#set bounds if estabilshed by user
		if args.manual_timebounds:
			databounds['min_t'] = datetime.datetime.strptime(args.manual_timebounds[0],'%Y-%m-%d').toordinal()
			databounds['max_t'] = datetime.datetime.strptime(args.manual_timebounds[1],'%Y-%m-%d').toordinal()

		#set bounds if estabilshed by user
		if args.manual_databounds:
			databounds['min_v'] = args.manual_databounds[0]
			databounds['max_v'] = args.manual_databounds[1]

			
		###set plotting boundaries
		ax2 = plt.gca()
		ax2.set_ylim(databounds['min_v'],databounds['max_v'])
		ax2.set_xlim([databounds['min_t'],databounds['max_t']])

		if LocatorInterval == 'multi_year':
			ax2.xaxis.set_major_locator(YearLocator())
			ax2.xaxis.set_minor_locator(MonthLocator(bymonth=6))
			ax2.xaxis.set_major_formatter(ticker.NullFormatter())
			ax2.xaxis.set_minor_formatter(DateFormatter('%Y'))
			ax2.tick_params(axis='both', which='minor', labelsize=12)
		elif LocatorInterval == 'multi_day':
			ax2.xaxis.set_major_locator(MonthLocator())
			ax2.xaxis.set_minor_locator(DayLocator())
			ax2.xaxis.set_major_formatter(DateFormatter('%b'))
			ax2.xaxis.set_minor_formatter(DateFormatter('%d'))
			ax2.tick_params(axis='both', which='minor', labelsize=12)
		elif LocatorInterval == 'multi_month':
			ax2.xaxis.set_major_locator(MonthLocator())
			ax2.xaxis.set_minor_locator(MonthLocator(bymonth=[1,2,3,4,5,6,7,8,9,10,11,12], bymonthday=15))
			ax2.xaxis.set_major_formatter(ticker.NullFormatter())
			ax2.xaxis.set_minor_formatter(DateFormatter('%b'))
			ax2.tick_params(axis='both', which='minor', labelsize=12)	
		else:
			ax2.xaxis.set_major_locator(MonthLocator())
			ax2.xaxis.set_minor_locator(MonthLocator(bymonth=[1,3,5,7,9,11], bymonthday=15))
			ax2.xaxis.set_major_formatter(ticker.NullFormatter())
			ax2.xaxis.set_minor_formatter(DateFormatter('%b %y'))
			ax2.tick_params(axis='both', which='minor', labelsize=12)

		t = fig.suptitle(ptitle, fontsize=8)
		t.set_y(0.03)

		fig.autofmt_xdate()
		DefaultSize = fig.get_size_inches()
		fig.set_size_inches( (DefaultSize[0], DefaultSize[1]) )

		plt.savefig('images/'+ MooringID + '_'+plot_var+'_'+datatype+'_ctdcal_'+ncfile.split('.nc')[0].split('/')[-1]+'.png', bbox_inches='tight', dpi = (300))

		plt.close()