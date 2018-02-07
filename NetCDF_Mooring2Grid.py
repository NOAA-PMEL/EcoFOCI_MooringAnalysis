#!/usr/bin/env

"""
NetCDF_Mooring2Grid.py

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
 2017-04-06: SBELL Rename, convert to classes and clean routines
 2016-08-02: update EPIC to CF time routines to be in EPIC2Datetime.py and removed time calls
    in this routine.

"""

#System Stack
import sys
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

def PointerReader(pointer_file_path):
    """
    Get parameters from specified pointerfile: 
        An example is shown in the header description of
        this program.

    """

    if pointer_file_path.split('.')[-1] == 'pyini':
        pointer_file = ConfigParserLocal.get_config(pointer_file_path,'json')
    elif pointer_file_path.split('.')[-1] == 'yaml':
        pointer_file = ConfigParserLocal.get_config(pointer_file_path,'yaml')
    else:
        print("PointerFile format not recognized")
        sys.exit()  

    return pointer_file

class Data2Grid(object):
    r""" TODO: """


    def __init__(self, pointer_dic=None):
        """Initialize opening of netcdf file.

        Parameters
        ----------
        file_name : str
            full path to file on disk

        """

        self.pointer_dic = pointer_dic
        self.gaps_filled = False
        self.files_path = [a+b for a,b in zip(self.pointer_dic['mooring_data_path'],self.pointer_dic['mooring_files'])]
        self.plot_var = self.pointer_dic['EPIC_Key']
        self.history = ''
        self.MooringID = pointer_dic['MooringID'].replace('-','')

    def load(self):
        self.data = {}
        for ind, ncfile in enumerate(self.files_path):
            print("Working on {0}").format(ncfile)

            df = EcoFOCI_netCDF(ncfile)
            df.get_global_atts()
            vars_dic = df.get_vars()
            if self.plot_var in vars_dic:
                ncdata = df.ncreadfile_dic()
                df.close()
                ncdata[self.plot_var][np.where(ncdata[self.plot_var] >1e34)] = np.nan
            else:
                continue

            self.ncdata = ncdata #only save last file
            self.data[self.pointer_dic['nominal_depth'][ind]] = {'data': ncdata[self.plot_var][:,0,0,0],'time': EPIC2Datetime(ncdata['time'],ncdata['time2'])}

    def gridTime(self,dt_hour=1,dt_error_min=5):
        
        #convert datetime
        start_time_int = date2num(datetime.datetime.strptime(self.pointer_dic['start_time'],"%Y-%m-%d"),'days since 0001-01-01')
        end_time_int = date2num(datetime.datetime.strptime(self.pointer_dic['end_time'],"%Y-%m-%d"),'days since 0001-01-01')

        #build time array
        self.dt = dt_hour/24.
        self.dte = dt_error_min/(24.*60.)
        self.time_array = np.arange(start_time_int, end_time_int+self.dt, self.dt)
        #convert to python serial date
        for key in self.data.keys():
            # have to add one because the num2date function is a delta function
            self.data[key]['time'] = [date2num(x,'days since 0001-01-01') for x in self.data[key]['time']]

    def GridData(self):

        ### vertically grid data to evenly space gridspoints
        self.press_grid = np.arange(0,self.pointer_dic['depth_m']  +self.pointer_dic['depth_interval_m'],self.pointer_dic['depth_interval_m']) 

        mesh_grid_data = np.array([])
        mesh_grid_data2 = np.array([])
        #after reading the data into dictionary sort and match times
        for i, st in enumerate(self.time_array):
            if (datetime.datetime.fromordinal(int(st))).day == 1:
                print(datetime.datetime.fromordinal(int(st)))
            mesh_depth_data = np.array([])
            mesh_depth_data2 = np.array([])
            self.press_grid_data = np.array([])
            for key in sorted(self.data):
                irreg_depth = np.array(key)
                irreg_data = self.data[key]['data'][np.where((self.data[key]['time'] >= st - self.dte) & (self.data[key]['time'] <= st + self.dte))]
                if irreg_data.size != 0:
                    irreg_data=np.nanmean([irreg_data])
                else:
                    irreg_data=np.array([np.nan])

                mesh_depth_data = np.hstack((mesh_depth_data, irreg_data))
                self.press_grid_data = np.hstack((self.press_grid_data, irreg_depth))


            for pg in self.press_grid:
                ireg_ind = np.where((self.press_grid_data > pg) & (self.press_grid_data <= pg+self.pointer_dic['depth_interval_m']))
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

                self.mesh_grid_data = mesh_grid_data
                self.mesh_grid_data2 = mesh_grid_data2


    def fillgaps(self):
        mesh_grid_data_fg = self.mesh_grid_data
        mask = np.isnan(self.mesh_grid_data)
        mesh_grid_data_fg[mask] = np.interp(np.flatnonzero(mask), np.flatnonzero(~mask), self.mesh_grid_data[~mask])

        self.mesh_grid_data = mesh_grid_data_fg
        self.gaps_filled = True

    def save2nc(self,PointerFile=None):

        inst_type = self.pointer_dic['Ylabel']
        EPIC_VARS_dict = ConfigParserLocal.get_config('EcoFOCI_config/epickeys/' + self.plot_var + '_epickeys.json','json')

        epic_dt = Datetime2EPIC((num2date(self.time_array,'days since 0001-01-01')).tolist())

        data_dic = {}
        self.mesh_grid_data[np.isnan(self.mesh_grid_data)] = 1e35
        data_dic[self.plot_var] = self.mesh_grid_data
        ncinstance = GriddedNC(savefile='data/'+self.MooringID+'_'+self.plot_var+'_gridded.nc')
        ncinstance.file_create()
        ncinstance.sbeglobal_atts(raw_data_file='', Station_Name = self.MooringID, Water_Depth=self.pointer_dic['depth_m'], InstType=inst_type)
        ncinstance.dimension_init(time_len=len(self.time_array),depth_len=len(self.data.keys()))
        ncinstance.variable_init(EPIC_VARS_dict)
        try:
            ncinstance.add_coord_data(depth=sorted(self.data.keys()), latitude=self.ncdata['lat'][0], longitude=self.ncdata['lon'][0], time1=epic_dt[0], time2=epic_dt[1])
        except:
            ncinstance.add_coord_data(depth=sorted(self.data.keys()), latitude=self.ncdata['latitude'][0], longitude=self.ncdata['longitude'][0], time1=epic_dt[0], time2=epic_dt[1])
        ncinstance.add_data(EPIC_VARS_dict,data_dic=data_dic)
        if self.gaps_filled:
            ncinstance.add_history('Gridded using:{program}, Config file used:{file}\n'.format(program=__file__,file=PointerFile))
        else:
            ncinstance.add_history('Gridded using:{program}, Config file used:{file}\n Gaps filled Linearly\n'.format(program=__file__,file=PointerFile))
        ncinstance.close()

    def contour(self):

        #find small overlap period and replace with np.nan

        overlap_t=self.time_array[3645]
        self.mesh_grid_data[np.where((self.time_array>=overlap_t)&(self.time_array<=overlap_t+1))]=np.nan

        fig = plt.figure()
        ax = plt.subplot(111)
        extent = (self.time_array.min(), self.time_array.max(), self.press_grid.max(), self.press_grid.min()) # extent of the plots
        plt.contourf(self.time_array, self.press_grid_data,np.transpose(self.mesh_grid_data),extent=extent,cmap=cmocean.cm.thermal, levels=np.arange(-2.0,15.0,1.0))
        ax.xaxis.set_major_locator(MonthLocator(interval=1))
        ax.xaxis.set_minor_locator(DayLocator(bymonthday=15))
        ax.xaxis.set_major_formatter(ticker.NullFormatter())
        ax.xaxis.set_minor_formatter(DateFormatter('%b %y'))
        cbar = plt.colorbar()
        cbar.set_label(self.pointer_dic['Ylabel'])
        plt.gca().invert_yaxis()
        DefaultSize = fig.get_size_inches()
        fig.set_size_inches( (DefaultSize[0]*5, DefaultSize[1]) )
        plt.savefig('images/'+self.MooringID+'_'+self.pointer_dic['EPIC_Key']+'_contour.png',bbox_inches='tight', dpi=(300))

    def image(self):

        if self.pointer_dic['Ylabel'].lower() == 'temperature':
            cmap=cmocean.cm.thermal
            vmin = np.nanmin(self.mesh_grid_data2)
            vmax = np.nanmax(self.mesh_grid_data2)
        elif self.pointer_dic['Ylabel'].lower() == 'salinity':
            cmap=cmocean.cm.haline
            vmin = np.nanmin(self.mesh_grid_data2)
            vmax = np.nanmax(self.mesh_grid_data2)
        else:
            cmap='viridis'
            vmin = np.nanmin(self.mesh_grid_data2)
            vmax = np.nanmax(self.mesh_grid_data2)


        fig = plt.figure()
        ax = plt.subplot(111)
        extent = (self.time_array.min(), self.time_array.max(), self.press_grid.max(), self.press_grid.min()) # extent of the plots
        plt.imshow(np.transpose(self.mesh_grid_data2),extent=extent, cmap=cmap, vmin=vmin, vmax=vmax, aspect='auto')
        ax.xaxis.set_major_locator(MonthLocator(interval=1))
        ax.xaxis.set_minor_locator(DayLocator(bymonthday=15))
        ax.xaxis.set_major_formatter(ticker.NullFormatter())
        ax.xaxis.set_minor_formatter(DateFormatter('%b %y'))
        cbar = plt.colorbar()
        cbar.set_label(self.pointer_dic['Ylabel'])
        DefaultSize = fig.get_size_inches()
        fig.set_size_inches( (DefaultSize[0]*2.5, DefaultSize[1]/2.5) )
        plt.savefig('images/'+self.MooringID+'_'+self.pointer_dic['EPIC_Key']+'_image.png',bbox_inches='tight', dpi=(300))

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


pdic = PointerReader(args.PointerFile)
plt.style.use(pdic['plot_stylesheet'])

MData = Data2Grid(pointer_dic=pdic)
MData.load()
MData.gridTime()
MData.GridData()

if args.contour and not args.FillGaps:

    MData.contour()
        
if args.contour and args.FillGaps:

    MData.fillgaps()
    MData.contour()

if args.image:

    MData.image()

if args.netcdf:

    MData.save2nc()

if args.FillGaps and args.netcdf:

    MData.fillgaps()
    MData.save2nc()
   