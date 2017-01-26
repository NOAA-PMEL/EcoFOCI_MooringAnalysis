#!/usr/bin/env python
"""
 wpak_plot.py

 Python Script to read a designated mooring SFC WX observations
    and generate a initial visualizations

History:
 --------
 2016-11-21: Migrate routine to new EcoFOCI Moorings structure

"""

#System Stack
import datetime, sys, os
import argparse

#Science Stack
import numpy as np

# User Stack
from calc.EPIC2Datetime import EPIC2Datetime, get_UDUNITS
from calc.calc_solar_rad import incoming_solar_rad
from plots.instrument_plot import TimeseriesWPAK 
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 9, 11)
__modified__ = datetime.datetime(2016, 11, 21)
__version__  = "0.1.0"
__status__   = "Development"
__keywords__ = 'timeseries', 'mooring', 'epic', 'netcdf', 'wpak'


"""--------------------------------main Routines---------------------------------------"""

parser = argparse.ArgumentParser(description='WPAK plotting')
parser.add_argument('DataPath', metavar='DataPath', type=str,
               help='full path to file')
parser.add_argument('-rad','--theoretical_radiation', action="store_true", 
               help='compare radiation to theoretical')
parser.add_argument("-fp",'--full_path', action="store_true", 
               help='provides full path to program: used if run as script')

args = parser.parse_args()

#read in WPAK data file
ncfile = args.DataPath
df = EcoFOCI_netCDF(ncfile)
global_atts = df.get_global_atts()
vars_dic = df.get_vars()
ncdata = df.ncreadfile_dic()
df.close()
nctime = get_UDUNITS(EPIC2Datetime(ncdata['time'],ncdata['time2']),'days since 0001-1-1') + 1.0

# filter data to convert 1e35 -> np.nan
for keynames in ncdata.keys():
    if keynames not in ['time','time2','lat','lon','latitude','longitude','depth','dep']:
        ncdata[keynames][np.where(ncdata[keynames][:,0,0,0] >= 1e30),0,0,0] = np.nan


p1 = TimeseriesWPAK(stylesheet='seaborn-poster', labelsize=16)
try:
    t1 = p1.add_title(mooringid=global_atts['MOORING'],
                             lat=ncdata['lat'][0],
                             lon=ncdata['lon'][0],
                             depth=ncdata['depth'][0],
                             instrument='WPAK')
except KeyError:
    t1 = p1.add_title(mooringid=global_atts['MOORING'],
                             lat=ncdata['latitude'][0],
                             lon=ncdata['longitude'][0],
                             depth=ncdata['depth'][0],
                             instrument='WPAK')    

plt1, fig1 = p1.plot(nctime, ncdata)

t = fig1.suptitle(t1)
t.set_y(0.06)

fig1.autofmt_xdate()
DefaultSize = fig1.get_size_inches()
fig1.set_size_inches( (DefaultSize[0]*4, DefaultSize[1]*2.5) )

if not args.full_path:
    plt1.savefig('images/'+ ncfile.split('/')[-1] + '.png', bbox_inches='tight', dpi = (300))
else:
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    plt1.savefig(parent_dir + '/EcoFOCI_MooringAnalysis/images/'+ ncfile1.split('/')[-1] + '.png', bbox_inches='tight', dpi = (300))

plt1.close()


### WPAK all parameters plot
if args.theoretical_radiation:
    theor_rad = np.ones_like(nctime)
    ### WPAK all parameters plot

    for i,datatime in enumerate(nctime):
        theor_rad[i] = incoming_solar_rad(datatime, ncdata['lat'][0], -1*ncdata['lon'][0], sol0=1365.0)

    (plt, fig) = p1.plot_rad(nctime, ncdata['Qs_133'][:,0,0,0], theor_rad, textlabel='Solar Rad', textlabel2='Theor. Solar Rad')

    t = fig1.suptitle(t1)
    t.set_y(0.06)

    fig1.autofmt_xdate()
    DefaultSize = fig1.get_size_inches()
    fig1.set_size_inches( (DefaultSize[0]*4, DefaultSize[1]*3) )

    if not args.full_path:
        plt1.savefig('images/'+ ncfile.split('/')[-1] + '_rad.png', bbox_inches='tight', dpi = (300))
    else:
        parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        plt1.savefig(parent_dir + '/EcoFOCI_MooringAnalysis/images/'+ ncfile1.split('/')[-1] + '_rad.png', bbox_inches='tight', dpi = (300))

    plt1.close()