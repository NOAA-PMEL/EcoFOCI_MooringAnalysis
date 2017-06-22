#!/usr/bin/env python

"""
timeseries_TvS.py

TS plot

Input - CruiseID

 History:
 --------
 2017-06-21: Migrate to EcoFOCI_MooringAnalysis pkg and unify netcdf creation code so
    that it is no longer instrument dependant


"""

#System Stack
import datetime
import os
import argparse


#Science Stack
import numpy as np
from netCDF4 import Dataset
import seawater as sw

#Visual Packages
import matplotlib as mpl
mpl.use('Agg') 
import matplotlib.pyplot as plt
from matplotlib.ticker import AutoMinorLocator

# User Stack
from calc.EPIC2Datetime import EPIC2Datetime, get_UDUNITS
from plots.instrument_plot import TimeseriesPorpertyPropertyPlot
from io_utils.EcoFOCI_netCDF_read import EcoFOCI_netCDF

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 05, 22)
__modified__ = datetime.datetime(2014, 06, 24)
__version__  = "0.2.0"
__status__   = "Development"
__keywords__ = 'timeseries', 'Plots', 'Cruise', 'QC','property-property'


"""------------------------------------- Main -----------------------------------------"""

parser = argparse.ArgumentParser(description='Timeseries T/S Property/Property plot')
parser.add_argument('DataPath', metavar='DataPath', type=str,help='full path to directory of processed nc files')
parser.add_argument('-ss','--sal_scale', nargs=2, type=float, help='fixed salinity scale (min max)')
parser.add_argument('-ts','--temp_scale', nargs=2, type=float, help='fixed temperature scale (min max)')
parser.add_argument('-timebounds','--timebounds', nargs=3, type=str, help='fixed timebounds start: yyyy-mm-dd end: yyyy-mm-dd "month"')

args = parser.parse_args()

print "Working on file %s " % args.DataPath

nc = EcoFOCI_netCDF(args.DataPath)
ncdata = nc.ncreadfile_dic()
g_atts = nc.get_global_atts()
nc.close()

cast_time = EPIC2Datetime(ncdata['time'],ncdata['time2'])
doy = np.array([x.timetuple().tm_yday for x in cast_time])
    

p1 = TimeseriesPorpertyPropertyPlot()
try:
    t1 = p1.add_title(mooringid=global_atts['MOORING'],
                             lat=ncdata['lat'][0],
                             lon=ncdata['lon'][0],
                             depth=ncdata['depth'][0],
                             instrument=args.instname)
except KeyError:
    t1 = p1.add_title(mooringid=global_atts['MOORING'],
                             lat=ncdata['latitude'][0],
                             lon=ncdata['longitude'][0],
                             depth=ncdata['depth'][0],
                             instrument=args.instname)  



if args.timebounds:
    time_ind = (np.array(cast_time) >= datetime.datetime.strptime(args.timebounds[0],'%Y-%m-%d') ) & \
                            (np.array(cast_time) <= datetime.datetime.strptime(args.timebounds[1],'%Y-%m-%d') ) 


    if args.sal_scale and args.temp_scale:
        plt, fig = p1.plot(var1=ncdata['S_41'][time_ind,0,0,0], 
                           var2=ncdata['T_20'][time_ind,0,0,0], 
                           var3=doy[time_ind],
                           args.sal_scale, args.temp_scale)

    else:
        # Figure out boudaries (mins and maxs)
        smin = ncdata['S_41'][:,0,0,0].min() - (0.01 * ncdata['S_41'][:,0,0,0].min())
        smax = ncdata['S_41'][:,0,0,0].max() + (0.01 * ncdata['S_41'][:,0,0,0].max())
        tmin = ncdata['T_20'][:,0,0,0].min() - (0.1 * ncdata['T_20'][:,0,0,0].max())
        tmax = ncdata['T_20'][:,0,0,0].max() + (0.1 * ncdata['T_20'][:,0,0,0].max())
        plt, fig = p1.plot(var1=ncdata['S_41'][time_ind,0,0,0], 
                           var2=ncdata['T_20'][time_ind,0,0,0], 
                           var3=doy[time_ind],
                            [smin, smax], [tmin, tmax])

    t = fig.suptitle(ptitle, fontsize=12, fontweight='bold')
    t.set_y(1.08)
    DefaultSize = fig.get_size_inches()
    fig.set_size_inches( (DefaultSize[0], DefaultSize[1]) )
    plt.savefig('images/TS_plot_'+ args.DataPath.split('/')[-1] + '_' + args.timebounds[2] + '.png', bbox_inches='tight', dpi = (300))
    plt.close()


else:

    if args.sal_scale and args.temp_scale:
        plt, fig = p1.plot(var1=ncdata['S_41'][:,0,0,0], 
                           var2=ncdata['T_20'][:,0,0,0], 
                           var3=doy[:],
                           args.sal_scale, args.temp_scale)
    else:
        # Figure out boudaries (mins and maxs)
        smin = ncdata['S_41'][:,0,0,0].min() - (0.01 * ncdata['S_41'][:,0,0,0].min())
        smax = ncdata['S_41'][:,0,0,0].max() + (0.01 * ncdata['S_41'][:,0,0,0].max())
        tmin = ncdata['T_20'][:,0,0,0].min() - (0.1 * ncdata['T_20'][:,0,0,0].max())
        tmax = ncdata['T_20'][:,0,0,0].max() + (0.1 * ncdata['T_20'][:,0,0,0].max())
        plt, fig = p1.plot(var1=ncdata['S_41'][:,0,0,0], 
                           var2=ncdata['T_20'][:,0,0,0], 
                           var3=doy[:],
                           [smin, smax], [tmin, tmax], ptitle)

        
    t = fig.suptitle(ptitle, fontsize=12, fontweight='bold')
    t.set_y(1.08)
    DefaultSize = fig.get_size_inches()
    fig.set_size_inches( (DefaultSize[0], DefaultSize[1]) )
    plt.savefig('images/TS_plot_'+ args.DataPath.split('/')[-1] + '.png', bbox_inches='tight', dpi = (300))
    plt.close()




    

