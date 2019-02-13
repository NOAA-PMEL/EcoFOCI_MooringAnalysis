#!/usr/bin/env

"""
plot_ADCP.py


"""
#System Stack
import datetime, sys
import argparse

#Science Stack
from netCDF4 import Dataset
import numpy as np

# Visual Stack
import matplotlib
#matplotlib.use('Agg') 
import matplotlib.pyplot as plt
from matplotlib.dates import MonthLocator, DateFormatter, DayLocator
import matplotlib.ticker as ticker

__author__   = 'Shaun Bell'
__email__    = 'shaun.bell@noaa.gov'
__created__  = datetime.datetime(2014, 9, 11)
__modified__ = datetime.datetime(2014, 9, 11)
__version__  = "0.1.0"
__status__   = "Development"
__keywords__ = 'CTD', 'SeaWater', 'Cruise', 'derivations'

"""--------------------------------netcdf Routines---------------------------------------"""

def get_global_atts(nchandle):

    g_atts = {}
    att_names = nchandle.ncattrs()
    
    for name in att_names:
        g_atts[name] = nchandle.getncattr(name)
        
    return g_atts

def get_vars(nchandle):
    return nchandle.variables

def get_var_atts(nchandle, var_name):
    return nchandle.variables[var_name]

def ncreadfile_dic(nchandle, params):
    data = {}
    for j, v in enumerate(params): 
        if v in nchandle.variables.keys(): #check for nc variable
                data[v] = nchandle.variables[v][:]

        else: #if parameter doesn't exist fill the array with zeros
            data[v] = None
    return (data)

def repl_var(nchandle, var_name, val=1e35):
    if len(val) == 1:
        nchandle.variables[var_name][:] = np.ones_like(nchandle.variables[var_name][:]) * val
    else:
        nchandle.variables[var_name][:] = val
    return

"""--------------------------------time Routines---------------------------------------"""

def date2pydate(file_time, file_time2=None, file_flag='EPIC'):


    if file_flag == 'EPIC':
        ref_time_py = datetime.datetime.toordinal(datetime.datetime(1968, 5, 23))
        ref_time_epic = 2440000
    
        offset = ref_time_epic - ref_time_py
    
       
        try: #if input is an array
            python_time = [None] * len(file_time)

            for i, val in enumerate(file_time):
                pyday = file_time[i] - offset 
                pyfrac = file_time2[i] / (1000. * 60. * 60.* 24.) #milliseconds in a day
        
                python_time[i] = (pyday + pyfrac)

        except:
    
            pyday = file_time - offset 
            pyfrac = file_time2 / (1000. * 60. * 60.* 24.) #milliseconds in a day
        
            python_time = (pyday + pyfrac)
        
    else:
        print "time flag not recognized"
        sys.exit()
        
    return np.array(python_time)
"""--------------------------------main Routines---------------------------------------"""

parser = argparse.ArgumentParser(description='ADCP plotting')
parser.add_argument('DataPath', metavar='DataPath', type=str,
               help='full path to file')
parser.add_argument("-fp",'--full_path', action="store_true", help='provides full path to program: used if run as script')
parser.add_argument("-od",'--one_dim', action="store_true", help='flag for one dimensional data')
parser.add_argument("-td",'--two_dim', action="store_true", help='flag for two dimensional data')
parser.add_argument("-rot",'--rotate', nargs='+', type=int, help='rotate currents by xx degrees')
parser.add_argument("-mt",'--manual_timebounds', nargs='+', type=str, help='set times to specified values (d-m-Y)')
          
args = parser.parse_args()

#read in rcm data file
ncfile1 = args.DataPath

nchandle = Dataset(ncfile1,'a')
global_atts = get_global_atts(nchandle)
vars_dic = get_vars(nchandle)
data1 = ncreadfile_dic(nchandle,vars_dic.keys())
nchandle.close()
time1 = date2pydate(data1['time'],data1['time2'])

### Single Depth Value (from mooring logs and records)
try:
    ptitle = ("Plotted on: {0} \n from {1} "
          "Lat: {2:3.3f}  Lon: {3:3.3f} Depth: {4}\n : rcm").format(datetime.datetime.now().strftime('%Y/%m/%d %H:%M'), 
                                          global_atts['MOORING'], data1['lat'][0], data1['lon'][0], data1['depth'][0] )
except:
   ptitle = ("Plotted on: {0} \n from {1} "
      "Lat: {2:3.3f}  Lon: {3:3.3f} Depth: {4}\n : rcm").format(datetime.datetime.now().strftime('%Y/%m/%d %H:%M'), 
                                      global_atts['MOORING'], data1['latitude'][0], data1['longitude'][0], data1['depth'][0] )
 
if args.one_dim:
    #### Plot quiver for velocity and currents
    try:
        ucomp = data1['u_1205'][:,0,0,0]
        vcomp = data1['v_1206'][:,0,0,0]
    except KeyError:
        ucomp = data1['U_320'][:,0,0,0]
        vcomp = data1['V_321'][:,0,0,0]

    #exchange 1e35 for 0
    ucomp[ucomp >= 1e30] = np.nan
    vcomp[vcomp >= 1e30] = np.nan

    magnitude = np.sqrt(ucomp**2 + vcomp**2)

    # Plot quiver
    fig = plt.figure(1)
    ax1 = fig.add_subplot(211)
    ax2 = fig.add_subplot(212)
    # Plot u and v components
    # Plot quiver
    ax1.set_ylim(-magnitude.max(), magnitude.max())
    fill1 = ax1.fill_between(time1, magnitude, 0, color='k', alpha=0.1)

    # Fake 'box' to be able to insert a legend for 'Magnitude'
    p = ax1.add_patch(plt.Rectangle((1,1),1,1,fc='k',alpha=0.1))
    leg1 = ax1.legend([p], ["Current magnitude [cm/s]"],loc='lower right')
    leg1._drawFrame=False

    # 1D Quiver plot
    q = ax1.quiver(time1,0,ucomp,vcomp,color='r',units='y',scale_units='y',
                   scale = 1,headlength=1,headaxislength=1,width=0.04,alpha=.95)
    qk = plt.quiverkey(q,0.2, 0.05, 5,r'$5 \frac{cm}{s}$',labelpos='W',
                   fontproperties={'weight': 'bold'})

    # Plot u and v components
    ax1.set_xticklabels(ax1.get_xticklabels(), visible=False)
    ax2.set_xticklabels(ax2.get_xticklabels(), visible=True)
    ax1.axes.get_xaxis().set_visible(False)
    if args.manual_timebounds:
        min_t = datetime.datetime.strptime(args.manual_timebounds[0],'%d-%m-%Y').toordinal()
        max_t = datetime.datetime.strptime(args.manual_timebounds[1],'%d-%m-%Y').toordinal()
        ax1.set_xlim(min_t,max_t)
    else:
        ax1.set_xlim(time1.min(),time1.max()+0.5)
    ax1.set_ylabel("Velocity (cm/s)")
    ax2.plot(time1, vcomp, 'b-')
    ax2.plot(time1, ucomp, 'g-')
    if args.manual_timebounds:
        min_t = datetime.datetime.strptime(args.manual_timebounds[0],'%d-%m-%Y').toordinal()
        max_t = datetime.datetime.strptime(args.manual_timebounds[1],'%d-%m-%Y').toordinal()
        ax2.set_xlim(min_t,max_t)
    else:
        ax2.set_xlim(time1.min(),time1.max()+0.5)
    ax2.set_xlabel("Date (UTC)")
    ax2.set_ylabel("Velocity (cm/s)")
    ax2.xaxis.set_major_locator(MonthLocator())
    ax2.xaxis.set_major_formatter(DateFormatter('%b %Y'))
    ax2.xaxis.set_minor_locator(DayLocator())
    ax1.spines['bottom'].set_visible(False)
    ax2.spines['top'].set_visible(False)
    ax1.xaxis.set_ticks_position('top')
    ax2.xaxis.set_ticks_position('bottom')
    ax2.yaxis.set_ticks_position('both')

    # Set legend location - See: http://matplotlib.org/users/legend_guide.html#legend-location
    leg2 = plt.legend(['v','u'],loc='upper left')
    leg2._drawFrame=False

    t = fig.suptitle(ptitle)
    t.set_y(0.06)

    fig.autofmt_xdate()
    DefaultSize = fig.get_size_inches()
    fig.set_size_inches( (DefaultSize[0]*2, DefaultSize[1]) )
    if not args.full_path:
        plt.savefig('images/'+ ncfile1.split('/')[-1] + '_quiver.png', bbox_inches='tight', dpi = (300))
    else:
        fullpath = '/Users/bell/Programs/Python/MooringDataProcessing/adcp/plotting/'
        plt.savefig(fullpath + 'images/'+ ncfile1.split('/')[-1] + '_adcp_quiver.png', bbox_inches='tight', dpi = (300))
    plt.close()

if args.two_dim:
    ### Quiver / Stick plot
    # Plot quiver
    n_bins = len(data1['depth'])
    #max 8 bins per plot for good scaling
    for m_page_bins in range(0,(n_bins % 8)+1):
        n_bins = 8
        fig = plt.figure(1)
        for i2,d2 in enumerate(data1['depth'][m_page_bins*n_bins:(1+m_page_bins)*n_bins -1]):
            print "Working on {0}".format(d2)
            ax1 = fig.add_subplot(n_bins,1,i2+1)

            #### Plot quiver for velocity and currents
            ucomp = data1['u_1205'][:,m_page_bins*n_bins+i2,0,0]
            vcomp = data1['v_1206'][:,m_page_bins*n_bins+i2,0,0]

            ###rotate based on deepest comparison
            if args.rotate:
                angle_offset_rad = np.deg2rad(args.rotate[0])
                ucomp = ucomp*np.cos(angle_offset_rad) + vcomp*np.sin(angle_offset_rad)
                vcomp = -1*ucomp*np.sin(angle_offset_rad) + vcomp*np.cos(angle_offset_rad)


            #exchange 1e35 for 0
            ucomp[ucomp >= 1e30 ] = np.nan
            vcomp[vcomp >= 1e30 ] = np.nan

            # 1D Quiver plot
            q = ax1.quiver(time1,0,ucomp,vcomp,color='r',units='y',scale_units='y',
                           scale = 1,headlength=2,headaxislength=2,width=0.6,alpha=.95)
            qk = plt.quiverkey(q,0.2, 0.05, 5,r'$5 \frac{cm}{s}$',labelpos='W',
                           fontproperties={'weight': 'bold'})

            ax1.set_ylim(np.nanmin(vcomp), np.nanmax(vcomp))
            ax1.set_ylabel("(cm/s) "+str(d2)+" m")
            ax1.set_xlim((time1.min()),(time1.max()))
            ax1.xaxis.set_major_locator(MonthLocator())
            ax1.xaxis.set_minor_locator(MonthLocator(bymonth=range(1,13), bymonthday=15))
            ax1.xaxis.set_major_formatter(ticker.NullFormatter())
            ax1.xaxis.set_minor_formatter(DateFormatter('%b %y'))
            ax1.tick_params(axis='both', which='minor', labelsize=12)

        t = ax1.set_xlabel('Vector Current', fontsize=12)

        DefaultSize = fig.get_size_inches()
        fig.set_size_inches( (DefaultSize[0]*2, DefaultSize[1]*6) )
        if not args.full_path:
            plt.savefig('images/'+ ncfile1.split('/')[-1] + '_quiver.png', bbox_inches='tight', dpi = (300))
        else:        
            fullpath = '/Volumes/WDC_internal/Users/bell/Programs/Python/MooringDataProcessing/adcp/plotting/'
            plt.savefig(fullpath + 'images/'+ ncfile1.split('/')[-1] + '_' +str(m_page_bins) + '_adcp_quiver.png', bbox_inches='tight', dpi = (300))
        plt.close()
        #plt.show()