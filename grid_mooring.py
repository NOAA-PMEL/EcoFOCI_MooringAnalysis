#!/usr/bin/env

"""
grid_mooring.py

Usage:
------
grid_mooring.py -h

example pointer-file format:
----------------------------


{
    "MooringID": "15BS-2C_sctimetest", 
    "mooring_data_path": [
    "/Volumes/WDC_internal/Users/bell/ecoraid/2015/Moorings/15bs2c/working/elapsed_seconds/",
    "/Volumes/WDC_internal/Users/bell/ecoraid/2015/Moorings/15bs2c/working/instrument_doy/",
    "/Volumes/WDC_internal/Users/bell/ecoraid/2015/Moorings/15bs2c/working/instrument_seconds/"],
    "mooring_files": [
    "15bs2c_sc_0012m.unqcd.interpolated.trimmed_missing.nc",
    "15bs2c_sc_0012m.unqcd.interpolated.trimmed_missing.nc",
    "15bs2c_sc_0012m.unqcd.interpolated.trimmed_missing.nc"],
    "nominal_depth": [12,12,12], 
    "EPIC_Key": "T_20",
    "Ylabel": "Temperature",
    "Date_Ticks": "multi_month",
    "plot_stylesheet": "seaborn-poster",
    "output_type": "png"
}



 History:
 --------
 2016-08-02: update EPIC to CF time routines to be in EPIC2Datetime.py and removed time calls
    in this routine.

"""

#System Stack
import os
import datetime
import argparse

#Science Stack
from netCDF4 import Dataset, num2date, date2num
import numpy as np

# Visualization Stack
import matplotlib as mpl
#mpl.use('Agg') 
import matplotlib.pyplot as plt
from matplotlib.dates import YearLocator, MonthLocator, DayLocator, HourLocator, DateFormatter
import matplotlib.ticker as ticker
import cmocean

# Local User Stack
from io_utils.grid_mooring2nc import GriddedNC 
from io_utils import ConfigParserLocal
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF
from calc.EPIC2Datetime import EPIC2Datetime, Datetime2EPIC

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 9, 11)
__modified__ = datetime.datetime(2015, 2, 5)
__version__  = "0.1.0"
__status__   = "Development"
__keywords__ = 'Mooring', 'gridded', '2d', 'plots'

    
"""--------------------------------main Routines---------------------------------------"""

parser = argparse.ArgumentParser(description='Grid and plot data from multiple instruments on a mooring')
parser.add_argument('PointerFile', metavar='PointerFile', type=str, 
               help='full path to pointer file')
parser.add_argument('-fg','--FillGaps', action="store_true",
               help='Interpolate and Fill Gaps in bin averaged data')
parser.add_argument('-i','--image', action="store_true",
               help='Make an image plot')
parser.add_argument('-c','--contour', action="store_true",
               help='Make a contour plot')
parser.add_argument('-nc','--netcdf', action="store_true",
               help='Save gridded data set')
               
args = parser.parse_args()

"""
Get parameters from specified pointerfile: 
    An example is shown in the header description of
    this program.

"""
if args.PointerFile.split('.')[-1] == 'pyini':
    pointer_file = ConfigParserLocal.get_config(args.PointerFile)
elif args.PointerFile.split('.')[-1] == 'yaml':
    pointer_file = ConfigParserLocal.get_config_yaml(args.PointerFile)
else:
    print "PointerFile format not recognized"
    sys.exit()

MooringDataPath = pointer_file['mooring_data_path']
files = pointer_file['mooring_files']
MooringID = pointer_file['MooringID']
plot_var = pointer_file['EPIC_Key']
LocatorInterval = pointer_file['Date_Ticks']
Ylabel = pointer_file['Ylabel']
output_type = pointer_file['output_type']
nominal_depth = pointer_file['nominal_depth']
start_time = pointer_file['start_time']
end_time = pointer_file['end_time']
depth_interval_m = pointer_file['depth_interval_m']
depth_m = pointer_file['depth_m']


files_path = [a+b for a,b in zip(MooringDataPath,files)]
if args.PointerFile.split('.')[-1] == 'pyini':
    start_time_int = date2num(datetime.datetime.strptime(start_time,"%Y-%m-%d"),'days since 0001-01-01')
    end_time_int = date2num(datetime.datetime.strptime(end_time,"%Y-%m-%d"),'days since 0001-01-01')
elif args.PointerFile.split('.')[-1] == 'yaml':
    start_time_int = date2num(datetime.datetime.strptime(start_time,"%Y-%m-%d"),'days since 0001-01-01')
    end_time_int = date2num(datetime.datetime.strptime(end_time,"%Y-%m-%d"),'days since 0001-01-01')


### some mpl specif settings for fonts and plot style
#mpl.rcParams['svg.fonttype'] = 'none'
plt.style.use(pointer_file['plot_stylesheet'])
#seaborn-poster -- fonts are smaller
#ggplot -- grey border, better axis frame
#bmh -- slightly heavier than ggplot for line weights

### cycle through all files, retrieve data
print files_path
data = {}
for ind, ncfile in enumerate(files_path):
    print "Working on {0}".format(ncfile)

    df = EcoFOCI_netCDF(ncfile)
    global_atts = df.get_global_atts()
    vars_dic = df.get_vars()
    ncdata = df.ncreadfile_dic()
    df.close()

    #find and replace missing values with nans so they don't plot
    try:
        ncdata[plot_var][np.where(ncdata[plot_var] >1e34)] = np.nan
    except KeyError:
        continue
    data[nominal_depth[ind]] = {'data': ncdata[plot_var][:,0,0,0],'time': EPIC2Datetime(ncdata['time'],ncdata['time2'])}

#build time array
dt = 1./24.
dte = 5./(24.*60.)
time_array = np.arange(start_time_int, end_time_int+dt, dt)
#convert to python serial date
for key in data.keys():
    # have to add one because the num2date function is a delta function
    data[key]['time'] = [date2num(x,'days since 0001-01-01') for x in data[key]['time']]


#build data array
### vertically grid data to evenly space gridspoints
press_grid = np.arange(0,depth_m+depth_interval_m,depth_interval_m) 

mesh_grid_data = np.array([])
mesh_grid_data2 = np.array([])
date_time = []
#after reading the data into dictionary sort and match times
for i, st in enumerate(time_array):
    if (datetime.datetime.fromordinal(int(st))).day == 1:
        print datetime.datetime.fromordinal(int(st))
    mesh_depth_data = np.array([])
    mesh_depth_data2 = np.array([])
    press_grid_data = np.array([])
    for key in sorted(data):
        irreg_depth = np.array(key)
        irreg_data = data[key]['data'][np.where((data[key]['time'] >= st - dte) & (data[key]['time'] <= st + dte))]
        if irreg_data.size != 0:
            irreg_data=np.nanmean([irreg_data])
        else:
            irreg_data=np.array([np.nan])

        mesh_depth_data = np.hstack((mesh_depth_data, irreg_data))
        press_grid_data = np.hstack((press_grid_data, irreg_depth))


    for pg in press_grid:
        ireg_ind = np.where((press_grid_data > pg) & (press_grid_data <= pg+depth_interval_m))
        if not mesh_depth_data[ireg_ind]:
            mesh_depth_data2 = np.hstack((mesh_depth_data2, np.nan))
        else:
            mesh_depth_data2 = np.hstack((mesh_depth_data2, np.median(mesh_depth_data[ireg_ind])))
            
    if i==0:
        mesh_grid_data = mesh_depth_data
        mesh_grid_data2 = mesh_depth_data2
    else:
        mesh_grid_data=np.vstack((mesh_grid_data, mesh_depth_data))
        mesh_grid_data2=np.vstack((mesh_grid_data2, mesh_depth_data2))  

if args.FillGaps:
    mesh_grid_data_fg = mesh_grid_data
    mask = np.isnan(mesh_grid_data)
    mesh_grid_data_fg[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), mesh_grid_data[~mask])
        
if args.contour:

    #find small overlap period and replace with np.nan

    overlap_t=time_array[3645]
    mesh_grid_data[np.where((time_array>=overlap_t)&(time_array<=overlap_t+1))]=np.nan

    fig = plt.figure()
    ax = plt.subplot(111)
    extent = (time_array.min(), time_array.max(), press_grid.max(), press_grid.min()) # extent of the plots
    plt.contourf(time_array, press_grid_data,np.transpose(mesh_grid_data),extent=extent,cmap=cmocean.cm.thermal, levels=np.arange(-2.0,15.0,1.0))
    ax.xaxis.set_major_locator(MonthLocator(interval=1))
    ax.xaxis.set_minor_locator(DayLocator(bymonthday=15))
    ax.xaxis.set_major_formatter(ticker.NullFormatter())
    ax.xaxis.set_minor_formatter(DateFormatter('%b %y'))
    cbar = plt.colorbar()
    cbar.set_label('Temperature (C)')
    #plt.contour(time_array, press_grid_data,np.transpose(mesh_grid_data),extent=extent, colors='k', levels=np.arange(1.0,14.0,1.0))
    plt.gca().invert_yaxis()
    DefaultSize = fig.get_size_inches()
    fig.set_size_inches( (DefaultSize[0]*5, DefaultSize[1]) )
    plt.savefig('contour.png',bbox_inches='tight', dpi=(300))
        
if args.contour and args.FillGaps:

    #find small overlap period and replace with np.nan

    overlap_t=time_array[3645]
    mesh_grid_data[np.where((time_array>=overlap_t)&(time_array<=overlap_t+1))]=np.nan

    fig = plt.figure()
    ax = plt.subplot(111)
    extent = (time_array.min(), time_array.max(), press_grid.max(), press_grid.min()) # extent of the plots
    plt.contourf(time_array, press_grid_data,np.transpose(mesh_grid_data_fg),extent=extent,cmap=cmocean.cm.thermal, levels=np.arange(-2.0,15.0,1.0))
    ax.xaxis.set_major_locator(MonthLocator(interval=1))
    ax.xaxis.set_minor_locator(DayLocator(bymonthday=15))
    ax.xaxis.set_major_formatter(ticker.NullFormatter())
    ax.xaxis.set_minor_formatter(DateFormatter('%b %y'))
    cbar = plt.colorbar()
    cbar.set_label('Temperature (C)')
    #plt.contour(time_array, press_grid_data,np.transpose(mesh_grid_data),extent=extent, colors='k', levels=np.arange(1.0,14.0,1.0))
    plt.gca().invert_yaxis()
    DefaultSize = fig.get_size_inches()
    fig.set_size_inches( (DefaultSize[0]*5, DefaultSize[1]) )
    plt.savefig('contour.png',bbox_inches='tight', dpi=(300))

if args.image:
    fig = plt.figure()
    ax = plt.subplot(111)
    extent = (time_array.min(), time_array.max(), press_grid.max(), press_grid.min()) # extent of the plots
    plt.imshow(np.transpose(mesh_grid_data2),extent=extent, cmap=cmocean.cm.thermal, vmin=-2.0, vmax=15.0, aspect='auto')
    ax.xaxis.set_major_locator(MonthLocator(interval=1))
    ax.xaxis.set_minor_locator(DayLocator(bymonthday=15))
    ax.xaxis.set_major_formatter(ticker.NullFormatter())
    ax.xaxis.set_minor_formatter(DateFormatter('%b %y'))
    cbar = plt.colorbar()
    cbar.set_label('Temperature (C)')
    DefaultSize = fig.get_size_inches()
    fig.set_size_inches( (DefaultSize[0]*5, DefaultSize[1]) )
    plt.savefig('image.png',bbox_inches='tight', dpi=(300))

if args.netcdf:

    inst_type = Ylabel
    EPIC_VARS_dict = ConfigParserLocal.get_config('EcoFOCI_config/epickeys/' + plot_var + '_epickeys.json')

    epic_dt = Datetime2EPIC((num2date(time_array,'days since 0001-01-01')).tolist())

    data_dic = {}
    mesh_grid_data[np.isnan(mesh_grid_data)] = 1e35
    data_dic[plot_var] = mesh_grid_data
    ncinstance = GriddedNC(savefile=inst_type+'_gridded.nc')
    ncinstance.file_create()
    ncinstance.sbeglobal_atts(raw_data_file='', Station_Name = MooringID, Water_Depth=depth_m, InstType=inst_type)
    ncinstance.dimension_init(time_len=len(time_array),depth_len=len(data.keys()))
    ncinstance.variable_init(EPIC_VARS_dict)
    try:
        ncinstance.add_coord_data(depth=sorted(data.keys()), latitude=ncdata['lat'][0], longitude=ncdata['lon'][0], time1=epic_dt[0], time2=epic_dt[1])
    except:
        ncinstance.add_coord_data(depth=sorted(data.keys()), latitude=ncdata['latitude'][0], longitude=ncdata['longitude'][0], time1=epic_dt[0], time2=epic_dt[1])
    ncinstance.add_data(EPIC_VARS_dict,data_dic=data_dic)
    ncinstance.add_history('Gridded using:{program}, Config file used:{file}\n'.format(program=__file__,file=args.PointerFile))
    ncinstance.close()

if args.FillGaps and args.netcdf:

    inst_type = Ylabel
    EPIC_VARS_dict = ConfigParserLocal.get_config('EcoFOCI_config/epickeys/' + plot_var + '_epickeys.json')

    epic_dt = Datetime2EPIC((num2date(time_array,'days since 0001-01-01')).tolist())

    data_dic = {}
    mesh_grid_data[np.isnan(mesh_grid_data)] = 1e35
    data_dic[plot_var] = mesh_grid_data
    ncinstance = GriddedNC(savefile=inst_type+'_gridded.nc')
    ncinstance.file_create()
    ncinstance.sbeglobal_atts(raw_data_file='', Station_Name = MooringID, Water_Depth=depth_m, InstType=inst_type)
    ncinstance.dimension_init(time_len=len(time_array),depth_len=len(data.keys()))
    ncinstance.variable_init(EPIC_VARS_dict)
    try:
        ncinstance.add_coord_data(depth=sorted(data.keys()), latitude=ncdata['lat'][0], longitude=ncdata['lon'][0], time1=epic_dt[0], time2=epic_dt[1])
    except:
        ncinstance.add_coord_data(depth=sorted(data.keys()), latitude=ncdata['latitude'][0], longitude=ncdata['longitude'][0], time1=epic_dt[0], time2=epic_dt[1])
    ncinstance.add_data(EPIC_VARS_dict,data_dic=data_dic)
    ncinstance.add_history('Gridded using:{program}, Config file used:{file}\n Gaps filled Linearly\n'.format(program=__file__,file=args.PointerFile))
    ncinstance.close()    